%OBSOLETE

% This program is an example highlighting use of common color conversion functions.

clear
close all

% Add paths
addpath(strcat(pwd,'\Main_functions\'))
addpath(strcat(pwd,'\Fundamentals\'))
addpath(strcat(pwd,'\Recorded monitor phosphors\'))

%% Intro

fprintf(['\n\n\nStandard computers and monitors usually create colors using an RGB space like sRGB.\n' ...
    'These spaces do not allow things like independent adjustment of luminance without changing chromaticity,\n' ...
    'and are also are device-dependent.\n\n'])
fprintf(['This toolbox allows you to convert colors in your experiment to various spaces.\n' ...
    'It might be typically used like:\n\t1) Get color shown on screen in RGB values\n\t' ...
    '2) Convert to a working space like DKL, L*a*b*\n\t3) Change DKL in response to participant input\n\t' ...
    '4) Convert DKL back to RGB and update screen\n\t5) Repeat for each trial\n\n'])

%% Pick color
fprintf(['As an example, we will pick an RGB color\n\n' ...
    '**********Press ENTER**********\n\n']);
input('');
c = uisetcolor;

fprintf('The color you chose in percentage values is: (%4.2f, %4.2f, %4.2f)\n', c);
fprintf('Or in standard 8-bit RGB values, (%2.0f, %2.0f, %2.0f)\n', c.*255);
fprintf('\n**********Press ENTER**********\n\n');
input('')

fprintf(['To do the next steps, we will need to load information about your display device\n' ...
    'and the physiological models you want to apply.\n\nThese data are:\n']);
fprintf('\t1) Color fundamentals representing human visual response.\n');
fprintf('\t\tThis will by default pick Stockman & Sharpe''s (2000) CFs.\n' );
fprintf('\t\t>> load StockmanSharpe_lin_2deg.mat\n\n')
load StockmanSharpe_lin_2deg.mat

fprintf(['\t2) The full output from a single monitor. We''re using an example from a standard CRT monitor.\n' ...
    '\tIt was recorded using a Photo Research PR-655 device, with wavelengths 380 to 780 nm in 4 nm steps.\n']) ...

fprintf('\t\t>> load MSS310_crt_phosphors.mat\n\n')
load MSS310_crt_phosphors.mat
fprintf(['You can supply your own fundamentals or monitor information and it will override any defaults.\n' ...
    'You may use any other measurement devices and the program will adapt to different wavelength ranges and intervals.\n\n'])

fprintf('\n**********Press ENTER**********\n');
input('')

%% CIE1931
fprintf(['RGB can be converted to different color spaces.\n' ...
    'Here is an approximation using the common CIE1931 xyY color space of a RGB monitor gamut and your chosen color.\n\n']);

fprintf(['Code broken down is:\n\n' ...
    '\t>> rRange = rgb2xyy(phosphors, cfs, [1 0 0]);\n' ...
    '\t>> gRange = rgb2xyy(phosphors, cfs, [0 1 0]);\n' ...
    '\t>> bRange = rgb2xyy(phosphors, cfs, [0 0 1]);\n' ...
    '\t>> my1931Choice = rgb2xyy(phosphors, cfs, c);\n\n'])
% xyY(1, :) = rgb2xyy(phosphors, cfs, [1 0 0]);
% xyY(2 ,:) = rgb2xyy(phosphors, cfs, [0 1 0]);
% xyY(3, :) = rgb2xyy(phosphors, cfs, [0 0 1]);
xyYPrimaries(1, :) = rgb2xyy([1 0 0]);
xyYPrimaries(2 ,:) = rgb2xyy([0 1 0]);
xyYPrimaries(3, :) = rgb2xyy([0 0 1]);

% For simplicity
ciePrimariesX = xyYPrimaries(:, 1)';
ciePrimariesY = xyYPrimaries(:, 2)'; % Don't need 3 right now for 2D plot

% Now the actual point chosen
ciePt = rgb2xyy(c);

% Approximations for testing
% ciex = [700 400 300]
% ciey = [600 400 800]

% Close triangle for plotting
ciePrimariesX(4) = ciePrimariesX(1);
ciePrimariesY(4) = ciePrimariesY(1);

% Show CIE with plotted extremes
figure(1)
[ciePlot, ~, cieAlpha] = imread('cie1931blank_trim.png', 'PNG');
ciePlot = flipud(ciePlot);
cieAlpha = flipud(cieAlpha);
image(ciePlot, 'AlphaData', cieAlpha)
axis equal
axis xy
%axis off
hold on
plot(ciePrimariesX * 1000, ciePrimariesY * 1000,'ko-')
plot(ciePt(1) * 1000, ciePt(2) * 1000, 'k^')

%sp = sum(phosphors(:,2:4),2);
fprintf('\n**********Press ENTER**********\n');
input('')

%% DKL intro
fprintf(['Now let''s convert to a functional space. Next is the the DKL space, which also uses 3 values:\n'...
    '\t1) L+M Luminance\n\t2) L-M or red vs. green\n\t3) S-LM or blue vs. yellow]\n\n']);
fprintf(['We will need to transition through an intermediate space, in this case the LMS space representing cone responses.\n' ...
    'This takes two steps and two function calls. However we can call a single "wrapper" function to simplify things on the user''s end.\n' ...
    'In fact, the rgb2xyy() function above was a wrapper for multiple steps.\n\n'])
fprintf(['This function''s syntax is:\n' ...
    '\t>> dkl = rgb2dkl(phosphors, cfs, backgroundRGBValues, rgbValuesYouWantToShow);\n\n'])

fprintf(['Where:\n\tphosphors = your monitor''s recorded output\n\tcfs = fundamentals, such as Stockman & Sharpe\n' ...
    '\tbackgroundRGBValues = a value for the "background" in reference to target DKL\n' ...
    '\trgbValuesYouWantToShow = a triplet such as [1 1 0] for yellow\n'])
fprintf('\tAll 4 of these values are mandatory and in must be in this order.\n')
fprintf('\n**********Press ENTER**********\n')
input('')

% Convert
fprintf(['For DKL you also need a reference background color. We will use medium grey or [0.5 0.5 0.5].\n' ...
    '\t>> dkl = rgb2dkl(phosphors, cfs, [0.5 0.5 0.5], c);\n\n' ...
    'Alternatively, you could use:\n\tlms = rgb2lms(phosphors, cfs, c);\n' ...
    '\t>> backgroundLMS = rgb2lms(phosphors, cfs, [0.5 0.5 0.5]);\n' ...
    '\t>> dkl = lms2dkl(backgroundLMS, lms);\n\n' ...
    '\tNote that for consistency lms2dkl() needs the lms version of medium grey, while\n' ...
    '\trgb2dkl() needs the RGB values for both inputs.\n\n'])

% Don't need: lmsBackground = rgb2lms(phosphors, cfs, [0.5 0.5 0.5]);
% It's already in function!!!
dkl = rgb2dkl(phosphors, cfs, [0.5 0.5 0.5], c);

fprintf('Resulting DKL values are:\n\n   Luminance: %4.2f\n   L-M: %4.2f\n   S-LM: %4.2f\n\n', dkl);
fprintf('Here it is plotted with the converted gamut:\n')
fprintf('\n**********Press ENTER**********\n\n')
input('')

% Show DKL plot
figure(2)
DKLimg = imread('DKL_space_blank.png');
DKLimg = flipud(DKLimg);
image(DKLimg)

% Set IMAGE origin to center
%DKLsize = size(DKLimg);
DKLsize = [344, 344, 3]; % Hardcoded - ignore gray border
DKLimgScale = [DKLsize(2) DKLsize(1)]; %x, y
DKLimgOrigin = DKLimgScale / 2;
%DKLax = gca;

gamut = findGamut(phosphors, cfs, [0.5 0.5 0.5]);
dklExtremes = abs(gamut);
gamut(:, 1) = []; %Remove L
% Set range so that 1 = largest value. Todo: refine
LMrange = max([min(dklExtremes(:,2)), max(dklExtremes(:,2))]);
Srange = max([min(dklExtremes(:,3)), max(dklExtremes(:,3))]);
vizScale = 0.1; %Change as needed, edge buffer for keeping extreme point constrained
dklRange = abs(max(LMrange, Srange)) + vizScale;

scaledGamutRel = gamut ./ dklRange;
scaledGamut = scaledGamutRel .* DKLimgOrigin + DKLimgOrigin;
scaledGamut(end + 1, :) = scaledGamut(1, :); %Close the triangle
axis equal
%axis xy
%axis off
hold on

plot(scaledGamut(:,1), scaledGamut(:,2), '-')
plot(scaledGamut(1,1), scaledGamut(1,2), 'o', 'MarkerFaceColor', [1 0 0])
plot(scaledGamut(2,1), scaledGamut(2,2), 'o', 'MarkerFaceColor', [0 1 0])
plot(scaledGamut(3,1), scaledGamut(3,2), 'o', 'MarkerFaceColor', [0 0 1])

scaledDKL = [dkl(2), dkl(3)] ./ dklRange; % Rescale so most extreme == 1
scaledDKL = scaledDKL .* DKLimgOrigin + DKLimgOrigin; %Convert to pixels

% Show point on DKL
plot(scaledDKL(1), scaledDKL(2), 'ko', 'MarkerSize', 7)

fprintf(['This space has somewhat arbitrary axes, the gamut was found by converting from R, G, B\n' ...
    'values via the\n\t>> findGamut(phosphors, cfs, [0.5 0.5 0.5])\nfunction.\n'])
%todo plot 3d
fprintf('\n**********Press ENTER**********\n\n')
input('')


% Explain optional values
fprintf('Advanced:\n')
fprintf(['The 4 above values are mandatory and need to be in that order.\n' ...
    'We can also include optional\n' ...
    '\n\t''PropertyName'', Value\n\n' ...
    'pairs in any order.\n\n']);
fprintf(['If these are not provided, it will assume default values.\n' ...
    'For example:\n' ...
    '\t>> dkl = rgb2dkl(phosphors, cfs, [0.5 0.5 0.5], c, ''Scale'', [1 0.8]]\n' ...
    '\tThis will not scale the L-M axis but will scale S-(L+M) to 80%%\n\n']);
fprintf(['Allowable ''PropertyName'', Value pairs and their default values include:\n' ...
    '\t''Scale'',\t[1 1]\t\t%%[L-M percent axis scale, S-(L+M) percent axis scale]\n' ...
    '\t''Rotation'',\t[0 0]\t\t%%Counterclockwise rotation degrees of [L-M, S-(M)]\n' ...
    '\t\tROrthogonalize axes, requires participant-specific data ' ...
    '\t''Origin'',\t[0 0]\t\t%%Shifted center of axes, will be derived from background color\n\n' ...
    '\tSee: help rgb2dkl for more info.\n\n']);

fprintf('**********Press ENTER**********\n')
input('')



fprintf(['You can call many more color space conversions, the format is fromspace2tospace\n' ...
    'e.g. lms2mb() will convert from LMS cone activations to MacLeod-Boynton color space.\n\n' ...
    'Supported color spaces for either direction include:\n\n'])
fprintf(['\trgb\t\tspectral data at any wavelength spacing\n\tlms\t\tlms cone activations\n' ...
    '\tmb\t\tMacLeod-Boynton space\n\tdkl\t\tDerrington-Krauskopf-Lennie space\n' ...
    '\trgb\t\tRGB tristimulus values\n\txyz\t\tCIE 1931 X, Y, Z space\n\txyy\t\tCIE 1931 x, y, Y(luminance) space\n' ...
    '\tluv\t\tCIE 1976 L*, u*, v* space\n\tlab\t\tCIE 1976 L*, a*, b* space\n\n'])
fprintf('**********Press ENTER**********')
input('')

%% Back conversion
fprintf(['Now let''s verify our conversions are correct.\nWe will convert back using:\n' ...
    '\t>> RGBcheck = dkl2rgb(phosphors, cfs, [0.5, 0.5, 0.5], dkl)\n\n'])
RGBcheck = dkl2rgb(phosphors, cfs, [0.5, 0.5, 0.5], dkl);
fprintf('Return values are:\n\t>> round(RGBcheck,2)\n\tR = %2.2f\n\tG = %2.2f\n\tB = %2.2f\n\n', round(RGBcheck(1),2),round(RGBcheck(2),2),round(RGBcheck(3),2))
fprintf(['While old requested values were:\n\t>> round(c,2);\n\tR = %2.2f\n\tG = %2.2f\n\tB = %2.2f\n'], round(c(1),2),round(c(2),2),round(c(3),2))


