%function [outputArg1,outputArg2] = plotCIE(inputArg1,inputArg2)
%PLOTCIE Summary of this function goes here
%   Detailed explanation goes here

clear
close all
figure(1)
tiledlayout(2,2); %Consider 'flow' ?

%$ First tile, DKL input for now
nexttile(1)
dklplot = imread('DKL_space_blank.png');
dklsize = size(dklplot); %%%
origin = [dklsize(2)/2, dklsize(1)/2];
xdata = -origin(1) : dklsize(2) - origin(1);
ydata = -origin(2) : dklsize(2) - origin(2);
imshow(dklplot, 'XData', xdata, 'YData', ydata);
axis on
hold on
axis equal
%axis off
axis ij

% Number boxes

%% sd


% CIE1931 design
load('cieplots.mat');
[CIEImg,~,al] = imread('\images\cie1931blank_trim.png');
% Get max range
ciexMax = max(cie1931plot(:,2)); %Right of horseshoe
cieyMax = max(cie1931plot(:,3)); %Top of horseshoe
horseshoeSize = [ciexMax cieyMax];

% sRGB data. Should use monitor specs in future
redSRGB = [0.64, 0.33, 0.2126];
greenSRGB = [0.3, 0.6, 0.7152];
blueSRGB = [0.15, 0.06, 0.0722];

% Rescale
SZ = 1000; %Size we want it to be padded to, change as needed
szScale = [0.800 0.900];
pads = round((szScale - horseshoeSize)*SZ); %Bring to .8 .9

xSize = size(CIEImg,2);
ySize = size(CIEImg,1);
scCIEImg = flipud(CIEImg); %Change so origin will be 0,0
scCIEImg = [scCIEImg, zeros(ySize, pads(2),3)];
scCIEImg = [scCIEImg; zeros(pads(1), xSize + pads(2), 3)];

figure(1);
tiledlayout(2,2);

%Tile 1
nexttile(1)
image(scCIEImg)
hold on
axis equal
axis on
axis xy

%Plot RGB
figure(1)
xs = [redSRGB(1), greenSRGB(1), blueSRGB(1), redSRGB(1)]*SZ;
ys = [redSRGB(2), greenSRGB(2), blueSRGB(2), redSRGB(2)]*SZ;
plot(xs,ys,'ko-')
hold on

%Relabel, fix later?
xt = -0.1:0.1:0.90;
yt = 0.1:0.1:0.9;
xlbls = {xt'};
ylbls = {yt'};

ax = gca;

ax.XTickLabel = xlbls;
ax.YTickLabel = ylbls;

%Tile 2
nexttile(2)
load('mb_curve.mat');
plot(mb_curve(:,2), mb_curve(:,4))
hold on

rowz = [1 31 51 71 91 131 211 311]; %From Ripamonti plot, arbitrary
plot(mb_curve(rowz,2), mb_curve(rowz,4), 'ko', 'MarkerSize', 5)
text(mb_curve(rowz,2)-0.1, mb_curve(rowz,4), num2str(mb_curve(rowz,1)))
axis equal
% axis off
axis xy



%Tile 4
nexttile(4)
z = zeros(100,100,3);
image(z)
hold on
axis equal
axis off
axis xy


%Get input?
q = '';
while ~strcmp(q,'quit')
    dklCoords = ginput(1);
    %     r = input('What is R?\n');
    %     g = input('What is G?\n');
    %     b = input('What is B?\n');

    mb = dkl2mb([dklCoords, 20]);
    lms = mb2lms(mb);
    xyz = lms2xyz(lms);
    xyy = xyz2xyy(xyz);
    rgb = xyz2rgb(xyz);

    %     xyz = rgb2xyz([r g b]);
    %     xyy = xyz2xyy(xyz);
    %     %xyy = xyy*1000;
    %     fprintf('xyY is %2.2f, %2.2f, %2.2f\n', xyy(1), xyy(2), xyy(3));

    nexttile(1)
    scatter(xyy(1), xyy(2), 8, 'white')

    nexttile(2)
    mb = lms2mb(xyz2lms(xyz));
    scatter(mb(1), mb(2), 'MarkerFaceColor', [0 0 1])

    nexttile(3)
    dkl = mb2dkl(mb);
    scatter(dkl(1) *dklsize, dkl(2)*dklsize, 'MarkerFaceColor', [0 0 0])

    nexttile(4)
    c = cat(3,ones(100,100)*r, ones(100,100)*g, ones(100,100)*b);
    image(c)
end


% xPad = round(SZ * (1 - xMax));
% yPad = round(SZ * (1 - yMax));
% bottomAdd = zeros(yPad, size(cieImg,2),3);
% rightAdd = zeros(size(cieImg,1)+yPad, xPad,3);
% cieImgPad = [cieImg, zeros(size(cieImg,1), xPad,3)];
% cieImgPad = [cieImg; zeros(yPad, size(cieImg,2),3)];

% xPad = (1 - xMax) * size(cieImg,2);
% yPad = (1 - yMax) * size(cieImg,1);

% rsz = imresize(cieImg,100);
% figure;image(rsz)

% sz = size(ciePlot);
% figure
% image(cieImg)
% axis equal
%axis off
% hold on
% plot(cie1931plot(:,2),cie1931plot(:,3), 'LineWidth', 10)

% Dummy sRGB standards, xyY

% %Close polygon
% cie1931plot(end+1, :) = cie1931plot(1, :);
%
% rgb = [1:256; 1:256; 1:256]';
%
% [x,y] = meshgrid(0:0.001:1);
%
% filledCurve = inpolygon(x, y, cie1931plot(:,2), cie1931plot(:,3));
% cVals = rgb2lms(rgb);
%end