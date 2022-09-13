%function plotMM()
%PLOTMM Demo for minimum motion plotting
%   Detailed explanation goes here
clear
close all
load home_not_light_controlled.mat

% Parameters you can adjust
minimummotion = [0.0825, 0.0200 0]; % Default [0 0 0]
minimummotion = [0.0275, -0.0325, 0];
rotation = [10 88];                 % Default [0 90
rotation = [0 90];

angleStep = 15;
axisSteps = 10;

contrast = 0.1863;   % Max contrast for my monitor, determined by dklGamut()
contrast = dklGamut('MinimumMotion', minimummotion, 'StepSize', angleStep); % Optional, could be slow so can hardcode after you know it
rgbBack = [0.5 0.5 0.5];

% Make grids
LM = linspace(-contrast,contrast,axisSteps);
SLM = linspace(-contrast,contrast, axisSteps);
[x,y] = meshgrid(LM, SLM);
sh = size(x); % Save shape for later
lum = zeros(sh); 
DKL = [x(:), y(:), lum(:)]; % Unpack to Nx1

%% Minimum motion
DKLadj = adjustAngles(DKL, 'Contrast', contrast, 'MinimumMotion', minimummotion, 'RotationAngles', rotation);
lumAdj = reshape(DKLadj(:,3), sh);
[RGB, satFlag, RGBunclamped] = dkl2rgb(rgbBack, DKLadj);

%% Plot
figure
cMap = reshape(RGB, [sh 3]);
p=surf(x, y, lum, cMap, 'FaceAlpha', 0.3);
hold on
mmp = surf(x, y, lumAdj, cMap, 'FaceAlpha', 0.8);
xlabel('L-M')
ylabel('S-L+M')
zlabel('Luminance L+M')
axBounds = contrast + 0.1;
axis([-axBounds axBounds -axBounds axBounds -axBounds axBounds])
axis square
%end

