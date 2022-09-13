function XYZ = xyy2xyz(xyY, varargin)
%XYY2XYZ Convert xyY chromaticity+luminance to XYZ primaries

validXYY = @isnumeric;
p = inputParser;
addRequired(p, 'xyY', validXYY);
addParameter(p, 'lxy', false)
parse(p, xyY, varargin{:});

% Reorder if Lxy, usually as supplied by i1Pro device
if p.Results.lxy == true
    xyY = [xyY(:,2), xyY(:,3), xyY(:,1)];
end

notChrom = xyY >= 1;
if all(notChrom, 'all')
    error('xyY values all >1.')
% elseif notChrom(:,1) && ~notChrom(:,[2 3])
%     % Lxy/Yxy --> xyY if from i1
%     xyY = [xyY(:,2), xyY(:,3), xyY(:,1)];
end
% Error check for no light
if xyY(3) == 0
    XYZ = [0 0 0];
end

X = (xyY(:,1) .* xyY(:,3)) ./ xyY(:,2);
Y = xyY(:,3);
%Y = xyy(3) / xyy(3); % Scaled to 1, allow to not do this?
Z = ((1 - xyY(:,1) - xyY(:,2)) .* xyY(:,3)) ./ xyY(:,2);


% X = (xyy(1) * xyy(3)) / xyy(2);
% Y = xyy(3);
% %Y = xyy(3) / xyy(3); % Scaled to 1, allow to not do this?
% Z = ((1 - xyy(1) - xyy(2)) .* xyy(3)) ./ xyy(2);
% 
XYZ = [X Y Z];

% Todo: deal with absolute vs normed?
end

