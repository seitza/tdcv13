function [ integral_image ] = createIntegralImage( I )
% creates the integral image from a grayscale image I
    
    [rows, cols] = size(I);

    integral_image = zeros(rows+1, cols+1);
    
    for i = 2:rows+1
        for j = 2:cols+1
            integral_image(i,j) = I(i-1,j-1) + integral_image(i,j-1) + integral_image(i-1, j) - integral_image(i-1,j-1);
        end
    end

    integral_image = integral_image(2:rows+1, 2:cols+1);
    
end

