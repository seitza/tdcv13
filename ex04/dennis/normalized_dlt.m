function [H] = normalized_dlt(ref_points, warped_points)
% create transformation matrices
U = create_normalization_matrix(ref_points);
x_twiddle = U*ref_points;
T = create_normalization_matrix(warped_points);
x_prime_twiddle = T*warped_points;

n = size(x_prime_twiddle,2);
A_twiddle = zeros(0, 9);
% create the matrix A_i for every entry in x_prime_twiddle
for i=1:n
    A_twiddle_i = [0, 0, 0, -x_prime_twiddle(3,i)*x_twiddle(:,i)', x_prime_twiddle(2,i)*x_twiddle(:,i)';
                   x_prime_twiddle(3,i)*x_twiddle(:,i)', 0, 0, 0, -x_prime_twiddle(1,i)*x_twiddle(:,i)'];
    A_twiddle = vertcat(A_twiddle, A_twiddle_i);
end

% obtain SVD decomposition
[~,~,V] = svd(A_twiddle);
V_trans = V';
% h is the last column of V'
h_twiddle = V_trans(:,end);
% make the matrix H of it
H_twiddle = reshape(h_twiddle, 3, 3);
H = H_twiddle\T*U;
end