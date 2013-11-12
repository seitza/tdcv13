function [ J ] = Harris_detector( I, n, s0, k , alpha, t )

    % Values
    sigma_In = floor(s0*k^n);
    if mod(sigma_In, 2) == 0
        sigma_In = sigma_In + 1;
    end
    sigma_Dn = floor(.7*sigma_In);
    if mod(sigma_Dn, 2) == 0
        sigma_Dn = sigma_Dn + 1;
    end
    
    I = imread(I);
    I = double(I);
    J = zeros(size(I));
    
    % Step 1 : Compute Gaussian derivates at each pixel
        % Gaussian
        gaussian_i = fspecial('gaussian', [3*sigma_In, 3*sigma_In], sigma_In);
        gaussian_d = fspecial('gaussian', [3*sigma_Dn, 3*sigma_Dn], sigma_Dn);
        
        % Derivate masks
        Dy = fspecial('prewitt');
        Dx = Dy';
        
        % Gaussian derivate masks
        Gy = conv2(Dy, gaussian_d, 'same');
        Gx = conv2(Dx, gaussian_d, 'same');
        
        % Compute with image
        Iy = conv2(I, Gy, 'same');
        Ix = conv2(I, Gx, 'same');
        
    % Step 2 : Compute second moment matrix using differentiation scale and
    % smooth it with gaussian using integration scale
    M_Iy = sigma_Dn^2.*conv2(Iy.^2, gaussian_i, 'same');
    M_Iyx = sigma_Dn^2.*conv2(Iy.*Ix, gaussian_i, 'same');
    M_Ix = sigma_Dn^2.*conv2(Ix.^2, gaussian_i, 'same');
    
    % Step 3 : Compute corner response function R
    R = zeros(size(I));
    for i=1:size(I,1)
        for j=1:size(I,2)
            M = [M_Ix(i,j), M_Iyx(i,j); M_Iyx(i,j), M_Iy(i,j)];           
            R(i,j) = abs(det(M) - alpha*trace(M)^2);           
        end
    end
    
    % Step 4 : Treshold R
    R(R < t) = 0;
    
    % Step 5 : Find local maxima of response function
    % find local maximums in R and mark them in J
    neighbor = [3 3];
    half_neighbor = [floor(neighbor(1)/2), floor(neighbor(2)/2)];
    J = [];
    for i = 1:size(I,1)
        for j = 1:size(I,2)
            maximum = 1;
            for m = 1:half_neighbor
                for n = 1:half_neighbor
                    if i == m && j == n
                        continue;
                    elseif R(m,n) >= R(i,j)
                        maximum = 0; 
                    end
                end
            end
            if maximum == 1
                J = [J, i, j];
            end
        end
    end    
    

% for i = half_neighbor+1:size(I,1)-half_neighbor
%     for j = half_neighbor+1:size(I,2)-half_neighbor
%         maximum = 1;
%         for m = i-half_neighbor:i+half_neighbor
%             for n = j-half_neighbor:j+half_neighbor
%                 if i == m && j == n
%                     continue;
%                 elseif R(m,n) >= R(i,j)
%                     maximum = 0;
%                 end
%             end
%         end
%         if maximum == 1
%             J = [J; i, j];
%             
%         end
%     end
% end

    
    
    
end

