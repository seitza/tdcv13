function [ warped_sample, P ] = randomTransformation( I, corners, max_shift, grid )
    
    % new rectangular region
    corners_shifted = zeros(4,2);
    P = zeros(4,2);
    for i = 1:8
        rand_shift = randi([-1*max_shift, max_shift], 1);
        corners_shifted(i) = corners(i)+rand_shift;
        P(i) = rand_shift;
%         corners_shifted(i) = corners(i)+rand_shift(i);
%         P(i) = rand_shift(i);
    end
    P = P(:);
    
    % compute the transformation
    H = normalized_dlt(corners, corners_shifted);
    
    %debugging
    corners
    corners_shifted
    t = (H*[corners, ones(size(corners,1),1)]')';
    round(t ./ repmat(t(:,3), 1,3))
    
    % warp the grid
    grid_warped = (H*[grid, ones(size(grid,1),1)]')';
    grid_warped = round(grid_warped ./ repmat(grid_warped(:,3), 1,3));
    
    % find intensities covered by the warped grid
    xmin = min(grid_warped(:,1));
    xmax = max(grid_warped(:,1));
    ymin = min(grid_warped(:,2));
    ymax = max(grid_warped(:,2));
    [m,n] = size(I);
    pad = round(min([1+xmin, 1+ymin, n-xmax, m-ymax]))*-1;
    %disp(pad);
    I_padded = I;
    if pad > 0
        I_padded = padarray(I, [pad, pad]);
        intensities = I_padded(sub2ind(size(I_padded), grid_warped(:,2)+pad, grid_warped(:,1)+pad));
    else
        intensities = I_padded(sub2ind(size(I_padded), grid_warped(:,2), grid_warped(:,1)));
    end
    
    normed_intensities = normIntensities(intensities);
    
    warped_sample = [grid_warped(:,1:2), normed_intensities];
    
    % add some random noise
    warped_sample(:,3) = warped_sample(:,3) + rand(size(warped_sample(:,3)));
    
%     % backwarp the image
%     [m,n] = size(I);
%     [X,Y] = meshgrid(1:n,1:m);
%     I_coords = [X(:),Y(:)]; % coordinates of the image
%     intensities = I(:);     % linearized image
%     I_backwarped = (H\[I_coords, ones(size(I_coords,1),1)]')';
%     I_backwarped = round(I_backwarped ./ repmat(I_backwarped(:,3), 1,3));
    
    
end

