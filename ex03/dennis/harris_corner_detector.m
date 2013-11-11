function [row, column] = harris_corner_detector(I, n, s0, k, alpha, t)
% calculate sigmas
sigma_In = s0 * k^n;
sigma_Dn = 0.7*sigma_In;

% compute gaussians
Gaussian_derivative = fspecial('gaussian', [round(3*sigma_Dn), round(3*sigma_Dn)], sigma_Dn);
Gaussian_integration = fspecial('gaussian', [round(3*sigma_In), round(3*sigma_In)], sigma_In);

% get derivative masks
Dy = -fspecial('prewitt');
Dx = Dy';

% smooth the masks
Gy = conv2(Dy, Gaussian_derivative, 'same');
Gx = conv2(Dx, Gaussian_derivative, 'same');

%% compute the multiscale harris-corner response
Ix = conv2(I,Gx,'same');
Iy = conv2(I,Gy,'same');

% compute derivative matrices, smooth them and apply scale normalization
Ixx = conv2(Ix .^ 2, Gaussian_integration, 'same') * sigma_Dn^2;
Ixy = conv2(Ix .* Iy, Gaussian_integration, 'same') * sigma_Dn^2;
Iyy = conv2(Iy .^ 2, Gaussian_integration, 'same') * sigma_Dn^2;

% corner response matrix
R = zeros(size(I));
% for every point, compute the corner response R
for i=1:size(I,1)
    for j=1:size(I,2)
        M = [Ixx(i,j), Ixy(i,j); Ixy(i,j), Iyy(i,j)];
        R(i,j) = abs(det(M) - alpha*trace(M)^2);
    end
end

% threshold R
t = 0.01*max(max(R));
R(R < t) = 0;
% compute non-maximum suppression
R = non_max_supp(R, [3 3]);
[row, column] = find(R);
end