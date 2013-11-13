function [ mask_y mask_x ] = gen_gaussian_1D( sigma )

    %disp('sigma in gauss');
    %disp(sigma);

    
    sf=floor(sigma);
    
    if(mod(sf,2) ~= 1)
       s=sf+1;
    else
        s=sf;
    end

    mask_y = zeros(3*s,1);
    mask_x = zeros(1,3*s);
    
    center = floor((3*s)/2)+1;
    
    for i = 1:3*s
        mask_y(i,1) = exp(-0.5*(((i-center)^2)/(sigma*sigma))); 
        mask_x(1,i) = mask_y(i,1);
    end
    mask_y = mask_y/sum(mask_y);
    mask_x = mask_x/sum(mask_x);

end

