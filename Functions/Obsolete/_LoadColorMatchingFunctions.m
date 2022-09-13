% This function will return an array, which is
% different from how VB did them (with pointF variables)
%
% First run ColorInfo = Load_Monitor_Data() followed by this.

function ColorMatchingFunctions = Load_Color_Matching_Functions(FileName)

try
    
    if (exist('FileName','var') == 0)
        FileName = 'Color Matching Functions.txt'; %temp
    end
    
    ColorMatchingFunctions = importdata(FileName,','); %Comma delimited
        
catch me
    rethrow(me);
end
end