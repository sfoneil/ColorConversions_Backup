function cLMS = xyz2lms(XYZ, varargin)
%XYZ2LMS Convert XYZ to LMS based CIE 2006 based on Stockman & Sharpe 2000
%fundamental data
%
% 3x3 matrix represents the transform color matching functions to go from
% XYZ cone activations to LMS color space, note this is different than
% the normal CIE1931 XYZ color space
%
% Note: conversion between LMS and XYZ will only be accurate and reversible
% if XYZ is derived from RGB using the option 'Linearizing', 'none'. Using
% 'Gamma', 'sRGB', and so on will cause the resulting LMS to be off
%
% See also LMS2XYZ

%% Parse
p = iparse(XYZ, varargin{:});

%% White point parsing
% Not sure if this should be done here or in RGB conversion?
%XYZ = chromaticAdaptation(XYZ, p.Results.FromWP, p.Results.ToWP); %todo add from request
data = XYZ.Value;
%% Convert
method = 1; %todo
if method == 1
    %% CAT conversion matrices - to LMS
    % Stockman & Sharpe matrix
    convMatSS = [0.210576, 0.855098, -0.0396983; ...
        -0.417076, 1.17726, 0.0786283; ...
        0, 0, 0.516835];

    % von Kries/Hunter-Pointer-Estevez Illuminant E (equal energy)
    convMatE = [0.38971, 0.68898, -0.07868;
        -0.22981, 1.18340, 0.04641;
        0.00000, 0.00000, 1.00000];

    % von Kries/Hunter-Pointer-Estevez Illuminant D65
    convMatD65 = [0.4002, 0.7076, -0.0808;
        -0.2263, 1.1653, 0.0457;
        0, 0, 0.9182];

    % From old conversions/Brainard 1996 "Cone contrast and opponent modulation
    % color spaces" in Human Color Vision 2
    convMatBrainard = [0.1552, 0.5431, -0.0329;
        -0.1552, 0.4569, 0.0329
        0, 0, 0.0161];
    convMatStr = p.Results.CAT;

    % Load matrices
    switch lower(convMatStr)
        case {'ss', 'stockmansharpe', 'stockman & sharpe'}
            convMat = convMatSS;
        case {'vke', 'vonkriese', 'von kries e', 'hpee'}
            convMat = convMatE;
        case {'vkd65', 'vonkriesd65', 'von kries d65', 'hped65'}
            convMat = convMatD65;
        case {'brainard', 'old'}
            convMat = convMatBrainard;
    end

    LMS = convMat * data';
    LMS = LMS';
else

    XYZtoLMS = makeXYZ_LMStransform(varargin{:});

    LMS = (XYZtoLMS * XYZ')';
end
cLMS = trival({'LMS', LMS, XYZ.Luminance});
end