function [ J ] = harris_detector( I, sigmaD, sigmaI, n, s0, k, alpha, t )
% n - scale level
% s0 - initial scale value
% k - scale step
% alpha - constant factor
% t - threshold value

    Dy = [-1,-1,-1;0,0,0;1,1,1];
    Dx = Dy';

    gauss_mask_D = fspecial('gaussian', [3*sigmaD, 3*sigmaD], sigmaD);
    gauss_mask_I = fspecial('gaussian', [3*sigmaI, 3*sigmaI], sigmaI);
    
    I_gauss = conv2(I, gauss_mask_D, 'same');
    
    I_gd_x = conv2(I_gauss, Dx, 'same');
    I_gd_y = conv2(I_gauss, Dy, 'same');
    
    I_gd_x2 = I_gd_x^2;
    I_gd_y2 = I_gd_y^2;
    I_gd_xy = I_gd_x*I_gd_y;
    
    R = zeros(size(I));
    
    for i = 1:size(I,1)
        for j = 1:size(I,2)
            matrix = [I_gd_x2(i,j), I_gd_xy(i,j); I_gd_xy(i,j), I_gd_y2(i,j)];
            M = conv2(matrix, (sigmaD^2)*gauss_mask_I, 'same');
            R(i,j) = det(M) - alpha * (trace(M)^2);
        end
    end

    
    
    
end

