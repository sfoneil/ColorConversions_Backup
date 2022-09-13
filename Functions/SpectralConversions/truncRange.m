function [newRange1, newRange2] = truncRange(range1,range2)
%TRUNCRANGE Compares two m x 4 matrices and truncates the range of the
%   longer ones in both the minimum, maximum, or both
%   BOTH inputs are assumed to be in 1 nanometer steps, run
%   interpolate_range() on both first. Order of range1 and range2 can be
%   swapped with no effect, but outputs will be in switched order.
%
%   See also INTERPOLATESPRAGUE, INTERPOLATERANGE

%Get items in column 1 that are unique to each range, and indices
[cutoff, range1Rem, range2Rem] = setxor(range1(:,1), range2(:,1));

%Remove unique indices from each range
range1(range1Rem,:) = [];
range2(range2Rem,:) = [];

newRange1 = range1;
newRange2 = range2;

end

