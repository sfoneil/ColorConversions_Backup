function [rgb, satFlag] = xyz2rgb(xyz)
% TEMPORARILY OBSOLETED
%XYZ2RGB Wrapper for XYZ -> LMS -> RGB
%todo direct route?

[colorInfo, phos] = loadCI();


lms = xyz2lms(xyz);
[rgb, satFlag] = lms2rgb(lms);


% %% Try later?
% % Mandatory Y scaling
% xyz = xyz ./ xyz(2);`
% 
% p = inputParser;
% 
% p.addRequired('xyz');
% p.addParameter('space','srgbConvMat2.mat')
% p.parse(xyz, varargin{:});
% 
% xyz = p.Results.xyz;
% space = p.Results.space;
% load(space)
% 
% %load srgbConvMat.mat
% 
% rgbLin = sRGB \ xyz';
% %rgbLin = inv(sRGB) * xyz';
% 
% % Gamma
% srgbConst = 0.0031308;
% 
% % todo Vectorize later
% % todo other spaces besides sRGB
% for i = 1:3
%     if rgbLin(i) <= srgbConst
%         rgbLin(i) = rgbLin(i) .* 12.92;
%     else
%         %xyz1(i) <= srgbConst
%         rgbLin(i) = (rgbLin(i) * 1.055) .^ (1/2.4);
%         %rgbLin(i) = rgbLin(i) .^ (1/2.4) - 0.055;
%     end
% end
% 
% rgb = rgbLin';
% [rgb, satFlag] = checkSaturation(rgb);

end
