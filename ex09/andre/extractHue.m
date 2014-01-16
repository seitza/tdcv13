function [ image_hue ] = extractHue( image_rgb )

image_hsv = rgb2hsv(image_rgb);
image_hue = reshape(image_hsv(:,:,1),size(image_hsv,1),size(image_hsv,2));

end

