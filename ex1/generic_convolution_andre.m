function [image_convoluted] = generic_convolution_andre( I, kernel, border_treatment )
%GENERIC_CONVOLUTION generic convolution using mxn mask and certain border
%treatment

d_I = double(I);
mask = rot90(rot90(kernel));
image_convoluted = zeros(size(I));
mask_size = size(mask);
y_mask_half = (mask_size(1)-1)/2;
x_mask_half = (mask_size(2)-1)/2;
p_I = padarray(d_I,[y_mask_half x_mask_half],'symmetric');
[y_image, x_image] = size(p_I);

disp(y_mask_half+1);
for i = y_mask_half+1:y_image-y_mask_half
    for j = x_mask_half+1:x_image-x_mask_half
        %disp([i-y_mask_half j-y_mask_half])
        image_convoluted(i-y_mask_half,j-x_mask_half) = sum(sum(p_I(i-y_mask_half:i+y_mask_half,j-x_mask_half:j+x_mask_half).*mask));
    end
end

end

