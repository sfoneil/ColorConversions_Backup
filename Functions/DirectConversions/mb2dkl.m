function DKLcart = mb2dkl(MB, varargin)
%MB2DKL MacLeod-Boynton space to Derrington-Krauskopf-Lennie space
%
%   Detailed explanation goes here

%% Parse inputs
p = inputParser;
addRequired(p, 'MB', @isnumeric);
addParameter(p, 'Luminance', [], @isnumeric)
addParameter(p, 'Origin', [0 0], @isnumeric);
addParameter(p, 'AxisScale', [1 1], @isnumeric);
addParameter(p, 'AxisRotation', [0 0], @isnumeric);
parse(p, MB, varargin{:});

origin = p.Results.Origin;
scale = p.Results.AxisScale;
rotation = p.Results.AxisRotation;

% Make Nx4
MB = checkMB(MB, p.Results.Luminance);

%Define default optionals if not specified
% if nargin == 1
%     origin = [0, 0];
%     axScale = [1 1];
%     axRotation = [1 1];
% elseif nargin == 2
%     axScale = [1 1];
%     axRotation = [1 1];
% end

%todo get origin
% Reset origin (with gray?), rescale by axScale, and rotate
%LvsM = scale(1) * (MB(1) - origin(1)) * cosd(rotation(1));
%SvsLM = scale(2) * (MB(3) - origin(2)) * sind(rotation(2));
LvsM = MB(:,1);
SvsLM = MB(:,3);
%Lum = MB(1) + MB(2);
Lum = MB(:,4);

DKLcart = [LvsM SvsLM Lum];

% Math for conversions":
% color angle = atan2d(SvsLM, LvsM);
% color contrast = sqrt(LvsM^2+SvsLM^2);
% 

% Todo: Not necessary now, check later
[dklth dklr] = cart2pol(DKLcart(1),DKLcart(2));
dklth = rad2deg(dklth);
dklpol = [dklth dklr];


%Todo:
%it's outputting degrees, but maybe we should have OPTION for radians

% 
% %MB to DKL
% LvsM = (MBL-WMBL)*LMscale
% SvsLM = (MBS-WMBS)*Sscale
% 
% %MB to DKL polar
% colangle = atan2d(SvsLM/LvsM);
% colcontrast = sqrt(LvsM^2+SvsLM^2);
% 
% %%%% inverse conversions
% % MacLeod-Boynton to LMS
% LMvals(1) = MBL;
% LMvals(2) = 1-MBL;
% LMvals(3) = MBS;
% 
% %LMS to RGB
% RGBvals = RGBtoLMStransform\LMSvals;
% 
% %divide by total to get RGBpcts for a given color
% RGBpcts = RGBvals./sum(RGBvals);
% 
% %multiply RGBpcnts by the desired luminance to get the absolute RGB
% %luminances
% 
end