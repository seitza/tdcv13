function H = ransac(ref_points, warped_points, s, t, T, N)
    if s < 4
        fprintf('to estimate a homography, we need at least 4 points.\n');
        fprintf('Changing parameter s to 4!\n');
        s = 4;
    end

    % select randomly a sample from data_points
    best_consensus_set = [];
    for i=1:N
        count_points = size(ref_points,2);
        random_sample = randsample(count_points, s);
        ref_sample = ref_points(:,random_sample);
        warp_sample = warped_points(:,random_sample);
        
        % estimate homography
        H = normalized_dlt(ref_sample, warp_sample);
        
        % apply homography onto ref_points and compare them with
        % warped_points
        estimated_warped_points = H*ref_points;
        estimated_warped_points = estimated_warped_points ./ repmat(estimated_warped_points(3,:), 3, 1);
       
        % determine consensus set
        distances = warped_points - estimated_warped_points; 
        distances = sqrt(distances(1,:).^2 + distances(2,:).^2 + distances(3,:).^2);
        
        consensus_set = find(distances < t);
        nr_of_inliers = length(consensus_set);
        
        if nr_of_inliers >= T
            best_consensus_set = consensus_set;
            break;
        elseif nr_of_inliers > length(best_consensus_set)
            best_consensus_set = consensus_set;
        end
    end
    % estimate line with best consenus set!
    H = normalized_dlt(ref_points(:,best_consensus_set), warped_points(:,best_consensus_set));
end