currDir = mfilename('fullpath');
%slash = filesep; %PC \; Mac, Linux /
[basePath, filename, ext] = fileparts(currDir);
conversionPath = genpath(basePath);
addpath(conversionPath);
%clearvars