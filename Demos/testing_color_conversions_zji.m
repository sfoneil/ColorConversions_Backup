% New Color Conversion's code----------------------------------------------
clear
close all
%% load colorInfo2
% zji: is there a colorInfo2 file for the display at renown?

% load('testing_colorInfo2_renown_south_meadows.mat');

%% observer data from minimum motion task
% zji: i'm not sure how to incorporate these measures into the colour
% coordinate calcs.
load home_not_light_controlled.mat

lumAmp = [    0.0200   -0.1400
    -0.0700    0.2000
    0.1900   -0.1700
    0.1900    0.1900];

lumAveLM = 0.0825;
lumAveS = 0.0200;
mm = [lumAveLM, lumAveS 0];
%%% Ranges -0.2:0.01:0.2

%% convert specified DKL angles to RGB values.
% zji: i've modified some code that MW used previously to convert between DKL
% and RGB. I've commented most things out, but have now inserted the
% 'dkl2rgb' script into the loop below.

% I'm pretty sure I'm inputting the wrong values since the input for 0
% degrees in DKL space ends up being [0 1 0] in RGB.

%loop for different hue angles
% ival = 1;

% RGBAll=[];
% ColAngles_RGB_All=[];

rgbBack = [0.5 0.5 0.5];
step = 45;
colangle = 0:step:360-step; %%% No need to loop

% 0:22.5:360 %original increment was 10.
%%% Constants
contrast = 0.1863;   % Max contrast for my monitor, determined by dklGamut()
%contrast = 0.1851;   % Max contrast w/ MM settings
contrast = dklGamut('MinimumMotion', mm, 'StepSize', step); % Optional, could be slow so can hardcode after you know it
%luminance = 0;      % isoluminant plane (-90,0,90);
luminance = zeros(size(colangle))'; %%%

LMval = contrast * cosd(colangle)';
Sval = contrast * sind(colangle)';

%% Individual data
% This will be an argument into dkl2rgb() in the future, but might make
% more programming sense to show it separately now

% Note: changed default order of values to that used by MWLab=[LM SLM Lum]
DKL = [LMval Sval luminance];
DKLadj = adjustAngles(DKL, 'Contrast', contrast, 'MinimumMotion', mm);

% Get DKL, minimum motion luminance adjusted DKL
[RGB, Sat, Orig] = dkl2rgb(rgbBack, DKL);
[mmRGB, mmSat, mmOrig] = dkl2rgb(rgbBack, DKLadj);

%% Plot
figure('units', 'normalized', 'OuterPosition',[0 0 1 1]);
xlabel('L-M')
t = tiledlayout(1,2);
t.TileSpacing = 'compact';
t.Padding = 'compact';

% Plot original RGB
nexttile
axis([-contrast-.05 contrast+.05 -contrast-.05 contrast+.05])
axis square
hold on
for i = 1:size(colangle,2)
    plot(LMval(i), Sval(i), 'Marker', 'o', 'LineStyle', 'none', 'MarkerSize', 50, ...
        'MarkerFaceColor', RGB(i,:), 'Color','none')
    lbl = sprintf('(%3.0f, %3.0f, %3.0f)', ...
        RGB(i,:).*255);
    text(LMval(i)-0.025, Sval(i)-0.025, lbl);
    %pause(0.5)
end
title('Original RGB')

% Plot adjusted RGB
nexttile
axis([-contrast-.05 contrast+.05 -contrast-.05 contrast+.05])
axis square
hold on
for i = 1:size(colangle,2)
    plot(LMval(i), Sval(i), 'Marker', 'o', 'LineStyle', 'none', 'MarkerSize', 50, ...
        'MarkerFaceColor', mmRGB(i,:), 'Color','none')
    lbl = sprintf('(%3.0f, %3.0f, %3.0f)', ...
        mmRGB(i,:).*255);
    text(LMval(i)-0.025, Sval(i)-0.025, lbl);
    %   pause(0.5)
end

% Axis titles
title('Minimum Motion RGB')
xlabel(t, 'L-M');
ylabel(t, 'S-L+M');

%     % Convert from myspace coordinates to the LMS values
%     Lresp = LMval / 2754 + 0.6568;
%     Mresp = 1 - Lresp;
%     Sresp = Sval / 4099 + .01825;
%     coneresp = [Lresp Mresp Sresp]';
%
%     % Get the RGB values for the color signal to display the color
%     RGB = LMStoRGB*coneresp.*luminance;
% %     RGB(1) = RGB(1)*.46/.73; % red luminance correction?
%     RGB = max(0,RGB);
%     RGB = min(1,RGB);

%%%RGBAll=[RGBAll;rgb];

%     x1 = 2*LMval+256;
%     y1 = 512-(2*Sval+256);
%     spotrad = 15;            % Original spotrad value was 15
%  rectangle('Position',[x1-spotrad,y1-spotrad,spotrad*2,spotrad*2],'FaceColor',RGB', 'curvature', [1,1])

% Save coordinates for plotting
%     LMplot(ival) = LMval;
%     Splot(ival) = Sval;
%     ival = ival+1;
%
%     ColAngles_RGB_All = [ColAngles_RGB_All; colangle]; % Acquires the colangles of RGB values.
%end