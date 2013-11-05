function [ J ] = bilateral_filter( I, sigma )

    [I_rows, I_cols] = size(I);
    size_mask = 3*sigma;
    halfsize_mask = (size_mask-1)/2;
    I_padded = padarray(I, [halfsize_mask, halfsize_mask]);
    %I_padded = padarray(I, [halfsize_mask, halfsize_mask], 'replicate');

    J = zeros(size(I));
    
    for i = 1+halfsize_mask:I_rows+halfsize_mask
        for j = 1+halfsize_mask:I_cols+halfsize_mask
            a = 0;
            b = 0;
            for m = -halfsize_mask:halfsize_mask
                for n = -halfsize_mask:halfsize_mask
                    % domain filter
                    distance = sqrt((m)^2 + (n)^2);
                    closeness = exp(-1/2*(distance/sigma)^2);
                    % range filter
                    similarity = exp(-1/2*(abs(I_padded(i+m, j+n)-I_padded(i,j))/sigma)^2);
                    
                    a = a + closeness * similarity;
                    b = b + I_padded(i+m, j+n) * closeness * similarity;

                end
            end
            J(i-halfsize_mask,j-halfsize_mask) = b / a;
        end
    end
    
end

