function dkl = dklGamut_fromrgb()
load Renown_South_Meadows_VPixx.mat
r = [1 0 0];
g = [0 1 0];
b = [0 0 1];
rgb = [r; g; b];
background = [.5 .5 .5];
dkl = rgb2dkl(background, rgb);
end