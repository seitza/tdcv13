function [ image_convoluted ] = generic_convolution_andre( image, mask, border_treatment )
%GENERIC_CONVOLUTION generic convolution using mxn mask and certain border
%treatment

image = double(image);
mask = double(mask);
[y_image, x_image] = size(image);
image_convoluted = zeros(y_image, x_image);
[y_mask, x_mask] = size(mask);
y_mask_half = 0.5*(y_mask-1);
x_mask_half = 0.5*(x_mask-1);

image = horzcat(image(:,x_mask_half:-1:1),image,image(:,x_image-x_mask_half+1:1:x_image));
[y_image, x_image] = size(image);
image = vertcat(image(y_mask_half:-1:1,:),image,image(y_image-y_mask_half+1:1:y_image,:));
[y_image, x_image] = size(image);

for i = y_mask_half+1:y_image-y_mask_half
    for j = x_mask_half+1:x_image-x_mask_half
        if(i-y_mask_half >= 1 & i+y_mask_half <= y_image & j-x_mask_half >= 1 & j+x_mask_half <= x_image )
            image_convoluted(i-y_mask_half,j-x_mask_half) = sum(sum(image(i-y_mask_half:i+y_mask_half,j-x_mask_half:j+x_mask_half).*mask));
        end
    end
end
image_convoluted = uint8(image_convoluted);

end

