function XYZ = lab2xyz(Lab, varargin)
%LAB2XYZ CIE 1976 L*a*b* to CIE 1931 XYZ
%   Detailed explanation goes here

% %% Get Inputs
% p = inputParser;
% 
% d65def = [0.95047 1 1.08883]; % 2 degree
% validColorInput = @(x) size(x, 2) == 3;
% validSpaces = {'cartesian', 'cyndrilical'};
% 
% p.addRequired('lab', validColorInput);
% p.addParameter('WhitePoint', d65def); % Default = D65 2 degree
% p.addParameter('Space', 'cartesian', @(x) any(validatestring(x, validSpaces)));
% 
% 
% parse(p, Lab, varargin{:});
% 
% ref = p.Results.WhitePoint;

[~, thisFileName] = fileparts(mfilename('fullpath'));
[cylConv, wp] = liveLabLuv(thisFileName, Lab, varargin{:}); 

% Convert from cylindrical if requested
Lab = cylConv(Lab);

%% Calculations

% Split for readability
[L, a, b] = deal(Lab(:, 1), Lab(:, 2), Lab(:, 3));
[Xr, Yr, Zr] = deal(wp(1), wp(2), wp(3));

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

fy = (L + 16) / 116;
fx = (a/500) + fy;
fz = fy - (b / 200);

if (fx .^ 3) > EPSILON
    xr = fx  .^ 3;
else
    xr = (116 * fx - 116) ./ KAPPA;
end

if L > (KAPPA * EPSILON)
    yr = ((L + 16) / 116) .^ 3;
else
    yr = L / KAPPA;
end

if (fz .^ 3) > EPSILON
    zr = fz .^ 3;
else
    zr = (116 * fz - 16) / KAPPA;
end

% Get results
X = xr * Xr;
Y = yr * Yr;
Z = zr * Zr;

% Combine
XYZ = [X Y Z];
%XYZ = XYZ / 100; % Necessary? Per book

end

