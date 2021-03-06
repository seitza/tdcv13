function [ H ] = ransac( ipoints_reference, ipoints_warped, s, N, t, T )
% interest points for both images, either arranged in a (n x 2) array.
% Corresponding interest points are in the same row.

    n = size(ipoints_reference,1);
    ipoints_reference_with1 = [ipoints_reference, ones(n,1)];
    largest_inliers = [];    % stores the properties of the largest Si
    
    for i = 1:N
        sample = randsample(n,s);    % random sample that represents the rows of the points to determine the homography
        H = normalized_dlt(ipoints_reference(sample,:), ipoints_warped(sample,:));
        trans = (H*ipoints_reference_with1')';
        trans = trans./ repmat( trans(:,3), 1, 3 ); % normalize by third column (should be 1)
        
        distance = sqrt((ipoints_warped(:,1)-trans(:,1)).^2 + (ipoints_warped(:,2)-trans(:,2)).^2 + (1-trans(:,3)).^2);
        inliers = find(distance < t);
        if numel(inliers) > T
            largest_inliers = inliers;
            break;
        elseif numel(inliers) > numel(largest_inliers)
            largest_inliers = inliers;
        end
    end
    
    H = normalized_dlt(ipoints_reference(largest_inliers,:), ipoints_warped(largest_inliers,:));
    
end

