function [lms, RGBvalues] = spect2lms(phos, cfs, varargin)
%SPECT2LMS Convert spectrophotometer-measured monitor RGB gun output in
%w/sr/m^2 to LMS conem activation.
%
%   lms = spect2lms(phosphors) loads a saved monitor file and assumes
%   Stockman & Sharpe (2000) 2-degree cone fundamentals.
%
%   lms = spect2lms(phosphors, cfs) additionally uses a specified cone
%   fundamentals file
%   
%   Matricies are assumed to be n measurements x 4 columns, where col 1 ==
%   wavlengths, and 2:4 == R, G, B measurements at these wavelengths

% Control for optional function inputs, this will be added to.
% todo: load all data outside of code, in struct
% todo: ? use arguments instead of fixed order

%Get inputs
p = inputParser;
paramName = 'RGB';
defaultVal = [1 1 1];
errorMsg = 'Value is out of range 0...1. If your RGB is 1-256, scale it by /256';
%todo: parse 0-255 input?
validationFcn = @(x) assert(isnumeric(x) && all(x >= 0) && all(x <= 1),errorMsg);

% addRequired(p, phos);
% addRequired(p, cfs);
addOptional(p, paramName, defaultVal, validationFcn)

%Get inputs
parse(p, varargin)
%Todo, no error but flag

%parse(p, 'RGB', [0.5 0 1])

% if nargin == 2
%     rgbScale = [1;1;1];
% else
%     %  RGBvalues = cell2mat(varargin); todo
% end

%rgbScale = [0.8; 0.3; 0.5];

% Constants
MBSCALE = [0.689903, 0.348322, 0.0371597];
%OR (1.63 or 2.0 * L) + M

% Determine phosphors step size
% todo: better system?
% for now: expect n x 4 where (:,1) is the wavelengths?
if size(phos,2) ~= 4
    error('Phosphor file should be size nWavelengths x 4')
end

%Fill ranges to 1 nm steps
phos = interpolateRange(phos);
cfs = interpolateRange(cfs);

% Scale the S&S spectra for the MB space to get L/M luminance ratio and
% arbitrary S scaling
cfsScaled = cfs;
cfsScaled(:,2:4) = MBSCALE .* cfs(:,2:4); %%%

%adjust the RGB spectra for unit luminance
phosScaled = phos;
phosScaled(:,2:4) = phos(:,2:4) ./ sum(phos(:,2:4).*(cfsScaled(:,2) + cfsScaled(:,3)));



% % Align endpoints
% [phos, cfs] = truncRange(phos, cfs);
% TODO make this work!


%RGBtoLMStransform = makeRGBTransform(phos, cfs);
RGBtoLMStransform = cfsScaled(:,2:4)' * phosScaled(:,2:4);

% e.g. display white: relative luminances of the RGB guns
RGBtot = sum(phos(:,2:4).*(cfsScaled(:,2)+cfsScaled(:,3)));
RGBpcts = RGBtot./sum(RGBtot);

rgbScale= RGBpcts';

lms = RGBtoLMStransform*rgbScale;

%RGBvals = RGBtoLMStransform\LMSvals; %Test


% % Scale
% LMSweighted = phos;
% LMSweighted(:,2:4) = MBSCALE .* cfs(:,2:4);
% 
% 
% % Adjust the RGB spectra for unit luminance
% % todo: Consider optional?
% lum = LMSweighted(:,2) + LMSweighted(:,3); %Luminance, without S
% 
% phosScaled = phos;
% phosScaled(:,2:4) = phos(:,2:4) ./ sum(phos(:,2:4) .* lum);
% 
% %matrix transform
% %note this is in terms of the max RGB values but these need to be
% %calibrated for a given luminance - i.e. current transform does not provide
% %info on what the luminances are
% RGBtoLMStransform = LMSweighted(:,2:4)' * phosScaled(:,2:4);
% 
% % %specify RGB values as % of each gun required for a unit luminance of a
% % %given color; eg:
% % RGBvals = [.3; .3; .4];
% % % e.g. display white: relative luminances of the RGB guns
% % RGBtot = sum(RGBspectra(:,2:4).*(LMSwtd(:,2)+LMSwtd(:,3)));
% % RGBpcts = RGBtot./sum(RGBtot);
% 
% 
% % Adjust the RGB spectra for unit luminance
% % todo: Consider optional?
% lum = LMSweighted(:,2) + LMSweighted(:,3); %Luminance, without S
% 
% RGBoutput = sum(phos(:,2:4) .* lum);
% RGBpercents = RGBoutput ./ sum(RGBoutput);
% 
% RGBvalues = RGBpercents';
% 
% 
% %LMS values for a given RGB
% LMSvalues = RGBtoLMStransform * RGBvalues;
% lms = LMSvalues;
% 
% % %Convert to cone space
% % cones = cfs(:,2:4)' * phos(:,2:4);
% % 
% % %Scale if necessary, off by default
% % lms = cones * rgbScale;

end