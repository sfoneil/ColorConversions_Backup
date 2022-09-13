function [Luv, chromaticity] = xyz2luv(XYZ, varargin)
%XYZ2LUV Convert CIE 1931 XYZ space to CIE 1976 L*u*v* space
%   Luv = xyz2lub(XYZ) Converts XYZ to Luv with assumed D65 Standard Illuminant

%todo, standard illuminants defined as cie, change?
%Account for x100 scaling?

%% Get Inputs

% args = varargin;
% args{end|1} = str2func('xyz2luv');
% [wp, conversion] = liveLabLuv(args);
%
% p = inputParser;
% % %
% d65def = [0.95047 1 1.08883]; % 2 degree
% % % %no no no d65def =[ 95.047, 100, 108.883]; % 2 degrees
% validColorInput = @(x) size(x, 2) == 3;
% validSpaces = {'Cartesian', 'Cylindrical'};
% % %
% p.addRequired('XYZ', validColorInput);
% p.addParameter('WhitePoint', d65def); % Default = D65 2 degree
% p.addParameter('Space', 'Cartesian', @(x) any(validatestring(x, validSpaces)));
% % %
% % %
% parse(p, XYZ, varargin{:});
% 
% % args = p.Results;
% % args = rmfield(args,'XYZ'); % Remove required color space
% %
% wp = p.Results.WhitePoint;
% space = p.Results.Space;


%% Get Inputs
% Get this file's name, 'luv2xyz'
[~, thisFileName] = fileparts(mfilename('fullpath'));
[cylConv, wp] = liveLabLuv(thisFileName, XYZ, varargin{:}); 

% if isempty(varargin)
% args = {NaN};
% else
%     args = varargin;
% end

%[wp, lambda] = liveLabLuv(args{:});
% [wp, lambda] = liveLabLuv(args);
%
% q = lambda(XYZ)

%% Calculations

% CIE Constants
% Can also use
%   epsilon = 0.008856;
%   kappa = 903.3;
%   But current CIE use the precision of the fractions.
%
% Explanation:
%    http://www.brucelindbloom.com/LContinuity.html
EPSILON = 216/24389;
KAPPA = 24389/27;

YRef = XYZ(2) / wp(2);

%Denominator, for conciseness
xyzDenom = (XYZ(1) + 15*XYZ(2) + 3*XYZ(3));
wpDenom = (wp(1) + 15*wp(2) + 3*wp(3));

%u, v prime
uPrime = (4 * XYZ(1)) / xyzDenom;
vPrime = (9 * XYZ(2)) / xyzDenom;

%u, v prime of reference white
uPrimeRef = (4 * wp(1)) / wpDenom;
vPrimeRef = (9 * wp(2)) / wpDenom;

%Calculate final numbers
if YRef > EPSILON
    L = 116 * (YRef ^ (1/3)) - 16;
else
    L = KAPPA * YRef;
end

u = 13 * L * (uPrime - uPrimeRef);
v = 13 * L * (vPrime - vPrimeRef);

%% Output final results

% L*u*v*, convert if cylindrical
Luv = [L u v];
Luv = cylConv(Luv);

% Optionally return coordinates u' v'
chromaticity = [uPrime vPrime];
end

