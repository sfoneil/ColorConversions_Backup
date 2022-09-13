function XYZ = spect2xyz(RGB)
%SPECT2XYZ Summary of this function goes here
%   Detailed explanation goes here
ci = loadCI();
cfs = ci.Fundamentals;
phos = ci.Phosphors;
phos = interpolateRange(phos);
cfs = interpolateRange(cfs);
% Align endpoints
[phos, cfs] = truncRange(phos, cfs);

% Split
x = cfs(:,1);
f = cfs(:,2:4);
phos = phos(:,2:4);

convMat = [1.94735469, -1.41445123, 0.36476327; ...
    0.68990272, 0.34832189, 0; ...
    0, 0, 1.93485343];
cmf = convMat * f'; % Get color matching function. Could also load .mat, todo timing tests

phos = phos .* RGB;
xyz = cmf' .* phos;


%RGB .4 .7 .3]
%xyz = 0.2056    0.3482    0.1138

%XYZ = cmf' .* LMS;
%XYZ = sum(XYZ);
end

