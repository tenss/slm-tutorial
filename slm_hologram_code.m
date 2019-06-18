function [I, I_history] = slm_hologram_code(twoPi, xy, fname)

% load image
im = imread(fname);
% make target image by inverting source
target = zeros(xy(1),xy(2));
im = im(:,:,1);
im = 255-im;
imPadded = target;
imPadded(1:size(im,1), 1:size(im,2)) = im;
im = imPadded;
target(1:size(im,1), 1:size(im,2)) = im;

target=target/255;

figure;
% plot target image
subplot(1,3,1);
imagesc(target)
title('Target image')
colormap(gray)
axis off equal
xlim([0 512]);
ylim([0 512]);

% start with random phases in SLM plane
A=exp(1i * rand(size(im)) * 2 * pi);

% number of iterations for optimization
nIter = 100;

for iter = 1:nIter
    % calculate the pattern in Fourier plane
    B = fftshift(fft2(A));
    % keep phases, set intensities to target
    B_= target .* exp(1i * angle(B));
    % calculate inverse Fourier transform - back to SLM plane
    A = ifft2(ifftshift(B_));
    % set amplitudes to 1
    A = exp(1i * angle(A));
    
    I_history{iter} = uint8(twoPi * mod(angle(A)+pi,2*pi) / (2*pi));
end

%A = exp(1i * angle(A) * .8);


h=subplot(1,3,2);
imagesc(angle(A))
title('angle(A)')
colormap(h,hsv);
axis off equal
xlim([0 512]);
ylim([0 512]);

subplot(1,3,3);
imagesc(abs(fftshift(fft2((A)))))
title('fft2(A)')
axis off equal
xlim([0 512]);
ylim([0 512]);

% convert phases to uint8

I = uint8(twoPi * mod(angle(A)+pi,2*pi) / (2*pi));

imwrite(I,['tenss.tiff'],'tiff');
