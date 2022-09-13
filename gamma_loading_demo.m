% Demo for loading gamma tables and displaying correct values.
% You may also use Psychtoolbox functions (see: help PsychGamma) but this
% is assuming other uses, e.g. VR headset

clear
close all

load('home_not_light_controlled.mat') % Recorded monitor data

x = [1:256]';
figure(11)
plot(x, linspace(0,1,256), 'k--');
hold on
plot(x, gammaTable(:,1), 'r', x, gammaTable(:,2), 'g', x, gammaTable(:,3), 'b')

% Draw some examples
fprintf('If we show medium green (0, 128, 0), it should be 0.5x the max luminance of green.\n')
plot([128 128], [0 0.5], 'b:')
pause(5)
fprintf('But instead it falls short of the actual monitor output.\n')
plot([128 128], [0.5 gammaTable(128,2)], 'r:')
fprintf('\n')

fprintf(['So instead we need to request greater values, and the resulting color will be\n' ...
    'half as bright (cd/m^2) as full green (0, 255, 0)\n'])


%%
figure(21)
axis([0 100 0 100])
axis square
title('0.5 RGBGr Uncorrected vs corrected')

% Uncorrected, left column
text(5, 90, 'Uncorrected')
patch([10 20 20 10], [70 70 80 80], [0.5 0 0])
patch([10 20 20 10], [50 50 60 60], [0 0.5 0])
patch([10 20 20 10], [30 30 40 40], [0 0 0.5])
patch([10 20 20 10], [10 10 20 20], [0.5 0.5 0.5])


% Corrected, right column
text(65, 90, 'Corrected')
patch([70 80 80 70], [70 70 80 80], [gammaTable(0.5 * 256, 1), 0, 0])
patch([70 80 80 70], [50 50 60 60], [0, gammaTable(0.5 * 256, 1), 0])
patch([70 80 80 70], [30 30 40 40], [0, 0, gammaTable(0.5 * 256, 1)]);
patch([70 80 80 70], [10 10 20 20], [gammaTable(0.5 * 256, 1), gammaTable(0.5 * 256, 1), gammaTable(0.5 * 256, 1)])

% My measurements with PR-655 (uncontrolled settings + measuring error):
% [1 0 0]                       = 11.64 0.6363 0.3380
% [0.5 0 0]                     = 2.069 0.4999 0.3290
% Gamma [0.7168 0 0]            = 4.216 0.5854 0.4452
% Half of [1 0 0]               = 5.82

% [0 1 0]                       = 43.25 0.2972 0.6181
% [0 0.5 0]                     = 11.60 0.2953 0.5897
% Gamma [0 0.7246 0]            = 22.15 0.2968 0.6121
% Half of [0 1 0]               = 21.625

%% Blue
% [0 0 1]                       = 2.933 0.1503 0.0587
% [0 0 0.5]                     = 1.119 0.1570 0.0693
% Gamma [0 0 0.7077]            = 1.901 0.1521 0.0620
% Half of [0 0 1]               = 1.4665

%% White
% [1 1 1]                       = 47.01 0.3197 0.3382
% [0.5 0.5 0.5]                 = 12.72 0.3104 0.3283
% Gamma [0.7168 0.7246 0.7077]  = 24.90 0.3132 0.3308
% Half of [1 1 1]               = 23.505