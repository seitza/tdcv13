function G = median_filter(I,s)
    % I - image to be filtered
    % s - size of neighbourhood we consider
    
    % pad image accordingly
    half_kernel_size = [floor(s(1)/2), floor(s(2)/2)];
    I_padded = padarray(I,half_kernel_size);
    
    G = zeros(size(I));
    % process every point
    [m,n] = size(I);
    for i=1:m
        for j=1:n
            G(i,j) = median(reshape(I_padded(i:i+s(1)-1,j:j+s(2)-1),s(1)*s(2),1));
        end
    end
end