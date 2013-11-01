function H = gaussian_2D_dennis(sigma) 
    len = 3*sigma; 
    half_len = floor(len/2);
    
    H = zeros([len, len]);
    c = -2*sigma^2;
    
    for i=1:len
        for j=1:len
            u = i-half_len-1;
            v = j-half_len-1;
            H(i,j) = exp((u^2 + v^2)/c);
        end
    end
    H = H/sum(sum(H));
end