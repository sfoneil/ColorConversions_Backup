function [RGBtoLMS, LMStoRGB] = makeRGB_LMStransform(phos, varargin)
%MAKERGB_LMSTRANSFORM Create 3x3 matrix to transform RGB spectra to LMS.
%Function not directly accessed but is dependency for rgb2lms() and
%lms2rgb()
%
%In lms2rgb() the inverse is used as inv(RGBmat) so monitor and fundamental
%information is still needed.
% warning('fixme')
% load cfs.mat
% cfs = CF_StockmanSharpe_2deg;
ci = loadCI();
p = iparse(phos, varargin{:});

if p.Results.CalculateTransform || ~isfield(ci, 'RGB_LMSMatrix')
    cfs = evalin('base', 'cf');

    %Fill ranges to 1 nm steps
    phos = interpolateSprague(phos);

    % Align endpoints
    [phos, cfs] = truncRange(phos, cfs);

    RGBtoLMS = cfs(:,2:4)' * phos(:,2:4);
    LMStoRGB = inv(RGBtoLMS);

else
    RGBtoLMS = ci.RGB_LMSMatrix;
    LMStoRGB = ci.LMS_RGBMatrix;
end
% Scale
% LMSweighted = phos;
% LMSweighted(:,2:4) = MBSCALE .* cfs(:,2:4);
%
%
%
% % Adjust the RGB spectra for unit luminance
% % todo: Consider optional?
% lum = LMSweighted(:,2) + LMSweighted(:,3); %Luminance, without S
%
% phosScaled = phos;
% phosScaled(:,2:4) = phos(:,2:4) ./ sum(phos(:,2:4) .* lum);
%
% %matrix transform
% %note this is in terms of the max RGB values but these need to be
% %calibrated for a given luminance - i.e. current transform does not provide
% %info on what the luminances are
% RGBmat = LMSweighted(:,2:4)' * phosScaled(:,2:4);

end