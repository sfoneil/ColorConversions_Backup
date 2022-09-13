function postCompanding = LCompanding(direction, inSpace)
%LCOMPANDING Apply L* function to RGB to linearize it, or apply
%inverse L* function to linear RGB to voltage output.
%   x

%% Constants
KAPPA = 24389/27;
EPSILON = 216/24389;

if strcmpi(direction, 'xyz2rgb') || strcmpi(direction, 'Linear') || strcmpi(direction, 'Linearize')
    LCONST = 0.08;

    under = inSpace<=LCONST;
    over = inSpace>LCONST;

    inSpace(under) = 100 .* inSpace(under) ./ KAPPA;
    inSpace(over) = ((inSpace(over) + 0.16) ./ 1.16) .^3;
elseif strcmpi(direction, 'rgb2xyz') || strcmpi(direction, 'Inverse') %todo rename
    under = inSpace<=EPSILON;
    over = inSpace>EPSILON;

    inSpace(under) = (inSpace(under) .* KAPPA) ./ 100;
    inSpace(over) = 1.16 .* inSpace(over).^(1/3) - 0.16;
else
    error("Invalid companding direction. Use 'Linear' for RGB-->XYZ or 'Inverse' for XYZ-->RGB");
end
postCompanding = inSpace;
end

