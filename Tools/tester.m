function result = tester(filename, ctype)
%TESTER Summary of this function goes here
%   D

%% Read data from Excel, CSV, etc.
if nargin == 0
    filename = 'indata.xlsx';
end

data = readtable(filename);
data = data.Variables; % Make matrix
%todo rows

% Define conversion strings
fromConv = "rgb";
toConv = "xyz";
Conv = sprintf('%s2%s', fromConv, toConv);
revConv = sprintf('%s2%s', toConv, fromConv);
f = str2func(Conv);
rf = str2func(revConv);
options = {'linearizing', 'L'}; % Options pairs

%% Output results
result = f(data, options{:});
rev = rf(result, options{:});
fprintf('\n');
fprintf('%s: [%2.4f, %2.4f, %2.4f]\n', Conv, data);
fprintf('== [%2.4f, %2.4f, %2.4f]\n', result);
fprintf('%s: [%2.4f, %2.4f, %2.4f]\n', revConv, rev);

% DKL = data(:,1:3);
% mmDKL = data(:,4:6);
% RGB = data(:,7:9);
% mmRGB = data(:, 10:12);
end

