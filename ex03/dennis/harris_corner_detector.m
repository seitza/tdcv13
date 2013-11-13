function [row, column] = harris_corner_detector(I, n, s0, k, alpha, t)
% calculate sigmas
sigma_In = s0 * k^n;
sigma_Dn = 0.7*sigma_In;

% compute gaussians
size_derivative_kernel = floor(3*sigma_Dn);
if mod(size_derivative_kernel,2) == 1
    size_derivative_kernel = size_derivative_kernel + 1;
end

size_integration_kernel = floor(3*sigma_In);
if mod(size_integration_kernel,2) == 1
    size_integration_kernel = size_integration_kernel + 1;
end
    
Gaussian_derivative = fspecial('gaussian', [size_derivative_kernel, size_derivative_kernel], sigma_Dn);
Gaussian_integration = fspecial('gaussian', [size_integration_kernel, size_integration_kernel], sigma_In);

% get derivative masks
Dy = -fspecial('prewitt');
Dx = Dy';

%% compute the multiscale harris-corner response
G = conv2(I,Gaussian_derivative,'same');
Gx = conv2(G, Dx, 'same');
Gy = conv2(G, Dy, 'same');

% compute derivative matrices, smooth them and apply scale normalization
Ixx = conv2(Gx .^ 2, Gaussian_integration, 'same') * sigma_Dn^2;
Ixy = conv2(Gx .* Gy, Gaussian_integration, 'same') * sigma_Dn^2;
Iyy = conv2(Gy .^ 2, Gaussian_integration, 'same') * sigma_Dn^2;

% corner response matrix
R = zeros(size(I));
% for every point, compute the corner response R
for i=1:size(I,1)
    for j=1:size(I,2)
        M = [Ixx(i,j), Ixy(i,j); Ixy(i,j), Iyy(i,j)];
        R(i,j) = det(M) - alpha*trace(M)^2;
    end
end

% threshold R
% t = 0.01*max(max(R));
R(R < t) = 0;
% compute non-maximum suppression
R = non_max_supp(R, [3,3]);
[row, column] = find(R);
end