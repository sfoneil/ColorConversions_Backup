clear

folder = fileparts(which(mfilename));
addpath(genpath(folder)); % Add all subfolders, may want to change/constrain in future
% addpath(strcat(pwd, '\Main_functions\'));
% addpath(strcat(pwd, '\Fundamentals\'));
% addpath(genpath(pwd, '\Recorded monitor phosphors\'));
% addpath(genpath(pwd, '\Recorded monitor phosphors\Fove VR Output\'));

% Load monitor information (Fove 0 VR headset)
% The recorded phosphors have been added to a colorInfo2 struct from a DIFFERENT screen.
% Therefore, colorInfo2.Phosphors contains RGB recorded from Fove, but the
% other variables are INACCURATE.
% Our display measuring function gamma, matrix calculation, etc. has been
% updated to also measure the three spectra, so future measurements will
% provide accurate colorInfo

load SO_work_PC_not_dark.mat
load EMM310_CRT.mat
 
fprintf('\n\n\n');



%% Create data structure for storing conversions, can change these
allConvs = {'RGB', 'LMS', 'DKL', 'XYZ', 'xyY', 'Luv', 'Lab'}; % Names for rows in table
s = struct();
RGB = [1 0 0];
bkgdRGB = [0.5 0.5 0.5];
bkgdLMS = rgb2lms(bkgdRGB);

%% LMS
origLMS = rgb2lms(RGB); % Convert to LMS
back = lms2rgb(origLMS);  % Convert back to RGB, values should be same as original.
fprintf('RGB = \t\t[%4.4f, %4.4f, %4.4f]\nLMS = \t\t[%4.4f, %4.4f, %4.4f]\nrevRGB = \t[%4.4f, %4.4f, %4.4f]\n\n', RGB, origLMS, back);
fprintf('********************\n\n');

%% MB
% mb = lms2mb(lms);
% back = mb2lms(mb);
% fprintf('LMS = \t\t[%4.4f, %4.4f, %4.4f]\nrevMB = \t[%4.4f, %4.4f, %4.4f]\n\n*****\n\n', rgb, lms, back);

%% DKL
dkl = lms2dkl(bkgdLMS, origLMS); % Convert previous LMS to DKL
revLMS = dkl2lms(bkgdLMS, dkl);    % Convert back to LMS again, should be same
% NOTE: BACKGROUND INPUT IS LMS HERE TO KEEP INPUTS CONSISTENT
fprintf('DKL = \t\t\t\t[%4.4f, %4.4f, %4.4f]\nReverse LMS = \t\t[%4.4f, %4.4f, %4.4f]\nOriginal LMS = \t\t[%4.4f, %4.4f, %4.4f]\n\n', dkl, revLMS, origLMS);

% DKL DIRECT
directDKL = rgb2dkl(bkgdRGB, RGB); % Use wrapper function to go direct from RGB to DKL
% NOTE: BACKGROUND INPUT IS RGB HERE TO KEEP INPUTS CONSISTENT
fprintf('RGB = \t\t\t\t[%4.4f, %4.4f, %4.4f]\nOriginal DKL = \t\t[%4.4f, %4.4f, %4.4f]\nDirect DKL = \t\t[%4.4f, %4.4f, %4.4f]\n\n', RGB, dkl, directDKL);

[rgbfromdkl, flag] = dkl2rgb(bkgdRGB, directDKL);
fprintf('Backwards RGB = \t\t[%4.4f, %4.4f, %4.4f]\nOriginal RGB = \t\t\t[%4.4f, %4.4f, %4.4f]\n\n', rgbfromdkl, RGB);
switch flag
    case 0
        fStr = 'in gamut';
    case 1
        fStr = 'out of gamut, at least one RGB is greater than 1';
    case 2
        fStr = 'out of gamut, at least one RGB is less than 0';
    case 3
        fStr = 'out of gamut, RGB values contain both >1 and <0 values';
end

fprintf('Flag status is %d, %s', flag,fStr);
fprintf('********************\n\n');


%% XYZ
xyz = lms2xyz(origLMS);
lms = xyz2lms(xyz);
fprintf('XYZ = \t\t[%4.4f, %4.4f, %4.4f]\nLMS = \t\t[%4.4f, %4.4f, %4.4f]\n\n', xyz, lms);

%% xyY
xyy = xyz2xyy(xyz);
xyz = xyy2xyz(xyy);
fprintf('xyY = \t\t[%4.4f, %4.4f, %4.4f]\nXYZ = \t\t[%4.4f, %4.4f, %4.4f]\n\n', xyy, xyz);

xyy = lms2xyy(lms);
lms = xyy2lms(xyy);

fprintf('xyY = \t\t[%4.4f, %4.4f, %4.4f]\nLMS = \t\t[%4.4f, %4.4f, %4.4f]\n\n', xyy, lms);


fprintf('********************\n\n');

%% Luv
luv = xyz2luv(xyz);
xyz2 = luv2xyz(luv);
fprintf('Luv = \t\t[%4.4f, %4.4f, %4.4f]\nXYZ = \t\t[%4.4f, %4.4f, %4.4f]\n\n', luv, xyz); %%%%%%%%%%%%%%%%%%%%

luv = lms2luv(lms);
lms = luv2lms(luv);

fprintf('Luv = \t\t[%4.4f, %4.4f, %4.4f]\nLMS = \t\t[%4.4f, %4.4f, %4.4f]\n\n', luv, lms); %%%%%%%%%%%%%%%%%%%%

luv = rgb2luv(RGB);
arr = luv2rgb(luv);

fprintf('Luv = \t\t[%4.4f, %4.4f, %4.4f]\nRGB = \t\t[%4.4f, %4.4f, %4.4f]\n\n', luv, arr); %%%%%%%%%%%%%%%%%%%%

fprintf('********************\n\n');


%% Lab
lab = xyz2lab(xyz);
xyz2 = lab2xyz(lab);
fprintf('Lab = \t\t[%4.4f, %4.4f, %4.4f]\nXYZ = \t\t[%4.4f, %4.4f, %4.4f]\n\n', lab, xyz); %%%%%%%%%%%%%%%%%%%%

lab = lms2lab(lms);
lms2 = lab2lms(lab);
fprintf('Lab = \t\t[%4.4f, %4.4f, %4.4f]\nLMS = \t\t[%4.4f, %4.4f, %4.4f]\n\n', lab, lms2); %%%%%%%%%%%%%%%%%%%%

lab = rgb2lab(RGB);
arr = lab2rgb(lab);
fprintf('Lab = \t\t[%4.4f, %4.4f, %4.4f]\nRGB = \t\t[%4.4f, %4.4f, %4.4f]\n\n', lab, arr); %%%%%%%%%%%%%%%%%%%%



%tlab = table('VariableNames', {'Value', 'Reverse'}, [1 2],'RowNames', convRows);