function Lab = lms2lab(LMS, varargin)
%LMS2LAB Summary of this function goes here
%   Detailed explanation goes here
%% Get Inputs

p = inputParser;
p.KeepUnmatched = true;
validColorInput = @(x) size(x,2) == 3;
addRequired(p, 'LMS', validColorInput);
parse(p, LMS, varargin{:})
passthru = p.Unmatched;


% p = inputParser;
% 
% d65def = [0.95047 1 1.08883]; % 2 degree
% %d65def = [95.0470  100.0000  108.8830]; % 2 degree D65
% validColorInput = @(x) size(x, 2) == 3;
% validSpaces = {'cartesian', 'cyndrilical'};
% 
% p.addRequired('xyz', validColorInput);
% p.addParameter('WhitePoint', d65def); % Default = D65 2 degree
% p.addParameter('Space', 'cartesian', @(x) any(validatestring(x, validSpaces)));
% 
% parse(p, LMS, varargin{:});
% 
% ref = p.Results.WhitePoint;
% space = p.Results.Space;

%% Calculations
XYZ = lms2xyz(LMS, passthru);
Lab = xyz2lab(XYZ, passthru); % Needs to be {:} so it's a 0x0 not 1x1 with zero contents
end

