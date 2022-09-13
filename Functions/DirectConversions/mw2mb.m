function MB = mw2mb(MW, varargin)
%MW2MB Convert re-centered Mike Webster space to MacLeod-Boynton
%   MW is an Nx3 space where:
%       MW(:,1) == L-M
%       MW(:,2) == S-(L+M)
%       MW(:,3) == L+M luminance
%   MB is a Nx3 space where:
%       MB(:,1) == L/(L+M) or red response
%       MB(:,2) == M/(L+M) or green response
%           Note G == 1 - R, you may implement checks to verify this
%       MB(:,3) == S/(L+M) or blue response


% Check 
if size(MW.Value, 2) == 2
    error('MW space must be Nx3. Add in luminance colum in if it is supplied separately.')
end
p = iparse(MW, varargin{:});

origin = p.Results.Origin;
scale = p.Results.AxisScale;
rotation = p.Results.AxisRotation;
data = MW.Value;

% Todo calculate these later via White Point
%xyz2mb(si.C_2,'MBScale',[1 1 1],'CAT','old') %does it but some rounding
%error?
%mbL = MW(:,1) .*scale(1) ./ 1955 + 0.6568;
mbL = data(:,1) ./ scale(1) + origin(1);
mbM = 1 - mbL;
%mbS = MW(:,2) .*scale(2) ./ 5533 + 0.01825;
mbS = data(:,2) ./ scale(2) + origin(2);
mbLum = data(:,3);

MB = trival({'MB', [mbL, mbM, mbS], data(:,3)});

% MB.Luminance is kept by copying

end

