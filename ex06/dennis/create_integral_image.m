function [integral_img] = create_integral_image(img)
    [m,n] = size(img);
    integral_img = zeros(m+1,n+1);
    
    for i=2:m+1
        for j=2:n+1
            integral_img(i,j) = img(i-1,j-1) + integral_img(i-1,j) + integral_img(i,j-1) - integral_img(i-1,j-1);
        end
    end
    
    % discard the artificial padding
    integral_img = integral_img(2:end,2:end);
end