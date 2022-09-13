function [Luv, chromaticity] = xyz2luv(XYZ, varargin)
%XYZ2LUV Convert CIE 1931 XYZ space to CIE 1976 L*u*v* space
%   Luv = xyz2lub(XYZ) Converts XYZ to Luv with assumed D65 Standard Illuminant
%   [Luv, chromaticity] Outputs Lu*v* and u' v' chromaticity

%todo, standard illuminants defined as cie, change?
%todo Account for x100 scaling?

%% Get Inputs
% Get this file's name, 'luv2xyz'
[~, thisFileName] = fileparts(mfilename('fullpath'));
[cylConv, wp] = liveLabLuv(thisFileName, XYZ, varargin{:});

% numConvs = size(XYZ,1); % For multi conversion
%XYZ = XYZ .* 100; % Todo: check!!!! Pain
%% Calculations

% CIE Constants
% Can also use
%   epsilon = 0.008856;
%   kappa = 903.3;
%   But current CIE use the precision of the fractions.
%
% Explanation:
%    http://www.brucelindbloom.com/LContinuity.html
EPSILON = 216/24389; % More precise version of (6/29)^3
KAPPA = 24389/27; % More precise version of (29/3)^3

XYZ = XYZ;% .* 100;
YRatio = XYZ(:,2) ./ wp(2) ;    

%Denominator, for conciseness
xyzDenom = (XYZ(:,1) + 15.*XYZ(:,2) + 3.*XYZ(:,3));
wpDenom = (wp(1) + 15.*wp(2) + 3.*wp(3));

%u, v prime
uPrime = 4 .* XYZ(:,1) ./ xyzDenom;
vPrime = 9 .* XYZ(:,2) ./ xyzDenom;
%vPrime = 9 .* 1 ./ xyzDenom;

%u, v prime of reference white
uPrimeRef = 4 .* wp(1) ./ wpDenom;
vPrimeRef = 9 .* wp(2) ./ wpDenom; % May be wrong value if Y not normalized, but doesn't afffect final

%Calculate final numbers
L = zeros(size(XYZ,1),1);
L(YRatio>EPSILON) = 116 .* (YRatio(YRatio>EPSILON) .^ (1/3)) - 16;
L(YRatio<=EPSILON) = KAPPA .* YRatio(YRatio<=EPSILON);
% if YRatio > EPSILON
%     L = 116 .* (YRatio .^ (1/3)) - 16;
% else
%     L = KAPPA .* YRatio;
% end
%L = L .* 100; % Need to scale just L

u = 13 .* L .* (uPrime - uPrimeRef);
v = 13 .* L .* (vPrime - vPrimeRef);

%% Output final results

% L*u*v*, convert if cylindrical
Luv = [L u v];
Luv = cylConv(Luv);

% Optionally return coordinates u' v'
chromaticity = [uPrime vPrime];
end

