


clear
close all

% Load color info from measurement
load('EMM106C_EEG.mat');

% Standard illuminants
load('illuminants.mat');

%% Put up background image
[cieluvplot, ~, alpha] = imread(strcat(pwd, '\Images\cieluvtrim.png'));
% alpha = repmat(alpha, [1 1 3]); % Resize alpha to image
alpha = im2double(alpha);
cImg = im2double(cieluvplot) .* alpha;
cImg = flipud(cImg); % Flip along with 'axis xy' below makes origin lower left
imSize = size(cImg); imSize = [imSize(2), imSize(1)]; % Switch RxCxBit to XxY
figure(11)
hold on
imshow(cImg);
%axis xy
axis on
set(gca, 'YDir', 'normal')

%% Redo axes from pixels
xAxisTicks = 0:0.1:0.6; % What the actual u' v' ticks are
yAxisTicks = 0:0.1:0.6;
boxSize = imSize(2) ./ (numel(xAxisTicks) - 1);
XuvPixels = 1:boxSize:2000; % 307 pixels per 0.1 uv
YuvPixels = 1:boxSize:2000; % 307 pixels per 0.1 uv
set(gca, 'XTick', XuvPixels, 'XTickLabel', xAxisTicks, ...
    'YTick', YuvPixels, 'YTickLabel', yAxisTicks)

%% Draw grid (optional)
hold on
x = [1 2000];
for xLines = boxSize:boxSize:2000
    y = [xLines xLines];
    plot(x,y,'w')
end
y = [1 2000];
for yLines = boxSize:boxSize:2000
    x = [yLines yLines];
    plot(x,y,'w')
end

%% Define start values
% Define some arbitrary RGB colors
RGBs = struct();
RGBs.red = [1 0 0];
RGBs.green = [0 1 0];
RGBs.blue = [0 0 1];
% RGBs.yellow = [1 1 0];
RGBs.white = [1 1 1];
% RGBs.seafoam = [81 255 211]./255;

%RGBW
rgb = [1 0 0;
    0 1 0;
    0 0 1;
    1 1 1]
%rgb = [rgb; [1 1 0]; [81 255 211]./255];

%fn = fieldnames(RGBs);
%uvs = struct();

% For DKL
backgroundRGB = [0.5 0.5 0.5];
backgroundLMS = rgb2lms(backgroundRGB);

% Misc
border = [0 0 0]; % Edge of markers

%% Loop to display each point
%for i = 1:numel(fn)

    lms = rgb2lms(rgb);

    % Get DKL, either from previous lms or full conversion
    % Note: background is either RGB or LMS depending on the conversion for
    % consistency.
    dkl = rgb2dkl(backgroundRGB, rgb);
    dkl2 = lms2dkl(backgroundLMS, lms);
    fprintf('\n******************************\n')
    fprintf('DKL direct = \t%4.4f %4.4f %4.4f\n', dkl);
    fprintf('DKL steps = \t%4.4f %4.4f %4.4f\n', dkl2);
    fprintf('\n');

    % XYZ, note that many conversions use a standard like sRGB
    xyz = rgb2xyz(rgb);
    %xyz = xyz/xyz(2);
    fprintf('XYZ = \t\t%4.4f %4.4f %4.4f\n', xyz);

    % Get Luv, same deal
    [luv, chrom] = rgb2luv(rgb);
    %uvs = chrom;
    % Identical:
    %       [luv, chrom] = rgb2luv(rgb, 'WhitePoint', 'D65_2');

    % Check 2-step conversion too.
    [luv2, chrom2] = xyz2luv(xyz);
    fprintf('L*u*v* 1 = \t%4.4f %4.4f %4.4f\n', luv);
    fprintf('u''v'' 1 = \t%4.4f %4.4f\n', chrom);
    fprintf('L*u*v* 2 = \t%4.4f %4.4f %4.4f\n', luv2);
    fprintf('u''v'' 2 = \t%4.4f %4.4f\n', chrom2);
    fprintf('\n');

    % Above used si.d65_2, D65 2-degree standard illuminant
    % Here's a few more
    [luv_d65_10, chrom_d65_10] = rgb2luv(rgb, 'WhitePoint', 'd65_10'); %D65 10 degree
    [luv_e, chrom_e] = rgb2luv(rgb, 'whitepoint', 'e'); %C, args not case sensitive

%     chrom = [    0.3976    0.4752
%     0.3603    0.4430
%     0.2035    0.4100
%     0.1007    0.4644
%     0.0859    0.5081
%     0.0955    0.5182
%     0.1925    0.5051
%     0.3412    0.4891];

    linez = [chrom(1:3,:); chrom(1,:)];
    % Now let's plot the Luv
    for colorPts = 1:size(chrom,1)
        hold on
        plot(linez(:,1) * 10 * boxSize, linez(:,2) * 10 * boxSize, 'k-');
        plot(chrom(colorPts,1) * 10 * boxSize, chrom(colorPts,2) * 10 * boxSize, ...
            'Marker', 'o', 'MarkerFaceColor', rgb(colorPts,:), 'MarkerEdgeColor', border, ...
            'MarkerSize', 10, 'LineStyle', '-');
    end

    % Optional: because this is device-dependent, for simply display you may
    % want to use standards instead for non-experimental visualization
    % instead
%    xyz2 = srgb2xyz(rgb);
  %  xyz2 = xyz2/xyz2(2);
   % [luvv, chr] = xyz2luv(xyz); % Have to do 2 steps, will implement full
    %   conversions in future if needed
    % Plots mostly the same in this case

    % Finally let's check the conversions by reverting back to RGB
    xyz2 = luv2xyz(luv);
    xyz2 = xyz2/xyz2(2);
    rgbFromLuv = xyz2rgb(xyz2);
    rgbFromDKL = dkl2rgb(backgroundRGB, dkl);
    fprintf('XYZ comparison: \t\t%4.4f %4.4f %4.4f == ', xyz);
    fprintf('%4.4f %4.4f %4.4f\n', xyz2);
    fprintf('Luv-RGB comparison: \t%4.4f %4.4f %4.4f == ', rgb);
    fprintf('%4.4f %4.4f %4.4f\n', rgbFromLuv);
    fprintf('DKL-RGB comparison: \t%4.4f %4.4f %4.4f == ', rgb);
    fprintf('%4.4f %4.4f %4.4f\n', rgbFromDKL);
    fprintf('\n');

%end