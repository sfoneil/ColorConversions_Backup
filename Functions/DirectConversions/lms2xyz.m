function cXYZ = lms2xyz(LMS, varargin)
%LMS2XYZ Convert LMS cone activations to CIE XYZ color space
%
% 3x3 matrix represents the transform color matching functions to go from
% LMS cone activations to "XYZ" color space, note this is different than
% the normal CIE1931 XYZ color space
%
% Note: conversion between LMS and XYZ will only be accurate and reversible
% if XYZ is derived from RGB using the option 'Linearizing', 'none'. Using
% 'Gamma', 'sRGB', and so on will cause the resulting LMS to be off
% See also XYZ2LMS
%


%% Load colorInfo2
%ci = loadCI();
p = iparse(LMS, varargin{:});

data = LMS.Value;
method = 1; %todo debug considerably/fix

if method == 1
    %% CAT conversion matrices
    % Stockman & Sharpe matrix
    convMatSS = [1.94735469, -1.41445123, 0.36476327; ...
        0.68990272, 0.34832189, 0; ...
        0, 0, 1.93485343];

    % von Kries/Hunter-Pointer-Estevez Illuminant E (equal energy)
    convMatE = [1.9102, -1.1121, 0.2019;
        0.3710, 0.6291, -0.0000;
        0, 0, 1.0000];

    % von Kries/Hunter-Pointer-Estevez Illuminant D65
    convMatD65 = [1.8601, -1.1295, 0.2199;
        0.3612, 0.6388, -0.0000;
        0, 0, 1.0891];

    convMatBrainard = [2.9448, -3.5001, 13.1745;
        1.0000, 1.0000, 0;
        0, 0, 62.1891];
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
    XYZ = convMat * data';
    XYZ = XYZ';
else
    [XYZtoLMS, LMStoXYZ] = makeXYZ_LMStransform(varargin{:});
    XYZ = (LMStoXYZ * LMS')';
end


% Not sure if this should be done here or in RGB conversion?
XYZ = chromaticAdaptation(XYZ, p.Results.FromWP, p.Results.ToWP);

% if LMS.Luminance ~= XYZ(:,2)
%     warning('XYZ luminance does not match Y value. Error checking is needed and will be fixed later.\n');
%         ct = size(XYZ, 1);
%         for i = 1:min(ct, 10)
%             fprintf('   Lum = %2.2f   Y = %2.2f\n', LMS.Luminance(i), XYZ(i,2));
%         end
%         if i == 10; fprintf('...\n\n'); end
%         
% end
cXYZ = trival({'XYZ', XYZ, LMS.Luminance});
end

