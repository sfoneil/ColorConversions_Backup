function L = y2l(Y, varargin)
%Y2L Convert CIEXYZ Y to CIELuv/CIELab L*

p = inputParser;
defaultWP = 'D65_2';
wpValidator = @(x) ischar(x) || isstring(x) || isempty(x) || isnumeric(x);
addRequired(p, 'Y', @isnumeric)
addParameter(p, 'WhitePoint', defaultWP, wpValidator)
parse(p, Y, varargin{:});

% Get whitepoint vector from illuminants struct
wp = loadWhitePoint(p.Results.WhitePoint, 'ToSpace', 'XYZ');
%wpShort = p.Results.WhitePoint;
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

YRatio = Y ./ wp(2);

% Calculate Luminance
L = zeros(size(Y));
L(YRatio>EPSILON) = 116 .* (YRatio(YRatio>EPSILON) .^ (1/3)) - 16;
L(YRatio<=EPSILON) = KAPPA .* YRatio(YRatio<=EPSILON);

end

