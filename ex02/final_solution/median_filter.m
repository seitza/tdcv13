function [ J ] = median_filter( I , size_param )

    % Values
    I_padded = padarray(I, floor(size_param/2), 'symmetric'); 
    
    s = size(I);
    J = zeros(s);
    
    % Median process   
    for i = 1:s(1)
        for j = 1:s(2)
            J(i,j) = median(reshape(I_padded(i:i+size_param(1)-1,j:j+size_param(2)-1), size_param(1)*size_param(2), 1));
        end
    end

end

