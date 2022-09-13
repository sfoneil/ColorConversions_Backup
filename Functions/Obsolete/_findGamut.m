function dklGamut = findGamut(phos, cfs, rgbBack)
%FINDGAMUT Find DKL coordinates corresponding to monitor-specific maximum RGB gamut.
%   Returns DKLGAMUT, a 3x3 matrix where r = r, g, b colors and c = DKL Lum, L-M, S-L+M
%   To use this function to determine allowable range, minmax(gamut') will
%   return a 3x2 matrix, where r = min, max for c = DKL Lum, L-M, S-L+M
%   May be adjusted in future to find gamut in other color spaces.

% Get background LMS
bkgd = rgb2lms(phos, cfs, rgbBack);

% Get R, G, B LMS and DKL
rlms = rgb2lms(phos, cfs, [1 0 0]);
rdkl = lms2dkl(bkgd, rlms);

glms = rgb2lms(phos, cfs, [0 1 0]);
gdkl = lms2dkl(bkgd, glms);

blms = rgb2lms(phos, cfs, [0 0 1]);
bdkl = lms2dkl(bkgd, blms);

dklGamut = [rdkl; gdkl; bdkl];

end