function [ warped_sample, P ] = randomTransformation( I, corners, max_shift, grid )
    
    % new rectangular region
    rand_shift = randi([-1*max_shift, max_shift], 4,2);
    corners_shifted = corners + rand_shift;
    P = rand_shift(:);
    
    warped_sample = warpSample(I, grid, corners, corners_shifted);
    
%     % backwarp the image
%     [m,n] = size(I);
%     [X,Y] = meshgrid(1:n,1:m);
%     I_coords = [X(:),Y(:)]; % coordinates of the image
%     intensities = I(:);     % linearized image
%     I_backwarped = (H\[I_coords, ones(size(I_coords,1),1)]')';
%     I_backwarped = round(I_backwarped ./ repmat(I_backwarped(:,3), 1,3));
    
    
end

