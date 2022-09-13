function [cRGB, satFlag, unclampedRGB] = lms2rgb(LMS, varargin)
%LMS2RGB Convert LMS cone activation triplet to RGB triplet given monitor
%and fundamental information.
%
%   rgb = lms2rgb(LMS) loads a saved monitor file and assumes
%   Stockman & Sharpe (2000) 2-degree cone fundamentals.
%
%   
%   Matrices are assumed to be n measurements x 4 columns, where col 1 ==
%   wavelengths, and 2:4 == R, G, B measurements at these wavelengths


%Todo: define transform efficiently!
ci = loadCI();
p = iparse(LMS, varargin{:});


%% Get Inputs
% fcfs = p.Results.Fundamentals;
phos = ci.Phosphors;
data = LMS.Value;
%% Calculations

% Make column for transformation
if size(LMS, 2) == 3
    LMS = LMS';
end

%satFlag = 0;
[~, LMStoRGBtransform] = makeRGB_LMStransform(phos);
%RGBtoLMStransform = makeRGB_LMStransform(phos);%, fcfs);
%rgbT = (RGBtoLMStransform \ LMS)'; % Transpose back to 1x3
RGB = (LMStoRGBtransform * data')';
% Sometimes RGB is some very tiny -value which messes up flag, fix and test
% extensively

% CONSTANTS to round very small values near zero to zero. These values are
% tested at 8 bits (1/256) but potentially up to 16-bits (1/65536) and
% should work but aren't tested.
PRECISION = 1 / 2^16; %todo VERIFY LOTS
SIGFIG = 5;

% Round to 0

% % rgbT(rgbT < PRECISION) = 0;

% if (any(rgbT < PRECISION)) && (any(rgbT > -PRECISION))
%     %    fix(rgbT)
%     round(rgbT, SIGFIG) %Should be sufficient for 16-bits
% end

% Return RGB value, satFlag is zero if in gamut, 1-3 if out of gamut and
% appropriate measures in your code should be taken.
% Returns satFlag
% if allowSaturation
%     RGB = rgbT;
%     satFlag = -1;
% else
%unclampedRGB = rgbT;
RGB = trival({'RGB', RGB, LMS.Luminance});
[cRGB, satFlag, unclampedRGB] = checkSaturation(RGB);

% end


end