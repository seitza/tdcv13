function [ J ] = harris_laplace( I, res_level, s0, k, alpha, th, tl )
% res_level - resolution level
% s0 - initial scale
% k - factor between two levels of resolution
% alpha
% th - threshold for harris detector
% tl - threshold for laplace detector

    Dy = [-1,-1,-1;0,0,0;1,1,1];
    Dx = Dy';

    harris = cell(1, res_level);
    laplace = zeros(size(I, 1), size(I,2), res_level);
    % conduct harris detector for the resolution levels and store the
    % results in harris
    for n = 1:res_level
        harris{1,n} = harris_detector(I, n, s0, k, alpha, th);
        
        %compute laplacian
        sigmaI = s0*(k^n);
        sigmaI_odd = floor(sigmaD);
        if mod(sigmaI_odd, 2) == 0
            sigmaI_odd = sigmaI_odd + 1;
        end
        
        gauss_mask_I = fspecial('gaussian', [3*sigmaI_odd, 3*sigmaI_odd], sigmaI_odd);
        I_gauss = conv2(I, gauss_mask_I, 'same');
        
        I_g_xx = conv2(conv2(I_gauss, Dx, 'same'), Dx, 'same');
        I_g_yy = conv2(conv2(I_gauss, Dy, 'same'), Dy, 'same');
         
        for i = 1:size(I,1)
            for j = 1:size(I,2)
                laplace(i,j,n) = abs(sigmaI^2*(I_g_xx(i,j)+I_g_yy(i,j)));
            end
        end
        
    end
    
    %threshold laplace
    laplace(laplace < tl) = 0;
    
    % check if local maxima found by harris detector are stable in laplace
    neighbor_size = 3;
    half_size = (neighbor_size-1)/2;
    
    for n = 2:res_level-1
        h = harris{1, n};
        for i = 1:size(h, 1)
            row = h(i,1);
            col = h(i,2);
            current_value = laplace(row, col, n);
            maximum = 1;
            for y = -half_size:half_size
                for x = -half_size:half_size
                    if laplace(row+y, col+x, n-1) >= current_value | laplace(row+y, col+x, n+1) >= current_value
                        maximum = 0;
                    end
                end
            end
            if maximum == 1
                
            end
        end
    end


end

