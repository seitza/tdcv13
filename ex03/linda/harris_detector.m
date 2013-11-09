function [ J ] = harris_detector( I, n, s0, k, alpha, t )
% n - scale level
% s0 - initial scale value
% k - scale step
% alpha - constant factor
% t - threshold value

    sigmaI = s0*(k^n);
    sigmaD = 0.7*sigmaI;
    sigmaI_odd = floor(sigmaI);
    sigmaD_odd = floor(sigmaD);
    if mod(sigmaI_odd, 2) == 0
        sigmaI_odd = sigmaI_odd + 1;
    end  
    if mod(sigmaD_odd, 2) == 0
        sigmaD_odd = sigmaD_odd + 1;
    end
    
    Dy = [-1,-1,-1;0,0,0;1,1,1];
    Dx = Dy';

    gauss_mask_D = fspecial('gaussian', [3*sigmaD_odd, 3*sigmaD_odd], sigmaD_odd);
    gauss_mask_I = fspecial('gaussian', [3*sigmaI_odd, 3*sigmaI_odd], sigmaI_odd);
    
    I_gauss = conv2(I, gauss_mask_D, 'same');
    
    I_gd_x = conv2(I_gauss, Dx, 'same');
    I_gd_y = conv2(I_gauss, Dy, 'same');
    
    I_gd_x2 = I_gd_x.^2;
    I_gd_y2 = I_gd_y.^2;
    I_gd_xy = I_gd_x.*I_gd_y;
    
    I_gd_x2_g = sigmaD^2.*conv2(I_gd_x2, gauss_mask_I, 'same');
    I_gd_xy_g = sigmaD^2.*conv2(I_gd_xy, gauss_mask_I, 'same');
    I_gd_y2_g = sigmaD^2.*conv2(I_gd_y2, gauss_mask_I, 'same');

    R = zeros(size(I));
    
    for i = 1:size(I,1)
        for j = 1:size(I,2)
            M = [I_gd_x2_g(i,j), I_gd_xy_g(i,j); I_gd_xy_g(i,j), I_gd_y2_g(i,j)];
            R(i,j) = det(M) - alpha * (trace(M)^2);
        end
    end
    
    % thresholding
    R(R<t) = 0;
    
    % find local maximums in R and mark them in J
    %J = double(I);
    J = [];
    neighbor_size = 3;
    half_size = (neighbor_size-1)/2;
    
    for i = half_size+1:size(I,1)-half_size
        for j = half_size+1:size(I,2)-half_size
            maximum = 1;
            for m = i-half_size:i+half_size
                for n = j-half_size:j+half_size
                    if i == m && j == n
                        continue;
                    elseif R(m,n) >= R(i,j)
                        maximum = 0;
                    end
                end
            end
            if maximum == 1
                %J(i,j) = 1;
                J = [J; i, j];
            end
        end
    end

    
end

