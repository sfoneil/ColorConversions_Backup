function LMS = luv2lms(Luv, varargin)
%LUV2LMS Summary of this function goes here
%   Detailed explanation goes here

%% Get Inputs
p = inputParser;
p.KeepUnmatched = true;
validColorInput = @(x) size(x,2) == 3;
addRequired(p, 'Luv', validColorInput);
parse(p, Luv, varargin{:})
passthru = p.Unmatched;


% p = inputParser;
% 
% d65def = [0.95047 1 1.08883]; % 2 degree
% % no no no d65def =[ 95.047, 100, 108.883]; % 2 degrees
% validColorInput = @(x) size(x, 2) == 3;
% validSpaces = {'cartesian', 'cylindrical'};
% 
% p.addRequired('XYZ', validColorInput);
% p.addParameter('WhitePoint', d65def); % Default = D65 2 degree
% p.addParameter('Space', 'Cartesian', @(x) any(validatestring(x, validSpaces)));
% 
% parse(p, Luv, varargin{:});
% 
% ref = p.Results.WhitePoint;
% space = p.Results.Space;

%% Calculations
% if strcmpi(p.Results.Space, 'Cylindrical')
%     Luv = fromCylindrical(Luv);
% end

XYZ = luv2xyz(Luv, varargin{:});
LMS = xyz2lms(XYZ, varargin{:});

end

