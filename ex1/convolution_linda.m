function [ J ] = convolution_linda( I, kernel, border )
% I --> image that should be changed
% kernel --> matrix for convolution
% border --> treatment of the border: either mirroring ('mirror') or same as
% corresponding border pixels ('border')

    %transpose kernel
    kernel = rot90(kernel,2);
    
    size_kernel = size(kernel);
    halfsize_kernel = (size_kernel-1)/2;
    
    J = zeros(size(I));
    
    switch border
        case 'mirror'
            border = 'symmetric';
        otherwise
            border = 'replicate';
    end    
    
    % padding I
    I_padded = padarray(I, [halfsize_kernel(1), halfsize_kernel(2)], border);
    
    [I_rows, I_columns] = size(I);
    
    for i=1:I_rows
        for j = 1:I_columns
            for m = 1:size_kernel(1)
                for n = 1: size_kernel(2)
                    J(i,j) = J(i,j) + I_padded(i+m-1, j+n-1) * kernel(m,n);
                end
            end
        end
    end



