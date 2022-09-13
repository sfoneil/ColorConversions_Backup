function [RGBtoXYZ, XYZtoRGB] = makeRGB_XYZtransform(x, y, varargin)
%MAKERGB_XYZTRANSFORM Create 3x3 transformation matrices for RGB and xYZ
%conversions.
%   Returns 3x3 matrix used to convert from RGB to XYZ
%   If second output requested, also supplies the XYZ to RGB inverse
%   x = 1x3 red, green, blue x coordinates
%   y = 1x3 red, green, blue y coordinates
%   'WhitePoint' = string or char in format 'd65_2'

% Defaults
% if ~isnumeric(x)
%     varargin = {x, y};
%     x = NaN;
%     y = NaN;
% end
ci = loadCI();
% Input parser
p = iparse([x y], varargin{:});

if p.Results.CalculateTransform || ~isfield(ci, 'RGB_XYZMatrix') || any(isnan([x,y]))
    wp = loadWhitePoint(p.Results.WhitePoint);
    %%%%%%%%%%%   EXAMPLE   %%%%%%%%%%%%
    % sRGB_xyY_d65 =
    %    [0.6400    0.3300    0.2127
    %     0.3000    0.6000    0.7152
    %     0.1500    0.0600    0.0722];

    % Results in:
    %  RGB to XYZ:
    %  0.4124564  0.3575761  0.1804375
    %  0.2126729  0.7151522  0.0721750
    %  0.0193339  0.1191920  0.9503041
    %
    %  XYZ to RGB:
    %  3.2404542 -1.5371385 -0.4985314
    % -0.9692660  1.8760108  0.0415560
    %  0.0556434 -0.2040259  1.0572252
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Math
    z = (1 - x - y); % Calculate z
    mat1 = [x(1)/y(1), x(2)/y(2), x(3)/y(3);
        1, 1, 1;
        z(1)/y(1), z(2)/y(2), z(3)/y(3)];

    %%
    s = mat1 \ wp'; % Candelas per gun
    s2 = repmat(s, [1 3])';

    % if p.Results.UseCd
    %maxLums = rescaleRange(ci.MaxLuminance, 1);

    %     s2 = s2 ./ maxLums; % Fix to maximum luminances
    % end

    RGBtoXYZ = s2 .* mat1; % Non-matrix multiply for new matrix
    %RGBtoXYZ = RGBtoXYZ ./ maxLums;
    %RGBtoXYZ = RGBtoXYZ; % ./ 100; %todo verify /100, per colour_science.py
    XYZtoRGB = inv(RGBtoXYZ);
    %XYZtoRGB = XYZtoRGB ./ maxLums;
else
    RGBtoXYZ = ci.RGB_XYZMatrix;
    XYZtoRGB = ci.XYZ_RGBMatrix;
end
% Resulting matrices will be matrix multiplied by RGB or XYZ, respectively

end

