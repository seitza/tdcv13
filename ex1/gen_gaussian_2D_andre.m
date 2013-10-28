function [ mask ] = gen_gaussian_2D_andre( sigma )
%GEN_GAUSSIAN_2D Summary of this function goes here
%   Detailed explanation goes here

mask = zeros(3*sigma);
center = (((3*sigma)-1)/2)+1;


for y = 1:3*sigma
    for x = 1:3*sigma
       cy = y-center;
       cx = x-center;
       %disp([cy cx (cy*cy)+(cx*cx) ((cy*cy)+(cx*cx))/(sigma*sigma) (-0.5*(((cy*cy)+(cx*cx))/(sigma*sigma))) exp(-0.5*(((cy*cy)+(cx*cx))/(sigma*sigma)))])
       mask(y,x) = (1/(2*pi*sigma*sigma))*exp(-0.5*(((cy*cy)+(cx*cx))/(sigma*sigma)));
    end
end

end

