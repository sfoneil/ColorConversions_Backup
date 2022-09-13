function lms = rgb2lms(RGBtoLMStransform, rgb)
%RGB2DLMS Convert RGB to LMS without monitor spectra
%   Conversion that does not require monitor phosphors, but does need an
%   RGB matrix created with e.g. calibrateMonitor_PRonly.m
%   Code may become legacy as colorInfo is replaced
%
%   Default RGBtoLMStransform == colorInfo.RGBMatrix
%todo make optional?
lms = (RGBtoLMStransform * rgb')';


end

