function [ I_warped ] = warping( I, H )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
    
    new
    
    for i = 1:size(I,1)
        for j = 1:size(I,2)
            t = I()
                        t = H*[j; i; 1];
            t = t ./ t(3);
        end
    end


end