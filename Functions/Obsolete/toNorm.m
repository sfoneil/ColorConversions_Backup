function normed = toNorm(x, minmaxRanges)
%RESCALEAXIS Scales 3x3 RGB x DKL gamut matrix to 3x2 conversion
%   multipliers. r = DKL lum, L-M, S-LM values, c = min, max conversion to
%   make spinner range -1 to +1

% % Change to range of 0...1
normRange = [(x - minmaxRanges(:,1)) ./ (minmaxRanges(:,2) - minmaxRanges(:,1))]; %, ...
 %    (minmaxRanges(:,2) - minmaxRanges(:,1)) ./ (minmaxRanges(:,2) - minmaxRanges(:,1))];

% Change to range of -1...+1
rescaledRange = normRange * 2 - 1;

normed = rescaledRange;

% % Returns anonymous function to convert to [-1 1] range
% toNorm = @(mins, maxes) [(mins - maxes) ./ (maxes - mins), ...
%     (maxes - mins) ./ (maxes - mins)];

% % Change back to range of 0...1
% descaledRange = (rescaledRange + 1) / 2;
% 
% % Change back to original range
% unnormRange = [descaledRange(:,1) .* (minmaxRanges(:,2) - minmaxRanges(:,1)) + minmaxRanges(:,1), ...
%     descaledRange(:,2) .* (minmaxRanges(:,2) - minmaxRanges(:,1)) + minmaxRanges(:,1)];
% 
% normMins = descaledRange(:,1);
% normMaxes = descaledRange(:,2);
% 
% % Anonymous
% toReal = @(mins, maxes) [normMins .* (maxes - mins) + maxes, ...
%     normMaxes .* (maxes - mins) + mins];

end
