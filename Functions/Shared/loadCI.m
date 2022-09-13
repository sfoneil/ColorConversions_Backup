function [ci, phos] = loadCI()
%LOADCI Simple function to check that variable named 'colorInfo' exists.
%This is for conciseness of code in transfering main workspace to a
%conversion function. It should be in all %conversions, regardless of
%whether they use it directly, as it may be used along the chain of
%conversions in wrapper conversions functions.
%   ci = loadCI;    Returns colorInfo variable if it exists, otherwise
%   returns error.
%   
%   [ci, phos] = loadCI;    Returns colorInfo and colorInfo.Phosphors

% Get version information
%global cfs
%load('cfs.mat');
%cfs = CF_SmithPokorny_1975_2deg;
%warning('test mode: fundamentals wrong!')

versionFilename = 'colorInfo2 version.txt';
if ~exist('versionFilename', 'file')
    %todo make path file
%     warning(['%s does not exist in path. This may be okay, but it should be verified that' ...
%         ' you are using a current version.'], versionFilename);
    ci = evalin('base', 'colorInfo2'); % Get struct from base workspace
    phos = ci.Phosphors;
    return
else
    versionFile = fopen(fullfile(pwd, versionFilename),'r');
    versionData = textscan(versionFile, '%s %f %s');
    currentVersion = versionData{2}(1);
    majorVersion = versionData{2}(2);
    fclose(versionFile);
end

try
    ci = evalin('base', 'colorInfo2'); % Get struct from base workspace
    if contains(ci.Version, 'Generic')
        % Is generic
        warning(['Generic monitor profile loaded. This perfectly fine for testing and' ...
            ' some experiments, but make sure you want to do this!'])
    elseif ~isfield(ci,'Version')
        warning('Very old colorInfo2. Update it.')
    elseif majorVersion < ci.Version
        % Known updates to the colorInfo2 structure or other parts
        warning(['Version of the colorInfo2 loaded is older than the current major release.' ...
            ' Strongly recommend re-measuring this monitor, unforseen errors may occur.']);
    elseif curentVersion ~= ci.Version
        % Version has changed, but may reflect minor changes
        warning(['Version mismatch between current colorInfo2 version and the one loaded' ...
            ' this may not be a problem but verify code works and consider remeasuring your display.']);
    end
catch ME
    throw(ME);
    error('colorInfo2 variable cannot be found. Verify it is loaded or the name of the VARIABLE has not been changed, rename if so. The .mat file can be any name.')
end
phos = ci.Phosphors;
end
