function H = ransac(ref_points, warped_points, s, t, T, N)
%     if s < 4
%         fprintf('to estimate a homography, we need at least 4 points.\n');
%         fprintf('Changing parameter s to 4!\n');
%         s = 4;
%     end

    % select randomly a sample from data_points
    best_consensus_set = [];
    for i=1:N
        count_points = size(ref_points,2);
        random_sample = randsample(count_points, s);
        ref_sample = ref_points(:,random_sample);
        
        % draw circles around samples
        handle_points = plot(ref_sample(1,:), ref_sample(2,:), 'mo', 'LineWidth', 3);
        % warp_sample = warped_points(:,random_sample);
        
        % estimate model
        % stuff for lines
        % calculate slope
        m = (ref_sample(2,2)-ref_sample(2,1))/(ref_sample(1,2)-ref_sample(1,1));

        % calculate c
        c = ref_sample(2,1) - ref_sample(1,1)*m;
        % calculate linefunction
        syms x
        f = m*x + c;
        H = matlabFunction(f);
        
        % apply function to all inputs
        estimated_y_values = arrayfun(H,ref_points(1,:));
        handle_line = plot(ref_points(1,:), estimated_y_values(:), 'b--');
        distances = abs(ref_points(2,:) - estimated_y_values(:)');
        
        % estimate homography
        % H = normalized_dlt(ref_sample, warp_sample);
        
        % apply homography onto ref_points and compare them with
        % warped_points
%         estimated_warped_points = H*ref_points;
%         estimated_warped_points = estimated_warped_points ./ repmat(estimated_warped_points(3,:), 3, 1);
       
        % determine consensus set
%       distances = warped_points - estimated_warped_points; 
%       distances = sqrt(distances(1,:).^2 + distances(2,:).^2 + distances(3,:).^2);
        
        consensus_set = find(distances < t);
        nr_of_inliers = length(consensus_set);
        
        if nr_of_inliers >= T
            best_consensus_set = consensus_set;
            break;
        elseif nr_of_inliers > length(best_consensus_set)
            best_consensus_set = consensus_set;
        end
        
        delete(handle_line);
        delete(handle_points);
    end
    % estimate line with best consenus set!
    % H = normalized_dlt(ref_points(:,best_consensus_set), warped_points(:,best_consensus_set));
end