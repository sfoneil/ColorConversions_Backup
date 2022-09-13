function Y = l2y(L, varargin)
%L2Y Convert CIELuv/CIELab L* to CIEXYZ Y

p = inputParser;
defaultWP = 'D65_2';
wpValidator = @(x) ischar(x) || isstring(x) || isempty(x) || isnumeric(x);
addRequired(p, 'L', @isnumeric)
addParameter(p, 'WhitePoint', defaultWP, wpValidator)
parse(p, L, varargin{:});

% Get whitepoint vector from illuminants struct
wp = loadWhitePoint(p.Results.WhitePoint, 'ToSpace', 'XYZ');
% wpShort = p.Results.WhitePoint;
% if ischar(wpShort) || isstring(wpShort)
%     load illuminants.mat % Load illuminants struct
%     wp = eval(strcat('si.', upper(wpShort)));
%     clearvars si % Remove from memory
% elseif isnumeric(wpShort)
%     if size(wpShort, 1) == 3
%         wp = wpShort';
%     elseif size(wpShort, 2) == 3
%         wp = wpShort;
%     else
%         error('White Point not valid. Verify it is Nx3 or a character array.')
%     end
% end

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

% Get Y
Y = zeros(size(L));
Lthresh =  L > (KAPPA * EPSILON);
Y(Lthresh) = ((L(Lthresh) + 16) ./ 116) .^3;
Y(~Lthresh) = L(~Lthresh) ./ KAPPA;
end

