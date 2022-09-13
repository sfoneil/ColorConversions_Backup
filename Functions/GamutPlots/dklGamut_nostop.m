% function [lastContrast, RGBstoppedAt, flagsOutOfGamut, unclampedRGB] = dklGamut_nostop(varargin)
% %DKLGAMUT Find gamut of DKL for a give monitor iteratively.
% %   Probably not the best way, but only have to run once!
% 
% % Load monitor data
% %load(strcat(filename, '.mat');
% 
% %todo integrate with adjustAngles(). What if MM changes gamut?
% 
% %% Parse
% p = inputParser;
% addParameter(p, 'MinimumMotion', [0 0 0]); % 0 0 0 == no MM data format: [LM SLM Lum]
% addParameter(p, 'AllowFlexible', 1); % 0 == end when ANY out of gamut, 1 == only when larger
% addParameter(p, 'StepSize', 15);
% 
% parse(p, varargin{:})
% 
% mm = p.Results.MinimumMotion;
% flex = p.Results.AllowFlexible;
% angleStep = p.Results.StepSize;
% % if nargin == 0
% %     ALLOWFLEXIBLE = 1;
% % elseif nargin == 1
% %     ALLOWFLEXIBLE = varargin{1};
% % end

%% MM
lumAmp = [    0.0200   -0.1400
    -0.0700    0.2000
    0.1900   -0.1700
    0.1900    0.1900];

lumAveLM = 0.0825;
lumAveS = 0.0200;
mm = [lumAveLM, lumAveS 0];

%% Contrast values to change in loop
angleStep = 45;
contrastStep = 0.01;
initialContrast = contrastStep; % Can start higher for speed
contrast = initialContrast;
endContrast = 1.1; % Optional, to avoid infinite loop. Set to -1 to run forever, if you're really sure

%% Coordinates to set at beginning, change values as needed
load Renown_South_Meadows_VPixx.mat
angles = 0:angleStep:360-angleStep;
rgbBackground = [0.5 0.5 0.5];
unscaledLM = cosd(angles)';
unscaledSLM = sind(angles)';
%luminance = zeros(size(unscaledLM));

contrasts = 0:contrastStep:endContrast;
contrastLvls = contrasts./contrastStep+1;
LMs = unscaledLM.*contrasts; %angle rows at each col contrast
Ss = unscaledSLM.*contrasts;


%
% range =-endContrast:contrastStep:endContrast;
% [x,y] = meshgrid(-unscaledLM*endContrast:contrastStep:unscaledLM*endContrast, ...
%     -unscaledSLM*endContrast:contrastStep:unscaledSLM*endContrast);
luminance = zeros(size(LMs));
flagz = zeros(size(LMs));


for col = 1:size(LMs,2)
    DKL = [LMs(:,col), Ss(:,col), luminance(:,col)];
    DKL = adjustAngles(DKL, 'MinimumMotion', mm);

    %     DKL = [x(:,col) y(:,col), luminance(:,col)];
    [RGB, sat, orig] = dkl2rgb(rgbBackground, DKL);
    flagz(:,col) = any(sat, 2);
end
close all
figure
imagesc(flagz)
lastOpen = size(flagz,2) - sum(flagz,2);
lastContrasts = contrasts(lastOpen');
figure
plot(cosd(angles).*lastContrasts, sind(angles).*lastContrasts)
axis([-endContrast endContrast -endContrast endContrast])
axis equal
hold on

axIdx = [find(angles==0), find(angles==90), find(angles==180), find(angles==270)];
axCont = lastContrasts(axIdx);
rect = [-1.*axCont(3), -1.*axCont(4), ...
     axCont(1) + axCont(3), ...
    axCont(2) + axCont(4)];
rectangle('position', rect,'curvature',[1 1])

% newDKL = [cosd(angles).*lastContrasts, sind(angles).*lastContrasts, 0];
% mmDKL = adjustAngles(newDKL, 'MinimumMotion', mm);
% [RGB, sat, orig] = dkl2rgb(rgbBackground, DKL);
% for contrast = initialContrast:contrastStep:endContrast
%     % Get and convert DKL
% %     if contrast == endContrast% && contrastStop ~= -1 % And should happen, but just in case
% %         fprintf('Stopped without going out of gamut at %2.2f', endContrast);
% %         break
% %     end
%     LM = contrast .* unscaledLM;
%     SLM = contrast .* unscaledSLM;
%     DKL = [LM SLM luminance];
%     DKL = adjustAngles(DKL, 'MinimumMotion', mm);
%     [RGB, sat, orig] = dkl2rgb(rgbBackground, DKL);
% 
% %     if nnz(sat) > 0
% %         if flex
% %             if max(abs(sat(:))) >= 1
% %                 fprintf('Out of gamut at %2.6f. Last good contrast = %2.6f\n\n', contrast, contrast - contrastStep);
% %                 break
% %             end
% %         else
% %             fprintf('Out of gamut at %2.6f. Last good contrast = %2.6f\n\n', contrast, contrast - contrastStep);
% %             break
% %         end
% %     end
% 
%   %  contrast = contrast + contrastStep;
% end
% 
% lastContrast = contrast - contrastStep;
% RGBstoppedAt = RGB;
% flagsOutOfGamut = sat;
% unclampedRGB = orig;

%% For asymmetrical
%0.1888 with EM415
% contrast = lastContrast;
% while contrast <= endContrast
%     LM = contrast .* unscaledLM;
%     %SLM = contrast .* unscaledSLM;
%     DKL = [LM SLM luminance];
%     DKL = adjustAngles(DKL, 'MinimumMotion', mm);
%     [RGB, sat, orig] = dkl2rgb(rgbBackground, DKL);
% 
%        if nnz(sat) > 0
%         if flex
%             if max(abs(sat(:))) >= 1
%                 fprintf('Out of 2nd gamut at %2.6f. Last good contrast = %2.6f\n\n', contrast, contrast - contrastStep);
%                 break
%             end
%         else
%             fprintf('Out of 2nd gamut at %2.6f. Last good contrast = %2.6f\n\n', contrast, contrast - contrastStep);
%             break
%         end
%     end
% 
%     contrast = contrast + contrastStep;
% end
%end

