function postCompanding = sRGBCompanding(direction, inSpace)
%SRGBCOMPANDING Apply sRGB function to RGB to linearize it, or apply
%inverse sRGB function to linear RGB to voltage output.
%   sRGB follows a predictable function across most its range, but at very
%   small values will follow a different function.

%% Compand
if strcmpi(direction, 'rgb2xyz') || strcmpi(direction, 'Linear') || strcmpi(direction, 'Linearize')
    SRGBCONST = 0.04045;
    sRGBPower = 2.4;

    under = inSpace<=SRGBCONST;
    over = inSpace>SRGBCONST;
    inSpace(under) = inSpace(under) ./ 12.92;
    inSpace(over) = ((inSpace(over) + 0.055) ./ 1.055) .^ sRGBPower;

    postCompanding = inSpace;
elseif strcmpi(direction, 'xyz2rgb') || strcmpi(direction, 'Inverse')
    SRGBCONST = 0.0031308;
    sRGBPower = 1./2.4;

    under = inSpace<=SRGBCONST;
    over = inSpace>SRGBCONST;
    inSpace(under) = inSpace(under) .* 12.92;
    inSpace(over) = (1.055 .* inSpace(over) .^ sRGBPower) - 0.055;
else
    error("Invalid companding direction. Use 'Linear' for RGB-->XYZ or 'Inverse' for XYZ-->RGB");
end
postCompanding = inSpace;
end

