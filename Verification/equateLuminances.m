function [lumPcts, lum255] = equateLuminances(useGamma)
%EQUATELUMINANCES Find maximum RGB values for equal luminances of R, G, B guns
%   Not terribly sophisticated, quick test

if nargin == 0
    useGamma = true;
end

ci = loadCI();
maxLum = ci.MaxLuminance;

vsRed = maxLum(1) ./ maxLum;
vsGreen = maxLum(2) ./ maxLum;
vsBlue = maxLum(3) ./ maxLum; % Probably worthless

lumPcts = [vsRed; vsGreen; vsBlue];

% if ~useGamma
%     lumPcts = lumPcts .^ 1./ci.Gamma;
% end
lum255 = round(lumPcts .* 255);
end