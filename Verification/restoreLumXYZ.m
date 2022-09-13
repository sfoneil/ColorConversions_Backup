function XYZscaled = restoreLumXYZ(XYZ)
%RESTORELUMXYZ Restore lost luminance to XYZ
%   Need to account for rounding error?

data = XYZ.Value;
data = data ./ data(:,2); % Rescale Y to 1
data = data .* XYZ.Luminance; % Rescale Y to luminance in cd/m^2
XYZscaled = trival({'XYZ', data, XYZ.Luminance});
end

