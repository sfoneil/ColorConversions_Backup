function postCompanding = gammaCompanding(direction, inSpace, gammaVals)
%GAMMACOMPANDING Apply gamma function to RGB to linearize it, or apply
%inverse gamma function to linear RGB to voltage output.

%% Get gamma values
if nargin == 2
    [ci] = loadCI();
    gammaVals = ci.Gamma;
end

%% Problem: MATLAB wants to sometimes make negative values raised to power < 1
% as complex. Need to avoid that
negs = sign(inSpace); % Get 1 if negative, avoids making complex in inverse calculation
if strcmpi(direction, 'xyz2rgb') || strcmpi(direction, 'Inverse')
    gammaVals = 1./gammaVals;
   % companded = abs(inSpace) .^ gammaVals .* negs;
elseif strcmpi(direction, 'rgb2xyz') || strcmpi(direction, 'Linear') || ...
        strcmpi(direction, 'Linearize') || strcmpi(direction, 'Lin')
    % Do nothing for now
else
    error("Invalid companding direction. Use 'Linear' for RGB-->XYZ or 'Inverse' for XYZ-->RGB");
end

postCompanding = abs(inSpace) .^ gammaVals .* negs;
end

