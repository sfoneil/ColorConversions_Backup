function [xy] = uv2xy(uv)
%UV2XY Convert CIE1976 u', v' chromaticity to CIE1931 x, y
%Luminance information is not included.

   [uPrime, vPrime] = deal(uv(:,1), uv(:,2));
    denom = 6 .* uPrime - 16 .* vPrime + 12;
    x = 9 * uPrime ./ denom;
    y = 4 * vPrime ./ denom;
    xy = [x y];
end

