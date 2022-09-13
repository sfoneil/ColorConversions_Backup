function [boolCheck, spacing] = isEquallySpaced(wavelengths)
%ISEQUALLYSPACED Auxiliary function to check spacing of a wavelength
%column in 
%   Returns:    boolCheck: TRUE if spacing is equal
%               spacing: scalar with spacing if Boolean is true, otherwise
%               NaN

s = size(wavelengths);
% Only accept X wavelength data
if min(s) ~= 1
    error('Input vector must be size Nx1 or 1xM.')
end
% Make columnar
wavelengths = wavelengths(:);

% Get differences of consecutive
d = diff(wavelengths);
% Round to avoid rounding errors
d = round(d, 4); 
% Check number of unique entries
u = unique(d);
% Check if size is 1x1
if isequal(size(u), [1 1])
    boolCheck = 1;
    spacing = u;
else
    boolCheck = 0;
    spacing = NaN;
end