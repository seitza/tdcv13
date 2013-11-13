function [points] = harris_laplace(I, n, k, s0, alpha, th, tl)
% compute sigmas for different scale levels
sigmas = zeros([1,n]);
candidate_points = zeros(0,3);
laplacians = zeros(size(I,1), size(I,2), n);

for i=1:n
    sigmas(i) = s0*k^(i-1);
    fprintf('Computing interest points for sigma %.4f', sigmas(i));
    
    % compute all the candidate points
    [row, column] = harris_corner_detector(I, i-1, s0, k, alpha, th);
    
    m = size(row,1);
    % save candidate points in matrix
    candidate_points(end+1:end+m, :) = [row, column, ones(m,1)*i];
    fprintf('\t\tdone!\n');
    
    fprintf('Computing laplacian for sigma %.4f', sigmas(i));
    
    laplace_i = abs(sigmas(i)^2*conv2(I,fspecial('log', floor(3*sigmas(i)), sigmas(i)),'same'));
    laplace_i(laplace_i < tl) = 0;
    laplacians(:,:,i) = laplace_i;
    fprintf('\t\tdone!\n');
end

% now check for ever candidate point if it forms a maximum in scale direction
fprintf('Checking every candidate point for maximum in characteristic scale...\n');
points = zeros(0,3);

for i=1:size(candidate_points,1)
    row_index = candidate_points(i,1);
    col_index = candidate_points(i,2);
    sigma_index = candidate_points(i,3);
    
    resp = laplacians(row_index, col_index, sigma_index);
    
    % check extreme cases
    if sigma_index > 1 && sigma_index < n
        % add point, if it forms a maximum in scale direction
        if resp > laplacians(row_index, col_index, sigma_index-1) && ...
                resp < laplacians(row_index, col_index, sigma_index+1)
            points(end+1,:) = [row_index, col_index, sigma_index];
        end
    elseif sigma_index == n
        if resp > laplacians(row_index, col_index, sigma_index-1)
            points(end+1,:) = [row_index, col_index, sigma_index];
        end
    elseif sigma_index == 1
        if resp < laplacians(row_index, col_index, sigma_index+1)
            points(end+1,:) = [row_index, col_index, sigma_index];
        end
    end
end



