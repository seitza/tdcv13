function [ mask_horizontal, mask_vertical ] = gauss_1D_linda( sigma )

    len = 3*sigma;
    half_len = floor(len/2);

    mask_horizontal = zeros(1, len);
    mask_vertical = zeros(len, 1);
    
    for i=1:len
        u = i-half_len-1;
        g = 1/(sqrt(2*pi*sigma^2))*exp(-1/2*(u^2)/(sigma^2));
        mask_horizontal(1,i) = g;
        mask_vertical(i,1) = g;
    end
    
end

