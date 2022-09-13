function [MBout] = checkMB(MBin, luminance)
%CHECKMB Checks MacLeod-Boynton coordinate input and returns a consistent
%format.
%   MB is a chromaticity diagram that normally plots red on the X axis (and
%   therefore more green is implied as absence of red/left on the same
%   axis) while blue is plotted on the Y axis. Luminance is not normally
%   included but fixed to isoluminance, therefore the luminance information
%   is not always preserved. Luminance is L+M cone resposnes and included
%   if possible.
%
%   If size(MBin, 2) ~= [2 3 4], try transposing it.
%   If size(MBin,2) == 3, add a 4th column containing -1 for unknown
%   luminance.
%   If sizE(MBin,2) == 2, add second column between two existing ones with
%   1-col1. This is redundant but for consistency. Also add the -1 column.

s = size(MBin);
% Accept only 2d
if ~ismatrix(s)
    error('MacLeod-Boynton input is %d-dimensions, please input 2-dimenional data.\n', ndims(d));
end

% Transpose if necessary
%todo FIX, 4x3 transposes and shouldn't
if size(MBin,1) ~= size(MBin,2)
    if (any(size(MBin,2) ~= [2 3 4])) && (any(size(MBin,1) == [2 3 4]))
     %   if size(MBin,2)
        warning('Transposing MB input.')
        MBin = MBin';
    end
end

% If matrix luminance supplied
if size(MBin, 2) == 4
    luminance = MBin(:,4);
end

% If luminance not supplied
if nargin == 1 && size(MBin, 2) ~= 4
    luminance = -1;
end

% If luminance supplied but only 1 number, expand it
% if isscalar(luminance)
%     luminance = luminance .* ones(size(MBin,1),1);
% end

% Add columns
minusCol = ones(size(MBin,1),1) .* luminance;
if size(MBin,2) == 2
    MBin = [MBin(:,1), 1-MBin(:,1), MBin(:,2)];
end
if size(MBin,2) == 3
    MBin = [MBin minusCol];
    LM = MBin(:,1) + MBin(:,2);
end

% Check that M == 1-L
L = MBin(:,1);
M = MBin(:,2);
L2 = 1-M;
if abs(L-L2) > 1e4*eps(min(abs(L), abs(L2)))
    warning(['MacLeod-Boynton L and 1-M inputs do not appear to be equal within tolerance.' ...
        'Check inputs for first two columns, if they look reasonable this may be a bug and can ' ...
        'be ignored.'])
end

% if all(luminance ~= -1)
%     if abs((L+L2) - luminance) > 1e4*eps(min(abs(L), abs(M)))
%         warning('Luminance does not match ')
%     end
% end

% Return value
MBout = MBin;

end
