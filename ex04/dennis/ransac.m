function H = ransac(ref_points, warped_points, s, t, T, N)
    if s < 4
        fprintf('to estimate a homography, we need at least 4 points.\n');
        fprintf('Changing parameter s to 4!\n');
        s = 4;
    end
    
    % select randomly a sample from data_points
    best_consensus_set = [];
    for i=1:N
        random_sample = randsample(size(ref_points,2), s);
        ref_sample = ref_points(:,random_sample);
        warp_sample = warped_points(:,random_sample);
        
        % estimate homography
        H = normalized_dlt(ref_sample, warp_sample);
        
        % apply homography onto ref_points and compare them with
        % warped_points
        estimated_warped_points = H*ref_points;
       
        % determine consensus set
        distances = estimated_warped_points - warped_points;
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
    H = normalized_dlt(ref_points(:,best_consensus_set), warped_points(:,best_consensus_set));
end