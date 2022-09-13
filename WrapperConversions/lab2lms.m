function LMS = lab2lms(Lab, varargin)
%LAB2LMS Summary of this function goes here
%   Detailed explanation goes here

%% Get Inputs
validColorInput = @(x) size(x,2) == 3;

p = inputParser;
p.KeepUnmatched = true;
addRequired(p, 'Lab', validColorInput);
parse(p, Lab, varargin{:})
passthru = p.Unmatched;

% d65def = [0.95047 1 1.08883]; % 2 degree
% %d65def = [95.0470  100.0000  108.8830]; % 2 degree D65
% validColorInput = @(x) size(x, 2) == 3;
% validSpaces = {'cartesian', 'cyndrilical'};
% 
% p.addRequired('XYZ', validColorInput);
% p.addParameter('WhitePoint', d65def); % Default = D65 2 degree
% p.addParameter('Space', 'cartesian', @(x) any(validatestring(x, validSpaces)));
% 
% parse(p, Lab, varargin{:});
% 
% ref = p.Results.WhitePoint;
% space = p.Results.Space;

%% Calculations
% XYZ = lab2xyz(Lab, 'WhitePoint', ref, 'Space', space);
XYZ = lab2xyz(Lab, passthru);
LMS = xyz2lms(XYZ, passthru);
end

