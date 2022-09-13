function cfs = loadFundamentals(fundName)
%LOADFUNDAMENTALS Load cone fundamentals based on user input of string
%corresponding to data in cmf.mat
%   Default is Stockman & Sharpe 2-degree fundamentals

availFunds = {'CF_StockmanSharpe_2deg', 'SS', 'SS2', 'SS_2',...
    'CF_StockmanSharpe_10deg', 'SS10', 'SS_10',...
    'CF_SmithPokorny_1975_2deg', 'SP2', 'SP_2', 'SmithPokorny'};

defaultFund = availFunds{1};

if nargin == 0
    fundName = defaultFund;
end

if ~any(contains(availFunds, fundName))
    fprintf('Valid fundamentals:\n');
    for i = 1:length(availFunds)
        fprintf('   %s\n', availFunds{i});
    end
    error('Invalid entry. See above for valid values.\n');
end

f = load('cfs.mat', fundName);
cfs = f.(fundName);

end