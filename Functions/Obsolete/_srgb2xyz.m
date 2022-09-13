function [xyz] = srgb2xyz(rgb)
%RGB2XYZ Convert from sRGB standard (HP/Microsoft, 1996) to XYZ for display
%of figures and plots.
%   This is monitor-independent and thus does not use phosphors or
%   colorInfo2.

if any(rgb > 1) || any(rgb < 0)
    error('RGB values are out of range.')
end

load('srgbConvMat.mat') % 3x3 conversion matrix only D65-fix later

%rgb = rgb ./ max(rgb);

srgbConst = 0.04045;

for i = 1:3
    if rgb(i) > srgbConst
        rgb(i) = ((rgb(i) + 0.055) ./ 1.055) .^ 2.4;  
  
    else
        %rgb(i) >= 0.04045
        rgb(i) = rgb(i) ./ 12.92;
    end
end
%rgb = rgb .* 100; %todo why?
xyz = sRGBMat * rgb';
xyz = xyz';

% Gamma
%srgbConst = 0.0031308;

% % todo Vectorize later
% for i = 1:3
%     if xyz1(i) > srgbConst
%         xyz1(i) = xyz1(i) .* 12.92;
%     else
%         %xyz1(i) <= srgbConst
%         xyz(i) = (xyz(i) * 1.055) .^ (1/2.4);
%     end
% end
% 
% xyz = xyz1';