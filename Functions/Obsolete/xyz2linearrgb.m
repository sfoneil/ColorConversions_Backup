function linearRGB = xyz2linearrgb(XYZ)
%XYZ2LINEARRGB Convert XYZ coordinates to RGB that has been gamma-corrected
%for CRT monitors. This _may_ not be recommended for standard LCD monitors or
%CRTs without correction. It needs to be tested for gamma == 1 monitors
%like Cambridge Research Systems Display++ or VPixx devices.
%   See also: XYZ2RGB XYZ2SRGB MAKERGB_XYZTRANSFORM

% Get color info from loaded .MAT file
ci = loadCI();

linearRGB = XYZ * ci.RGBMatrix;
end

