function [J] = convolution(I,H,border_treatment)
    % if we do not specify border_treatment, then use 'replicate' by default
    if nargin ~= 3
        % nothing specified fill with zeros - same behavior as conv2
        border_treatment = 0;
    else
        switch border_treatment
            case 'mirror'
                border_treatment = 'symmetric';
            case 'border'
                border_treatment = 'replicate';
            otherwise
                fprintf('Do not know border treatment %s - assuming "border"\n', border_treatment);
                border_treatment = 'replicate';
        end
    end
    
    % first, rotate kernel and then get dimensions of kernel
    H_conv = rot90(H,2);
    kernel_size = size(H_conv);
    half_kernel_size = (kernel_size-1)/2;

    % now pad image accordingly
    I_padded = padarray(I,half_kernel_size,border_treatment,'both');

    % get size of input image
    [a,b] = size(I);
    % create empty output image
    J = zeros([a,b]);

    % now loop over every element and do the convolution
    for i=1:a
        for j=1:b
            % add offset to work in padded image
            summed_value = 0;
            for r=1:kernel_size(1)
                for s=1:kernel_size(2)
                    summed_value = summed_value + I_padded(r+i-1,s+j-1) * H_conv(r,s);
                end
            end
            J(i,j) = summed_value;
        end
    end
end
