function [ res ] = gen_gaussian_2D( sigma )
%GEN_GAUSSIAN_2D Summary of this function goes here
%   Detailed explanation goes here

mask = zeros(3*sigma);
center = (((3*sigma)-1)/2)+1;

nom = -2*(sigma^2);
for y = 1:3*sigma
    for x = 1:3*sigma
       cy = y-center;
       cx = x-center;       
       mask(y,x) = exp((cy^2+cx^2)/nom);
    end
    res = mask/sum(sum(mask));
end

end

