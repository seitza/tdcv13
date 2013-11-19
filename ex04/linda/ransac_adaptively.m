function [ H ] = ransac_adaptively( ipoints_reference, ipoints_warped, s, t )

    n = size(ipoints_reference,1);
    p = 0.99;
    
    N = Inf;
    sample_count = 0;
    
    inliers = [];
    
    while N > sample_count
        sample = randsample(n,s);    % random sample that represents the rows of the points to determine the homography
        H = normalized_dlt(ipoints_reference(sample,:), ipoints_warped(sample,:));
        trans = (H*[ipoints_reference, ones(n,1)]')';
        trans = trans./ repmat( trans(:,3), 1, 3 ); % normalize by third column (should be 1)
        distance = sqrt((ipoints_warped(:,1)-trans(:,1)).^2 + (ipoints_warped(:,2)-trans(:,2)).^2 + (1-trans(:,3)).^2);
        inliers = find(distance < t);
        epsilon = 1-numel(inliers)/n;
        N = log(1-p)/log(1-(1-epsilon)^s);
        sample_count = sample_count+1;
    end
    
    H = normalized_dlt(ipoints_reference(inliers,:), ipoints_warped(inliers,:));

end

