function [ robust_points ] = robust_harris( I, n )
% computes the most robust harris points
% n is the number of transformations that should be used for the
% computation

    keypoints = corner(I, intmax);
    scores = zeros(size(keypoints,1), 1);

    for i = 1:n
        % create affine transformation matrix
        T = create_affine_transformation();
        %T = [0.9848, -0.1736, 0; 0.1736, 0.9848, 0; 0,0,1];
        tform = affine2d(T);
        I_warped = imwarp(I, tform);
        
        keypoints_warped = corner(I_warped, intmax);
        
        [x_out, y_out] = outputLimits(tform, [1, size(I, 2)], [1, size(I, 1)]);
        
        % transform keypoints of the warped image into the original
        % coordinate system
        keypoints_warped = [keypoints_warped(:,1)+x_out(1)-1, keypoints_warped(:,2)+y_out(1)-1];
        
        % backwarp the keypoints
        keypoints_backwarped = round(transformPointsForward(invert(tform), keypoints_warped));
        
        % get rid of points outside of the image
        keypoints_backwarped = keypoints_backwarped(keypoints_backwarped(:,1)>0 & keypoints_backwarped(:,2)>0 & keypoints_backwarped(:,1) <= size(I, 2) & keypoints_backwarped(:,2) <= size(I,1), :);

        % store points in a boolean matrix
        mask = zeros(size(I));
        l = sub2ind(size(mask), keypoints_backwarped(:,2), keypoints_backwarped(:,1));
        mask(l) = 1;
        
        neighbor = 2;
        mask = padarray(mask, [neighbor, neighbor]);
        
        % search for matching points
        for m = 1:size(keypoints,1)
            window = mask(keypoints(m,2):keypoints(m,2)+2*neighbor, keypoints(m,1):keypoints(m,1)+2*neighbor);
            if any(any(window == 1) == 1) == 1
                scores(m) = scores(m) + 1;
            end
        end
 
    end

    robust_points = keypoints(scores >= (n-1),:);
    
end

