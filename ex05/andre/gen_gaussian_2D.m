function [ res ] = gen_gaussian_2D( sigma )
%GEN_GAUSSIAN_2D Summary of this function goes here
%   Detailed explanation goes here

    s=floor(sigma);
    
    if(mod(s,2) ~= 1)
       s=s+1; 
    end

mask = zeros(3*s);
center = floor(size(mask,1)/2)+1;



nom = -2*(s^2);
for y = 1:3*s
    for x = 1:3*s
       cy = y-center;
       cx = x-center;       
       mask(y,x) = exp((cy^2+cx^2)/nom);
    end
    res = mask/sum(sum(mask));
end

end

