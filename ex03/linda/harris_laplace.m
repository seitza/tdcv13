function [ harris_laplace ] = harris_laplace( I, res_level, s0, k, alpha, th, tl )
% res_level - resolution level
% s0 - initial scale
% k - factor between two levels of resolution
% alpha
% th - threshold for harris detector
% tl - threshold for laplace detector

    Dy = [-1,-1,-1;0,0,0;1,1,1];
    Dx = Dy';

    harris = cell(1, res_level);
    laplace = zeros(size(I, 1), size(I,2), res_level+2);
    laplace(:,:,1) = zeros(size(I));                    % zeros for the smallest and highest scale level
    laplace(:,:,res_level+2) = zeros(size(I));
    % conduct harris detector for the resolution levels and store the
    % results in harris
    for n = 1:res_level
        harris{1,n} = harris_detector(I, n, s0, k, alpha, th);
        
        %compute laplacian
        sigmaI = s0*(k^n);
        sigmaI_odd = floor(sigmaI);
        if mod(sigmaI_odd, 2) == 0
            sigmaI_odd = sigmaI_odd + 1;
        end
        
        gauss_mask_I = fspecial('gaussian', [3*sigmaI_odd, 3*sigmaI_odd], sigmaI_odd);
        I_gauss = conv2(I, gauss_mask_I, 'same');
        
        I_g_xx = conv2(conv2(I_gauss, Dx, 'same'), Dx, 'same');
        I_g_yy = conv2(conv2(I_gauss, Dy, 'same'), Dy, 'same');
        
        for i = 1:size(I,1)
            for j = 1:size(I,2)
                laplace(i,j,n+1) = abs(sigmaI^2*(I_g_xx(i,j)+I_g_yy(i,j)));
            end
        end
        
    end
    
    %threshold laplace
    laplace(laplace < tl) = 0;
    
    % check if local maxima found by harris detector are stable in laplace
    harris_laplace = cell(1,res_level);     % stores the remaining coordinates for each scale level
    
    for n = 2:res_level+1
        h = harris{1, n-1};
        J = [];                 % to store the remaining coordinates
        for i = 1:size(h, 1)
            row = h(i,1);
            col = h(i,2);
            if laplace(row, col, n) > laplace(row, col, n-1) && laplace(row, col, n) > laplace(row, col, n+1)
                J = [J; row, col];
            end
        end
        harris_laplace{1,n-1} = J;
    end

end

