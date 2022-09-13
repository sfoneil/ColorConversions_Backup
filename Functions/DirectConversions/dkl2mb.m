function MB = dkl2mb(DKL, LMSbackground, varargin)
% Convert Derrington-Krauskopf-Lennie space to MacLeod Boynton space
%   Where:
%   [dkl] = [RedVsGreen, BlueVsYellow, Luminance]
%   [mb]  = [Red, Blue] where Green = 1 - red
%   Optional - 'polar' if polar coordinates (th, rho) needed, otherwise
%   Cartesian
% 
% LvsM = (mb(1) - origin(1)) * axScale(1);
% SvsLM = (mb(2) - origin(2)) * axScale(2);
% 
% dklcart = [LvsM SvsLM];

%todo: polar input handling? guess or required?

%% Parse inputs
p = iparse(DKL, varargin{:});
bkgdRGB = p.Results.Background;
bkgdLMS = rgb2lms(bkgdRGB);

% p = inputParser;
% addRequired(p, 'DKL', @isnumeric);
% addRequired(p, 'LMSBackground', @isnumeric);
% addParameter(p, 'Origin', [0 0], @isnumeric);
% addParameter(p, 'AxisScale', [1 1], @isnumeric);
% addParameter(p, 'AxisRotation', [0 0], @isnumeric);
% parse(p, DKL, LMSbackground, varargin{:});

% origin = p.Results.Origin;
% scale = p.Results.AxisScale;
% rotation = p.Results.AxisRotation;

mbL = DKL(:,1);% / (scale(1) * cosd(rotation(1))) + origin(1);
mbM = 1 - mbL; % Not normally used, but ouput for completeness
mbS = DKL(:,2);% / (scale(2) * cosd(rotation(2))) + origin(2);
Lum = DKL(:,3);

% mbL = dkl(1) * axScale(1) + origin(1);
% mbM = dkl(2) * axScale(2) + origin(2);

MB = [mbL, mbM, mbS, Lum];

end