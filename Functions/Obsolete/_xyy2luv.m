function [outputArg1,outputArg2] = xyy2luv(xyy)
%XYY2LUV Convert CIE1931 xyY color space to CIE1976 Lu*v* color space

if 


Convert_XYZ_to_Luv(Convert_xyL_to_XYZ(xyL));

    function XYZ_to_Luv = Convert_XYZ_to_Luv(XYZ)
    SngLuv(3) = zeros;
    SngLuv(1) = XYZ(2); %L = Y
    SngLuv(2) = (4 * XYZ(1))/(XYZ(1) + 15 * XYZ(2) + 3 * XYZ(3)); %u'
    SngLuv(3) = (9 * XYZ(2))/(XYZ(1) + 15 * XYZ(2) + 3 * XYZ(3)); %v'
    XYZ_to_Luv = SngLuv;
end


function xyL_to_XYZ = Convert_xyL_to_XYZ(xyL)
SngTemp(3)=zeros;
SngTemp(1) = xyL(1) * (xyL(3) / xyL(2));
SngTemp(2) = xyL(2) * (xyL(3) / xyL(2)); %'= xyL(2)
SngTemp(3) = (1 - xyL(1) - xyL(2)) * (xyL(3) / xyL(2));
xyL_to_XYZ = SngTemp;
end


end

