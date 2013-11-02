function [ J ] = median_filter_linda( I, size_x, size_y )
    
    I_padded = padarray(I, [size_y, size_x], 'replicate');
    [I_rows, I_cols] = size(I);
    
    halfsize_x = (size_x-1)/2;
    halfsize_y = (size_y-1)/2;
    
    J = zeros(size(I));
    
    for i = 1+halfsize_y:I_rows+halfsize_y
        for j = 1+halfsize_x:I_cols+halfsize_x
            values = I_padded(i-halfsize_y:i+halfsize_y, j-halfsize_x:j+halfsize_x);
            values_vector = reshape(values, 1, numel(values));
            J(i-halfsize_y,j-halfsize_x) = median(values_vector);
        end
    end

end

