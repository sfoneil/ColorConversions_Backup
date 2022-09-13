function [XYZ] = rgb22xyz(RGB)
%RGB22XYZ Summary of this function goes here
%   Detailed explanation goes here

load Ripamonti_built.mat
load cmfs.mat
rgb = [.4 .6 .8];
x = CMF_StockmanSharpe_2deg(1:391,1);
cmf = CMF_StockmanSharpe_2deg(1:391,2:4);
phos = colorInfo2.Phosphors(:,2:4);
xyzMaybe = phos .* cmf;
xyzMaybe = sum(xyzMaybe)

%xyz should be 0.277660, 0.299648, 0.614357


end

