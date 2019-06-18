Screen('Preference', 'SkipSyncTests', 1);

window = Screen('OpenWindow',1);

white = WhiteIndex(window);

black = BlackIndex(window); 
%%
Screen(window, 'FillRect',0)
Screen(window,'Flip'); 

twoPi = 127;
%%
resX = 800;
resY = 600;
[x,y] = meshgrid(0:resX-1, 0:resY-1);
pixPeriod = 10;
image =  ((mod(x+y,pixPeriod))>=pixPeriod/2) * twoPi;

Screen(window, 'PutImage',image);

Screen(window,'Flip'); 

%%
resX = 800;
resY = 600;
[x,y] = meshgrid(0:resX-1, 0:resY-1);
rampRate = 40;
image =  mod(x*rampRate,twoPi);

Screen(window, 'PutImage',image);

Screen(window,'Flip'); 
%%
for i = 1:30

    image =  sin(0.01*2*pi*(x+i/30*100));

    texture(i) = Screen(window, 'MakeTexture', image);

end

%%
for i = 1:30

    Screen('DrawTexture', window, texture(i));

    Screen(window,'Flip');
    pause(1)
end 

%%
twoPi = 125;
I = slm_hologram_code(124, [600 800],'tenss2.png');
Screen(window, 'PutImage',mod(I, twoPi));

    Screen(window,'Flip'); 

%%
dist = sqrt((x-400).^2 + (y-300).^2);

power = .1;
fresnelLens = dist.^2 * power;
fresnelLens = uint8(mod(dist.^2 * power, twoPi));

Screen(window, 'PutImage',mod(I + fresnelLens, twoPi));

Screen(window,'Flip'); 