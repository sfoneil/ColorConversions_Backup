function XYZ = lms2xyzc()
%LMS2XYZC Summary of this function goes here
%   Detailed explanation goes here
convMatSS = [1.94735469, -1.41445123, 0.36476327; ...
    0.68990272, 0.34832189, 0; ...
    0, 0, 1.93485343];

% Get data
load('cfs.mat');
cf = CF_StockmanSharpe_2deg;
x = cf(:,1);
y = cf(:,2:4);
load('cmfs.mat');
cmf = CMF_StockmanSharpe_2deg;

% Multiply by fundamentals
cmf2 = convMatSS * y';

figure;
%subplot(1,2,1)
plot(x, cmf(:,2:4),'k-')

%subplot(1,2,2)
hold on
plot(x, cmf2,'b:')
q=cmf(:,2:4) - cmf2';
end