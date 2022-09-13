function Luv = lupvp2luv(Lupvp, varargin)
%LUPVP2LUV Convert L u' v' to Lu*v*. Normally this conversion is not
%possible if numbers are taken from u' v' chromaticity plot, so L* is
%needed 

[L, up, vp] = deal(Lupvp(:,1), Lupvp(:,2), Lupvp(:,3));
% L = Lupvp(1);
% up = Lupvp(2);
% vp = Lupvp(3);

%% Defaults
%d65def = [0.95047 1 1.08883]; % Define default white point: 2 degree D65
defaultWP = 'd65_2';
wpValidator = @(x) ischar(x) || isstring(x) || isempty(x) || isnumeric(x);

%% Parse
p = inputParser; % Minus sending function

% Define possible inputs
addRequired(p, 'Lupvp', @isnumeric)
addParameter(p, 'WhitePoint', defaultWP, wpValidator);
parse(p, Lupvp, varargin{:});

% Get whitepoint vector from illuminants struct
wpShort = p.Results.WhitePoint;
if ischar(wpShort) || isstring(wpShort)
    load illuminants.mat % Load illuminants struct
    wp = eval(strcat('si.', wpShort));
    clearvars si % Remove from memory
elseif isnumeric(wpShort)
    if size(wpShort, 1) == 3
        wp = wpShort';
    elseif size(wpShort, 2) == 3
        wp = wpShort;
    else
        error('White Point not valid. Verify it is Nx3 or a character array.')
    end
end
%wp = wp * 100; % Careful: todo verify this is needed?

Y = ((L+16)/116).^3;
X = 9 * up / (4 * vp);
Z = (-5 * Y * vp - 3 * up / 4 + 3) / vp;


wpDenom = (wp(1) + 15*wp(2) + 3*wp(3));

%u, v prime of reference white
uPrimeRef = (4 * wp(1)) / wpDenom;
vPrimeRef = (9 * wp(2)) / wpDenom;

u = 13*L .* (up - uPrimeRef);
v = 13*L .* (vp - vPrimeRef);

Luv = [L u v];

% uPrimeRef =
% 
%     0.1978
% 
%     vPrimeRef =
% 
%     0.4683

%% Need XYZ
% 
% $u* = 13*L * (u' - u'r)
%  u* = 13 * L*u' - L*u'r

%v = 13*L * (vp - vpr)
end

