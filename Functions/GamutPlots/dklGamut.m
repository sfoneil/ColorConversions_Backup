function [lastContrast, RGBstoppedAt, flagsOutOfGamut, unclampedRGB] = dklGamut(varargin)
%DKLGAMUT Find gamut of DKL for a give monitor iteratively.
%   Probably not the best way, but only have to run once!

% Load monitor data
%load(strcat(filename, '.mat');

%todo integrate with adjustAngles(). What if MM changes gamut?

%% Parse
p = inputParser;
addParameter(p, 'MinimumMotion', [0 0 0]); % 0 0 0 == no MM data format: [LM SLM Lum]
addParameter(p, 'AllowFlexible', 1); % 0 == end when ANY out of gamut, 1 == only when larger
addParameter(p, 'StepSize', 15);

parse(p, varargin{:})

mm = p.Results.MinimumMotion;
flex = p.Results.AllowFlexible;
angleStep = p.Results.StepSize;
% if nargin == 0
%     ALLOWFLEXIBLE = 1;
% elseif nargin == 1
%     ALLOWFLEXIBLE = varargin{1};
% end

%% Contrast values to change in loop
contrastStep = 0.0001;
initialContrast = contrastStep; % Can start higher for speed
contrast = initialContrast;
endContrast = 1.1; % Optional, to avoid infinite loop. Set to -1 to run forever, if you're really sure

%% Coordinates to set at beginning, change values as needed
angles = 0:angleStep:360-angleStep;
rgbBackground = [0.5 0.5 0.5];
unscaledLM = cosd(angles)';
unscaledSLM = sind(angles)';
luminance = zeros(size(unscaledLM));

while contrast <= endContrast
    % Get and convert DKL
%     if contrast == endContrast% && contrastStop ~= -1 % And should happen, but just in case
%         fprintf('Stopped without going out of gamut at %2.2f', endContrast);
%         break
%     end
    LM = contrast .* unscaledLM;
    SLM = contrast .* unscaledSLM;
    DKL = [LM SLM luminance];
    DKL = adjustAngles(DKL, 'MinimumMotion', mm);
    [RGB, sat, orig] = dkl2rgb(DKL, 'Background', rgbBackground);

    if nnz(sat) > 0
        if flex
            if max(abs(sat(:))) >= 1
                fprintf('Out of gamut at %2.6f. Last good contrast = %2.6f\n\n', contrast, contrast - contrastStep);
                break
            end
        else
            fprintf('Out of gamut at %2.6f. Last good contrast = %2.6f\n\n', contrast, contrast - contrastStep);
            break
        end
    end

    contrast = contrast + contrastStep;
end

lastContrast = contrast - contrastStep;
RGBstoppedAt = RGB;
flagsOutOfGamut = sat;
unclampedRGB = orig;

%% For asymmetrical
%0.1888 with EM415
contrast = lastContrast;
while contrast <= endContrast
    LM = contrast .* unscaledLM;
    %SLM = contrast .* unscaledSLM;
    DKL = [LM SLM luminance];
    DKL = adjustAngles(DKL, 'MinimumMotion', mm);
    [RGB, sat, orig] = dkl2rgb(DKL, 'Background', rgbBackground);

       if nnz(sat) > 0
        if flex
            if max(abs(sat(:))) >= 1
                fprintf('Out of 2nd gamut at %2.6f. Last good contrast = %2.6f\n\n', contrast, contrast - contrastStep);
                break
            end
        else
            fprintf('Out of 2nd gamut at %2.6f. Last good contrast = %2.6f\n\n', contrast, contrast - contrastStep);
            break
        end
    end

    contrast = contrast + contrastStep;
end
end

