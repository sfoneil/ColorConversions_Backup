function [Luv, chromaticity] = rgb2luv(RGB, varargin)
%RGB2LUV Summary of this function goes here
%   Detailed explanation goes here

%[colorInfo, phos] = loadCI();

%% Parse inputs
p = inputParser;
p.KeepUnmatched = true;
validColorInput = @(x) size(x,2) == 3;
addRequired(p, 'RGB', validColorInput);
parse(p, RGB, varargin{:})
passthru = p.Unmatched;


%% Get Inputs
%[wp, conversion] = liveLabLuv(varargin);

% p = inputParser;
% 
% d65def = [0.95047 1 1.08883]; % 2 degree
% %no no no d65def =[ 95.047, 100, 108.883]; % 2 degrees
% 
% validColorInput = @(x) size(x, 2) == 3;
% validSpaces = {'cartesian', 'cylindrical'};
% 
% p.addRequired('Luv', validColorInput);
% p.addParameter('WhitePoint', d65def); % Default = D65 2 degree
% p.addParameter('Space', 'cartesian', @(x) any(validatestring(x, validSpaces)));
% 
% parse(p, RGB, varargin{:});
% 
% ref = p.Results.WhitePoint;
% space = p.Results.Space;

%% Calculations

%LMS = rgb2lms(RGB);
%XYZ = lms2xyz(LMS);
XYZ = rgb2xyz(RGB, varargin{:});
[Luv, chromaticity] = xyz2luv(XYZ, varargin{:});
%Luv = conversion(Luv);
end

