function J = bilateral_filter(I, sigma_domain, sigma_range)
    J = zeros(size(I));
    
    % size of mask
    m = 3*sigma_domain;
    n = 3*sigma_domain;

    half_kernel_size = [floor(m/2); floor(n/2);];
    I_padded = padarray(I,half_kernel_size);
    
    % indexing starts at 1 in matlab!
    center_element = half_kernel_size + 1;
    
    for i=1:size(I,1)
        for j=1:size(I,2)
            % consider neighbourhood
            normalization = 0;
            for p=1:m
                for q=1:n
                    % domain filter
                    dist = norm(center_element - [p;q], 1);
                    closeness = exp(-0.5*(dist/sigma_domain)^2);
                    
                    % range filter
                    range = norm(I_padded(i+p-1,j+q-1) - I(i,j),1);
                    similarity = exp(-0.5*(range/sigma_range)^2);
                    
                    J(i,j) = I_padded(i+p-1,j+q-1)*closeness*similarity + J(i,j);
                    normalization = closeness*similarity + normalization;
                end
            end
            % do not forget to normalize
            J(i,j) = J(i,j) / normalization;
        end
    end
end