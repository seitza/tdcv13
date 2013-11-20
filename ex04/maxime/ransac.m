function H = ransac(point_reference, point_warped, s, n, t, T)


    % Select randomly sample 
    set = [];
    for i=1:n
        nb_points = size(point_reference,2);
        random_sample = randsample(nb_points, s);
        reference_sample = points_reference(:,random_sample);
        warped_sample = points_warped(:,random_sample);
        
        H = normalized_dlt(reference_sample, warped_sample);
        
        estimated_point_warped = H*point_reference;
        estimated_point_warped = estimated_point_warped ./ repmat(estimated_point_warped(3,:), 3, 1);
       
        distances = point_warped - estimated_point_warped;
        distances = sqrt(distances(1,:).^2 + distances(2,:).^2 + distances(3,:).^2);
        
        set = find(distances < t);
        
    H = normalized_dlt(points_reference(:,set), point_warped(:,set));
end
