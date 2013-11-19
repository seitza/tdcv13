function [ H ] = normalized_dlt( point_reference, point_warped )

    % Centered
    center_reference = mean(point_reference,2);
    center_warped = mean(point_warped,2);
    % Translation
    n = size(point_reference);
    point_centered_reference = zeros(n);
    point_centered_reference(1,:) = point_reference(1,:) - center_reference(1);
    point_centered_reference(2,:) = point_reference(2,:) - center_reference(2);
    point_centered_warped = zeros(n);
    point_centered_warped(1,:) = point_warped(1,:) - center_warped(1);
    point_centered_warped(2,:) = point_warped(2,:) - center_warped(2);
    % Scaling
    distance_reference = mean(sqrt(point_centered_reference(1,:).^2 + point_centered_reference(2,:).^2) + point_centered_reference(3,:).^2);
    scaling_reference = sqrt(2)/distance_reference;
    point_scaled_reference = scaling_reference*point_centered_reference;
    U = [scaling_reference,0,-scaling_reference*center_reference(1);0,scaling_reference,-scaling_reference*center_reference(2);0,0,1];
    
    distance_warped = mean(sqrt(point_centered_warped(1,:).^2 + point_centered_warped(2,:).^2)+ point_centered_warped(3,:).^2);
    scaling_warped = sqrt(2)/distance_warped;
    point_scaled_warped = scaling_warped*point_centered_warped;
    T = [scaling_warped,0,-scaling_warped*center_warped(1);0,scaling_warped,-scaling_warped*center_warped(2);0,0,1];
    
    % Matrix A
   
    A_tilde = zeros(0, 9);
    
    for i=1:n(2)
        A_tilde_i = [0 0 0 -point_scaled_warped(3,i)*point_scaled_reference(:,i)' point_scaled_warped(2,i)*point_scaled_reference(:,i)';
                       point_scaled_warped(3,i)*point_scaled_reference(:,i)' 0 0 0 -point_scaled_warped(1,i)*point_scaled_reference(:,i)'];
      
        A_tilde = vertcat(A_tilde, A_tilde_i);
    end

    % SVD decomposition
    [Q,D,V] = svd(A_tilde);
    H_tilde = reshape(V(:,end), 3, 3)';
    H = inv(T) * H_tilde * U;
    
end

