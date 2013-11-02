function [ J ] = bilateral_filter_linda( I, sigma )

    [I_rows, I_cols] = size(I);
    size_mask = 3*sigma;
    halfsize_mask = (size_mask-1)/2;
    
    I_padded = padarray(I, [halfsize_mask, halfsize_mask], 'replicate');

    J = zeros(size(I));
    
    for i = 1:I_rows
        for j = 1:I_cols
            for m = -halfsize_mask:halfsize_mask
                for n = -halfsize_mask:halfsize_mask
                    J(i,j) = 
                end
            end
        end
    end
    
end

% functions for domain filter
function [d] = distance(x, n)
    d = sqrt(x(1)*n(1) + x(2)*n(2));
end

function [c] = closeness(x, n, sigma)
    c = exp(-1/2*(distance(x,n)/sigma)^2);
end

% functions for range filter
function [s] = similarity(I, x, n, sigma)
    s = exp(-1/2*(abs(I(n)-I(x)/sigma))^2);
end

