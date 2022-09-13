function [CCT1, CCT2] = toTemperature(xyY)
%TOTEMPERATURE Convert CIE1931 to nearest color temperature Kelvin
%equivalent. Result is an approximation.

% Luv1960 = Luv;
% Luv1960(3) = Luv1960(3) ./ 1.5; % Conversion uses Luv 1960 space
% 
% % Simple method - daylight range

% Mired curve
tRange = 0:0.1:1000;
M = 1000000 ./ tRange;

% Kelly center
n = (xyY(1)  - 0.3320) ./ (xyY(2) - 0.1858);
CCT1 = (-440 .* n.^3) + (3525 .* n.^2) - (6823.3 .* n) + (5520.33);

% Alternate method
% Constants
k3to50 = struct();
k3to50.xe = 0.3366;
k3to50.ye = 0.1735;
k3to50.A0 = -949.86315;
k3to50.A1 = 6253.80338;
k3to50.t1 = 0.92159;
k3to50.A2 = 28.70599;
k3to50.t2 = 0.20039;
k3to50.A3 = 0.00004;
k3to50.t3 = 0.07125;

k50to800 = struct();
k50to800.xe = 0.3356;
k50to800.ye = 0.1691;
k50to800.A0 = 36284.48953;
k50to800.A1 = 0.00228;
k50to800.t1 = 0.07861;
k50to800.A2 = 5.4535e-36;
k50to800.t2 = 0.01543;

CCT2 = k3to50.A0 + (k3to50.A1 .* exp(-n ./ k3to50.t1)) + ...
    (k3to50.A2 .* exp(-n ./ k3to50.t2)) + ...
    (k3to50.A3 .* exp(-n ./ k3to50.t3));

% Format to decimal
CCT1 = sprintf('%5.2f', CCT1);
CCT2 = sprintf('%5.2f', CCT2);
end

