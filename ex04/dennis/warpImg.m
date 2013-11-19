function [imWarped offset] = warpImg(inputImg, H)
    [h w c] = size(inputImg);
    
    %in order to generate a grid for the warped image we need to apply
    %the transform to the corner points
    cornerPts = H*[ 1 1 w w ; 1 h 1 h ; 1 1 1 1 ];
    %normalize homogeneous coordinates
    cornerPts = cornerPts./repmat(cornerPts(3,:),3,1);
    
    %since the minimum distance that we have is 1
    %and the maximum points for both axes and fit
    [X_grid,Y_grid] = ndgrid( min( cornerPts(1,:)) : 1 : max(cornerPts(1,:) ), ...
                              min( cornerPts(2,:) ) : 1 : max(cornerPts(2,:) ));
                          
    [numRow numCol] = size(X_grid);
    % inverse mapping im1points = H^(-1) * im2points
    im1points = H \ [ X_grid(:) Y_grid(:) ones(numRow*numCol,1) ]';
    %normalize homogeneous coordinates
    im1points = im1points./repmat(im1points(3,:),3,1); 
    
    xI = reshape( im1points(1,:),numRow,numCol)';
    yI = reshape( im1points(2,:),numRow,numCol)';
    
    %interpolate the point values for each color channel
    imWarped(:,:,1) = interp2(inputImg(:,:), xI, yI);
%     imWarped(:,:,2) = interp2(inputImg(:,:,2), xI, yI);
%     imWarped(:,:,3) = interp2(inputImg(:,:,3), xI, yI);
    
    %assign minimum corners as the offset of the image
    cornerPts = round(cornerPts);
    offset = [ min( cornerPts(1,:)) min( cornerPts(2,:) ) ];
end
