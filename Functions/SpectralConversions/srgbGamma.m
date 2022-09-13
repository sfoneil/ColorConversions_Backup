function RGB = srgbGamma(sRGB, gammaTable)
%SRGBGAMMA Given monitor-independent sRGB, apply gamma from a recorded
%display
%
%   Only necessary in a few cases, otherwise use
%   Screen('LoadNormalizedGammaTable', ...)

% Convert sRGB 0...1 to 1...256, these are the rows to look up
RGB256 = round(sRGB .* 255 + 1); % Todo decimals for bitrate
nSamples = size(sRGB,1);
RGBcols = repmat(1:3, [nSamples,1]);

% Get 3 data points ([rRow, 1]. [gRow, 2], [bRow, 3])
RGB = arrayfun(@(x,y) gammaTable(x,y), RGB256, RGBcols);

end