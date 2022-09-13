function Lab = xyzTOlab(XYZ, varargin)
%XYZ2LAB Convert CIE 1931 XYZ space to CIE 1976 L*a*b* space
%   a

%% Get Inputs



% p = inputParser;
% % 
% d65def = [0.95047 1 1.08883]; % 2 degree
% % %d65def = [95.0470  100.0000  108.8830]; % 2 degree D65
% validColorInput = @(x) size(x, 2) == 3;
% validSpaces = {'cartesian', 'cyndrilical'};
% % 
% p.addRequired('XYZ', validColorInput);
% p.addParameter('WhitePoint', d65def); % Default = D65 2 degree
% p.addParameter('Space', 'cartesian', @(x) any(validatestring(x, validSpaces)));
% % 
% parse(p, XYZ, varargin{:});
% % 
% % ref = p.Results.WhitePoint;
% % space = p.Results.Space;
% 
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



% Get xyz scaled reference
refratios = XYZ ./ wp;
[xr, yr, zr] = deal(refratios(:,1), refratios(:,2), refratios(:,3));

% CIE Constants
% Can also use
%   epsilon = 0.008856;
%   kappa = 903.3;
%   But current CIE use the precision of the fractions.
%
% Explanation:
%    http://www.brucelindbloom.com/LContinuity.html
EPSILON = 216/24389; % CIE st
KAPPA = 24389/27;

% 
if xr > EPSILON
    fx = xr .^ (1/3);
else
    fx = (KAPPA * xr + 16) / 116;
end

if yr > EPSILON
    fy = yr .^ (1/3);
else
    fy = (KAPPA * yr + 16) / 116;
end

if zr > EPSILON
    fz = zr .^ (1/3);
else
    fz = (KAPPA * zr + 16) / 116;
end

L = (116 * fy) - 16;
a = 500 * (fx - fy);
b = 200 * (fy - fz);



%% If Cyndrilical
Lab = [L a b];
Lab = cylConv(Lab);

% if strcmpi(space, 'cylindrical')
%     Lab = convMakeCH(Lab);
% else
% 
% end

end

