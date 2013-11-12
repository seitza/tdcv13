function [ harris_laplace ] = harris_laplace( I, res_level, s0, k, alpha, th, tl )
% res_level - resolution level
% s0 - initial scale
% k - factor between two levels of resolution
% alpha
% th - threshold for harris detector
% tl - threshold for laplace detector

    Dy = [-1,-1,-1;0,0,0;1,1,1];
    Dx = Dy';
    
%     diff_x = [[-1,-1,-1];[0,0,0];[1,1,1]];
%     diff_y = [[-1;-1;-1],[0;0;0],[1;1;1]];

    harris = cell(1, res_level+1);
    laplace = zeros(size(I, 1), size(I,2), res_level+3);
    laplace(:,:,1) = zeros(size(I));                    % zeros for the smallest and highest scale level
    laplace(:,:,res_level+3) = zeros(size(I));
    scales = zeros(1, res_level+1);
    % conduct harris detector for the resolution levels and store the
    % results in harris
    for n = 1:res_level+1
        harris{1,n} = harris_detector(I, n-1, s0, k, alpha, th);
        
        %compute laplacian
        sigmaI = s0*(k^(n-1));
        scales(1, n) = k^(n-1);
        sigmaI_odd = floor(sigmaI);
        if mod(sigmaI_odd, 2) == 0
            sigmaI_odd = sigmaI_odd + 1;
        end

        gauss_y_I = fspecial('gaussian', [3*sigmaI_odd, 1] ,sigmaI);
        gauss_x_I = fspecial('gaussian', [1, 3*sigmaI_odd] ,sigmaI);

        %get second order derivatives in x and y direction for all scales
        G = conv2(conv2(I,gauss_x_I,'same'),gauss_y_I,'same');
        laplace(:,:,n+1) = (sigmaI^2)*(abs(conv2(conv2(G,Dy,'same'),Dy,'same')+conv2(conv2(G,Dx,'same'),Dx,'same')));        
        
    end
    
    %threshold laplace
    laplace(laplace < tl) = 0;
    
    % check if local maxima found by harris detector are stable in laplace
    harris_laplace = [];     % stores the remaining coordinates for each scale level
    
    for n = 2:res_level+2
        h = harris{1, n-1};
        for i = 1:size(h, 1)
            row = h(i,1);
            col = h(i,2);
            if laplace(row, col, n) > laplace(row, col, n-1) && laplace(row, col, n) > laplace(row, col, n+1)
                harris_laplace = [harris_laplace; row, col, scales(1,n-1)];
            end
        end
    end

end

