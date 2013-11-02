function [ J ] = bilateral_filter_linda( I, sigma )

    [I_rows, I_cols] = size(I);
    size_mask = 3*sigma;
    halfsize_mask = (size_mask-1)/2;
    I_padded = padarray(I, [halfsize_mask, halfsize_mask], 'replicate');

    J = zeros(size(I));
    
    for i = 1+halfsize_mask:I_rows+halfsize_mask
        for j = 1+halfsize_mask:I_cols+halfsize_mask
            a = 0;
            b = 0;
            for m = -halfsize_mask:halfsize_mask
                for n = -halfsize_mask:halfsize_mask
                    c = closeness([i,j],[i+m,j+n], sigma);
                    s = similarity(I_padded(i,j), I_padded(i+m, j+n), sigma);
                    a = a + c * s;
                    b = b + I_padded(i+m, j+n) * c * s;
                end
            end
            disp(a);
            J(i-halfsize_mask,j-halfsize_mask) = b / a;
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
function [s] = similarity(I_x, I_n, sigma)
    s = exp(-1/2*(abs(I_n-I_x/sigma))^2);
end

