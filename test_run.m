% as = []; adj = [];
% new = [-5,100]
% for i = 0:10:350
%     angle = [cosd(i), sind(i)];
%     as = [as; angle];
%     adjusted = adjustDKLangles([1 angle(1) angle(2)], new)';
%     adj = [adj; adjusted];
% end
% plot(as(:,1),as(:,2),'ro',adj(:,1),adj(:,2),'bo')
% axis([-1.5 1.5 -1.5 1.5])
% axis square
% hold on
% plot([1 -1],[0 -0],'r-',[0 0],[1 -1],'r-')
% plot([a1 -a1],[a2 -a2],'b-',[b1 -b1],[b2 -b2],'b-')

% Test kitchen
clear
addpath(strcat(pwd,'\Main_functions\'))
addpath(strcat(pwd,'\Fundamentals\'))
addpath(strcat(pwd,'\Recorded monitor phosphors\'))
load StockmanSharpe_lin_2deg.mat
load MSS310_crt_phosphors.mat
load SS_cmfs.mat

%%
xyz = rgb2xyz(phosphors, SS_CMF_2deg, [1 .5 .5]); % 0.1132    0.1024    0.11422
lab = xyz2lab(xyz) %0.9253    0.6505   -0.0380
xyz2 = lab2xyz(lab) % -0.1041    0.0010    0.0011

% Their lab:
%  0.9253    0.6505   -0.0380 check

% 'd65_2'
%     white=[94.811 100.00 107.304];
% 0.1132    0.1024    0.1142
%
% 'd65_2'
%     white=[95.047 100.00 108.883];
%
% 0.1130    0.1024    0.1125
%%
lms = rgb2lms(phosphors, [1 .5 .5])    % 0.1069    0.0823    0.0590
xyz = lms2xyz(lms) % 0.1132    0.1024    0.1142
luv = xyz2luv(xyz) % 0.9253    0.4127    0.0323
xyz2 = luv2xyz(luv) * 100
% theirs     0.9253    0.3547   -0.0820


%%
rgb1 = [0 0 0;
    255 255 255;
    255 0 0;
    0 255 0;
    0 0 255;
    255 255 0;
    0 255 255;
    255 0 255;
    191 191 191;
    128 128 128;
    128 0 0;
    128 128 0;
    0 128 0;
    128 0 128;
    0 128 128;
    0 0 128]/255;

hsv = zeros(size(rgb1));
rgb2 = hsv;

for inc = 1:size(rgb1,1)
    hsv(inc, :) = rgb2hsv(rgb1(inc, :),0);
end


for ct = 1:size(hsv,1)
    rgb2(ct, :) = hsv2rgb(hsv(ct, :));
end



load StockmanSharpe_lin_2deg.mat
load MSS310_crt_phosphors.mat

lms = rgb2lms(phosphors, cfs, [1 1 1])
    0.1694    0.1496    0.1151
lms = r2lms(phosphors, cfs, [1 0 0])
    0.0444    0.0151    0.0029

lms = rgb2lms(phosphors, cfs, [0 1 0])
    0.1074    0.1102    0.0109

lms = rgb2lms(phosphors, cfs, [0 0 1])
    0.0176    0.0243    0.1013

lms = rgb2lms(phosphors, cfs, [.5 .7 1])
    0.1150    0.1090    0.1104

lms = rgb2lms(phosphors, cfs, [2 -5 .7])
   -0.4356   -0.5036    0.0223 WRONG



%Example program of how to use the functions
clear
close all

% load MSS310_crt_phosphors.mat
% load StockmanSharpe_lin_2deg.mat
load harmonized.mat
load illuminants.mat

% load mw_spec.mat
% load mw_ss5.mat

% b = [0.1; 0.1; 0.1];
% lms_t = [0.0888; 0.0630; 0.0383];
% lms_b = [0.0659; 0.0549; 0.0375];

% b = rgb2lms([0.5 0.5 0.5]', fixPhos, fix_cfs);
% 
% rgb = [255 206 251]/255; %Sort of desat pink
% rgb = [0 1 0]
% 
% lms = rgb2lms(fixPhos, fix_cfs, rgb);
% mb = lms2mb(lms);
% dkl = lms2dkl(b, lms);
% 
% mb2 = dkl2mb(dkl); %need fix
% lms2 = dkl2lms(b, dkl);
% rgb2 = lms2rgb(lms2, fixPhos, fix_cfs);
% 
% l = dkl2lms(lms, [1.133 -0.0361 0.0671]);
% r = lms2rgb(b, fixPhos, fix_cfs)

cd('F:\SO Backup\_Post-grad Research\cc\')
bkgdrgb = [0.5 0.5 0.5];
bkgdlms = rgb2lms(fixPhos, fix_cfs, bkgdrgb);

rgb = [1 0 0];
mrlms = rgb2lms(fixPhos, fix_cfs, rgb);
mrdkl = lms2dkl(bkgdlms, mrlms);
mrlms2 = dkl2lms(bkgdlms, mrdkl);
mrrgb = lms2rgb(fixPhos, fix_cfs, mrlms2);


fDKL = rgb2dkl(fixPhos, fix_cfs, rgb, bkgdrgb);
fRGB = dkl2rgb(fixPhos, fix_cfs, fDKL, bkgdrgb);

rgb = [0 1 0];
mglms = rgb2lms(fixPhos, fix_cfs, rgb);
mgdkl = lms2dkl(bkgdlms, mglms);
mglms2 = dkl2lms(bkgdlms, mgdkl);
mgrgb = lms2rgb(fixPhos, fix_cfs, mglms2);

rgb = [0 0 1];
mblms = rgb2lms(fixPhos, fix_cfs, rgb);
mbdkl = lms2dkl(bkgdlms, mblms);
mblms2 = dkl2lms(bkgdlms, mbdkl);
mbrgb = lms2rgb(fixPhos, fix_cfs, mblms2);

mgmt = findGamut(fixPhos, fix_cfs, bkgdrgb);
mydkl = [mrdkl; mgdkl; mbdkl];
% %THEIRS
% % % cd('F:\SO Backup\_Post-grad Research\toolbox_v1.3\')
% % % ph = fixPhos(:,2:4);
% % % cf = fix_cfs(:,2:4);
% % % 
% % % bkgdrgb = [0.5 0.5 0.5]';
% % % bkgdlms = rgb2lms(ph, cf, bkgdrgb);
% % % 
% % % rgb = [1 0 0]';
% % % rlms = rgb2lms(ph, cf, rgb);
% % % rdkl = lms2dkl(bkgdlms, rlms);
% % % rdklsph = dkl_sph2cart(rdkl);
% % % rlms2 = dkl2lms(bkgdlms, rdkl);
% % % rrgb = lms2rgb(ph, cf, rlms2);
% % % 
% % % rgb = [0 1 0]';
% % % glms = rgb2lms(ph, cf, rgb);
% % % gdkl = lms2dkl(bkgdlms, glms);
% % % gdklsph = dkl_sph2cart(gdkl);
% % % glms2 = dkl2lms(bkgdlms, gdkl);
% % % grgb = lms2rgb(ph, cf, glms2);
% % % 
% % % rgb = [0 0 1]';
% % % blms = rgb2lms(ph, cf, rgb);
% % % bdkl = lms2dkl(bkgdlms, blms);
% % % bdklsph = dkl_sph2cart(bdkl);
% % % blms2 = dkl2lms(bkgdlms, bdkl);
% % % brgb = lms2rgb(ph, cf, blms2);
% % % % bak = rgb2lms(fixPhos(:,2:4), fix_cfs(:,2:4), bk'); % 0.0212    0.0187    0.0144
% % % % 
% % % % wlms = rgb2lms(fixPhos(:,2:4), fix_cfs(:,2:4), [1 0 0]'); %0.0111    0.0038    0.0007
% % % % dkl = lms2dkl(bak, wlms); %1.0856   -0.2285    0.3222
