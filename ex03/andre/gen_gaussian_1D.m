function [ mask_y mask_x ] = gen_gaussian_1D( sigma )
%GEN_GAUSSIAN_1D Summary of this function goes here
%   Detailed explanation goes here

    s=floor(sigma);
    
    if(mod(s,2) ~= 1)
       s=s+1; 
    end

    mask_y = zeros(3*s,1);
    mask_x = zeros(1,3*s);
    
    center = floor(s/2)+1;
    
    for i = 1:3*sigma
        mask_y(i,1) = exp(-0.5*(((i-center)^2)/(sigma*sigma))); 
        mask_x(1,i) = mask_y(i,1);
    end
    mask_y = mask_y/sum(mask_y);
    mask_x = mask_x/sum(mask_x);

end

