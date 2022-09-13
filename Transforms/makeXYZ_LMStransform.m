function [XYZtoLMS, LMStoXYZ] = makeXYZ_LMStransform(varargin)
%MAKEXYZ_LMSTRANSFORM Computes direct transform between LMS and XYZ-like
%space
ci = loadCI();
%p = iparse(NaN, varargin{:});
% if p.Results.CalculateTransform || ~isfield(ci, 'XYZ_LMSMatrix')

% Make forward conversion matrices
[RGBtoLMS, LMStoRGB] = makeRGB_LMStransform(ci.Phosphors, varargin{:});
[RGBtoXYZ, XYZtoRGB] = makeRGB_XYZtransform(ci.CIEx, ci.CIEy, varargin{:});

% Calculate combined transform, steps right to left
XYZtoLMS = RGBtoLMS * XYZtoRGB;
LMStoXYZ = RGBtoXYZ * LMStoRGB; % OR: LMStoXYZ2 = inv(XYZtoLMS);

% else
%     XYZtoLMS = ci.XYZ_LMSMatrix;
%     LMStoXYZ = ci.LMS_XYZMatrix;
% end

end

