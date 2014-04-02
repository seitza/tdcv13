function [ J ] = noise( I, type, sigma )

    % Type of noise =  gaussian or salt and pepper
    
    if nargin == 3 && strcmp(type, 'gaussian')
        J = I + randn(size(I)).*sigma;
        J(J>255) = 255;
    elseif nargin == 2 && strcmp(type, 's&p')
        J = I + randi([0 255], size(I));
        J(J>255) = 255;
    end

ok

end

