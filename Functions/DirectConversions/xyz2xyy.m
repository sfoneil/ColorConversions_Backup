function xyY = xyz2xyy(XYZ)
%XYZ2XYY Convert XYZ to XYY

    denom = sum(XYZ,2);
    if denom == 0
        warning('XYZ may be black?') %todo what to do here?
    end
    x = XYZ(:,1) ./ denom;
    y = XYZ(:,2) ./ denom;
    Y = XYZ(:,2);
  
    xyY = [x y Y];
    
end