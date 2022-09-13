function uv = xy2uv(xy)
%XY2UV Convert CIE1931 x, y chromaticity to CIE1976 u', v'
%Luminance information is not included.

[x,y] = deal(xy(:,1), xy(:,2));
denom = -2.*x + 12.*y + 3;
uPrime = 4.*x ./ denom;
vPrime = 9.*y ./ denom;
uv = [uPrime,vPrime];

end

