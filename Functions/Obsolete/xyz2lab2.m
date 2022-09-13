function Lab = xyz2lab2(xyz, ref)
%XYZ2LAB Convert CIE 1931 XYZ to CIE 1976 L*a*b*
%   This function exists in the MATLAB, may not need?

if ~exist('ref', 'var')
    ref = [0.9505    1.0000    1.0888];  %si.d65;
end

epsilon = 216/24389;
kappa = 24389/27;

xr = xyz(1) / ref(1);
yr = xyz(2) / ref(2);
zr = xyz(3) / ref(3);

%fx
if xr > epsilon
    fx = xr ^ (1/3);
else
    fx = (kappa * xr + 16) / 116;
end

%fy
if yr > epsilon
    fy = yr ^ (1/3);
else
    fy = (kappa * yr + 16) / 116;
end

%fz
if zr > epsilon
    fz = zr ^ (1/3);
else
    fz = (kappa * zr + 16) / 116;
end

L = 116 * fy - 16;
a = 500 * (fx - fy);
b = 200 * (fy - fz);

Lab = [L a b];

end

