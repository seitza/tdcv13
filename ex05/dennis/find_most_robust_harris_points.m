% this function tries to find the most n robust harris points
% this is done by transforming the image by a number of affine
% transforms. for every affine transform the harris corner points
% are detected and backwarped. The backwarped points are compared
% with the harris points in the reference image and in the end
% the n harris points with the highest occurence are taken

% parameters:
% - reference image
% - number of robust points
% - number of transforms

% returns:
% a nx2 vector of the most robust corner points where
% the first column denotes the x-index, the second column the y-index
function [pts] = find_most_robust_harris_points(img, nr_points, angle_range, lambda_range, iterations)
    % return vector (x,y) index!!!
    [m,n] = size(img);
    hits = zeros(size(img));
    neighbourhood = [7; 7];
    
    % compute harris points on reference image
    ref_corner_pts = corner(img, 'Harris', intmax);
    
    % check if we detect enough pts
    assert(nr_points <= size(ref_corner_pts,1), ...
        'Too less corner points in reference image are detected - can not compute that number of robust keypoints');
    
    % dbg
%     ref_img_handle = figure('Name', 'Original image', 'NumberTitle', 'Off');
%     imagesc(img), axis equal tight off, colormap gray;
%     hold on;
%     plot(ref_corner_pts(:,1), ref_corner_pts(:,2), 'rx');
%     hold off;

    for it=1:iterations
        % now do some random affine transformation
        theta = angle_range(1) + (angle_range(2) - angle_range(1)) * rand(1);
        phi = angle_range(1) + (angle_range(2) - angle_range(1)) * rand(1);
        lambdas = lambda_range(1) + (lambda_range(2)-lambda_range(1)).*rand(2,1);

        H = create_affine_transform(theta, phi, lambdas);
        tform = affine2d(H); 

        % warp image
        img_warp = imwarp(img, tform);
        [xlim, ylim] = outputLimits(tform, [1, size(img,2)], [1, size(img,1)]);

        % run corner detection on warped image
        corner_pts_warp = corner(img_warp, 'Harris', intmax);

    %     % dbg
    %     fprintf('We have found %d corner points for warped image...\n', size(corner_pts_warp,1));
    %     figure;
    %     imagesc(img_warp), axis equal tight off, colormap gray;
    %     hold on;
    %     plot(corner_pts_warp(:,1), corner_pts_warp(:,2), 'wo');
    %     hold off;

        % warp the found corners back
        corner_pts_warp(:,1) = corner_pts_warp(:,1) + xlim(1) - 1;
        corner_pts_warp(:,2) = corner_pts_warp(:,2) + ylim(1) - 1;
        backwarped_pts = round(transformPointsInverse(tform, corner_pts_warp));

        % discard points which are bigger/smaller than our reference image
        backwarped_pts = backwarped_pts(backwarped_pts(:,1) >= 1 & backwarped_pts(:,1) <= n,:);
        backwarped_pts = backwarped_pts(backwarped_pts(:,2) >= 1 & backwarped_pts(:,2) <= m,:);

        linear_indices = sub2ind(size(hits), backwarped_pts(:,2), backwarped_pts(:,1));
        % update the hit matrix
        hits(linear_indices) = hits(linear_indices) + 1;
        
        %   dbg
%         figure(ref_img_handle)
%         hold on;
%         plot(backwarped_pts(:,1), backwarped_pts(:,2), 'o', 'Color', cmap(it,:));
%         hold off;
    end
    
    % check in the end the neighbourhood of every corner point in the
    % reference image
    % hits need to be augmented
    hits_padded = padarray(hits, [floor(neighbourhood(1)/2), floor(neighbourhood(2)/2)], 0);
    robustness_of_corner_pts = zeros(size(ref_corner_pts,1),3);
    for i=1:size(robustness_of_corner_pts,1)
        % ATTENTION: neighbourhood is (y,x), corner_pts are (x,y)
        x = ref_corner_pts(i,1);
        y = ref_corner_pts(i,2);
        
        % sum up around neighbourhood
        hits_neighbourhood = hits_padded(y:y + neighbourhood(1) -1, x:x + neighbourhood(2)-1);
        nr_hits = sum(sum(hits_neighbourhood));
        robustness_of_corner_pts(i,:) = [nr_hits, x, y];
    end
    robustness_of_corner_pts = flipud(sortrows(robustness_of_corner_pts,1));
    % take the first k ones and return them
    pts = robustness_of_corner_pts(1:nr_points,2:3);
    
    % plot them
%     figure(ref_img_handle)
%     hold on;
%     plot(pts(:,1), pts(:,2), 'wx', 'MarkerSize', 20, 'LineWidth', 2);
end