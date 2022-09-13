function MW = mb2mw(MB, varargin)
%MB2MW Summary of this function goes here
%   Detailed explanation goes here

% if size(MB,2) == 4
%     lum = varargin;
% else
%     lum = ones(size(MB,1),1) .* -1;
% end

% Add MB G if not present
p = iparse(MB, varargin{:});
data = MB.Value;

if size(data,2) == 2
    data = [data(:,1), 1-data(:,1), data(:,2)]; % For consistency
end

% if size(MB,2) == 3
%     lum = ones(size(MB,1),1) .* -1;
% elseif size(MB,2) == 4
%     lum = MB(:,4);
% end

%todo make this accept other white points
LvsM = (data(:,1) - 0.6568) .* 1955; %* 2754; % 1955;
SvsLM = (data(:,3) - 0.01825) .* 5533; %* 4099; % 5533;
MW = trival({'MW', [LvsM, SvsLM, MB.Luminance], MB.Luminance});
end

