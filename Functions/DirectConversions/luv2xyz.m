function XYZ = luv2xyz(Luv, varargin)
%LUV2XYZ Convert CIE 1976 L*u*v* space to CIE 1931 XYZ space
%   XYZ = luv2xyz(Luv) Converts Luv to XYZ with assumed D65 Standard
%   Illuminant and Cartesian input (no space conversion).
%   XYZ = luv2xyz('WhitePoint', wp) Uses specified reference white point
%   XYZ = luv2xyz('Space', 'cylindrical') Assumes Cartesian input and
%       converts output to cylindrical

% Get this file's name, 'luv2xyz'
[~, thisFileName] = fileparts(mfilename('fullpath'));
% args = varargin;
% args{end+1} = thisFileName; % Add this function string to varrargin
% args{end} = thisFileName;

[cylConv, wp] = liveLabLuv(thisFileName, Luv, varargin{:});

% Convert from cylindrical if requested
Luv = cylConv(Luv);

% %% Parse
% p = inputParser;
% d65def = [0.95047 1 1.08883]; % 2 degree
% validColorInput = @(x) size(x, 2) == 3;
% validSpaces = {'Cartesian', 'Cylindrical'};
%
% p.addRequired('Luv', validColorInput);
% p.addParameter('WhitePoint', d65def); % Default = D65 2 degree
% p.addParameter('Space', 'Cartesian', @(x) any(validatestring(x, validSpaces)));
%
% parse(p, Luv, varargin{:});
%
% wp = p.Results.WhitePoint;
% space = p.Results.Space;

%% Get Inputs



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

% Split vectors for readability only
[L, u, v] = deal(Luv(:,1), Luv(:,2), Luv(:,3));
[Xr, Yr, Zr] = deal(wp(1), wp(2), wp(3));

% Calculate reference white point u, v
wpDenom = Xr + 15*Yr + 3*Zr; % Calculate common denominator

% Calculate for reference
u0 = (4 .* Xr) ./ wpDenom;
v0 = (9 .* Yr) ./ wpDenom;

% % Do this well before b, d
Y = zeros(size(L));
Lthresh =  L > (KAPPA * EPSILON);
Y(Lthresh) = ((L(Lthresh) + 16) ./ 116) .^3;
Y(~Lthresh) = L(~Lthresh) ./ KAPPA;
% if L > (KAPPA * EPSILON)
%     Y = ((L + 16) ./ 116) ^ 3;
% else
%     Y = L ./ KAPPA;
% end

% Steps
a = 1/3 .* (((52 .* L) ./ (u + (13 .* L .* u0))) - 1);
b = -5 .* Y;
c = -1/3;
d = Y .* (((39 .* L) ./ (v + (13 .* L .* v0))) - 5);

% Calculate final numbers
X = (d - b) ./ (a - c);
% if L > (KAPPA * EPSILON)
%     Y = ((L + 16) ./ 116) .^ 3;
% else
%     Y = L ./ KAPPA;
% end
Z = X .* a + b;

XYZ = [X Y Z];

end

