function J = conv_dennis(I,H,border_treatment)
% if we do not specify border_treatment, then use 'replicate' by default
if nargin ~= 3
    border_treatment = 0;
end
    
% first, rotate kernel and then get dimensions of kernel
H_conv = rot90(H,2);

kernel_size = size(H_conv);
sum_weights_kernel = sum(sum(H_conv));
half_kernel_size = floor(kernel_size/2);

% now pad image accordingly
I_padded = padarray(I,half_kernel_size,border_treatment);

% get size of input image
[a,b] = size(I);
% create empty output image
J = zeros([a,b]);

% now loop over every element and do the convolution
for i=1:a
    for j=1:b
        % add offset to work in padded image
        J(i,j) = sum(sum(H_conv.*I_padded(i:(i+kernel_size(1)-1), j:(j+kernel_size(2)-1))));  
    end
end
% divide through the sum of the kernel weights
J = J ./ sum_weights_kernel;
end