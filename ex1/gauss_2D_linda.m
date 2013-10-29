function [ mask ] = gauss_2D_linda( sigma )
%generates a gaussian mask
    size_columns = 3*sigma;
    size_rows = 3*sigma;
    mask = zeros(size_rows, size_columns);
    half_size_rows = floor(size_rows/ 2);
    half_size_columns = floor(size_columns/ 2);
    
    for i=1:size_rows
       i_I = i-half_size_rows-1;
       for j=1:size_columns
          j_I = j-half_size_columns-1;
          mask(i,j) = 1/(2*pi*sigma^2)*exp(-1/2*(i_I^2+j_I^2)/sigma^2);
       end
    end

end

