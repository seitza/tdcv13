function [Gy, Gx] = gaussian_1D_dennis(sigma)
    len = 3*sigma;
    half_len = floor(len/2);
    
    Gx = zeros([1 len]);
    c = -2*sigma^2;
    
    for i=1:len
        u = i-half_len-1;
        Gx(i) = exp(u^2/c);
    end 
    Gx = Gx/sum(Gx);
    Gy = Gx';
end