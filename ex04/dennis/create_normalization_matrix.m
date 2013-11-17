function T = create_normalization_matrix(points)
% calculate a transformation matrix, which 
% (1) translates the points so that the centroid (mean) is at (0,0)
% (2) scale them accordingly, so that the average distance is sqrt(2)

% (1)
translation = mean(points,2);
translated_points = points;
translated_points(1,:) = points(1,:) - translation(1);
translated_points(2,:) = points(2,:) - translation(2);

% (2)
n_points = size(points,2);
distances = zeros(1,n_points);
for i=1:n_points
    distances(i) = sqrt(translated_points(1,i)^2 + translated_points(2,i)^2);
end
scaling = sqrt(2)/mean(distances);

T = [scaling, 0, scaling*-translation(1);
     0, scaling, scaling*-translation(2);
     0, 0, 1];
end

