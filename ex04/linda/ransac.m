function [ H ] = ransac( ipoints_reference, ipoints_warped, N, t, T )
% interest points for both images, either arranged in a (n x 2) array.
% Corresponding interest points are in the same row.

    n = size(ipoints_reference,1);
    ipoints_reference_with1 = [ipoints_reference, ones(n,1)];
    largest_inliers = [];    % stores the properties of the largest Si
    
    for i = 1:N
        s = randsample(n,4);    % random sample that represents the rows of the points to determine the homography
        H = normalized_dlt(ipoints_reference(s,:), ipoints_warped(s,:));
        trans = (H*ipoints_reference_with1')';
        distance = sqrt((ipoints_reference(:,1)-trans(:,1))^2 + (ipoints_reference(:,2)-trans(:,2))^2 + (1-trans(:,3))^2);
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

