function convMat = makeCVDmatrix()
%MAKECVDMATRIX Make conversion matrix based on dichromats copunctual
%points.
%   From %Kaiser & Boynton pg.~557
%   Is this still necessary? Conflicts with chromaticity based conversion
% e.g. Matrix * Judd-Vos CMFs = Smith & Pokorny LMS spectral sensitivity functions
% Book uses Vos 1978 minstead of S&P's original Judd 1951
%%%%% May be renamed

% Copunctal points x, y, z
protan = [0.7465, 0.2535, 0.0];
deutan = [1.4, -0.4, 0.0];
tritan = [0.1748, 0.0, 0.8252];

% 3x3 matrix of p,d,t x,y,z
sqM = [protan; deutan; tritan]';

% Normalizing constants diagonal matrix
% Tritan is not y because of 0 multiplication
% This value is arbitrary but makes
% PS/(PL+PM) = 1.0 @ 400 nm
% and PL+PM = luminance
% P == "fundamental tristimulus values", not L because they don't reflect
% luminance directly
k = [protan(2), deutan(2), 0.01327];
k = diag(k);

convMat = k * inv(sqM);
% Should be: does this need to be changed?
%0.155164498852334	0.543075745983168	-0.0328680979149151
%-0.155164498852334	0.456924254016833	0.0328680979149151
%0	0	0.0160809500727096

%Result can be multiplied by:
%P = convMat * XYZ
%or
%LMS CFs = convMat * CMFs
end

