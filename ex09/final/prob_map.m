function [P] = prob_map(region, H)
    hsv_img = rgb2hsv(region);
    hue_channel = hsv_img(:,:,1);
    
    indices = round(hue_channel*255) + 1;
    P = H(indices);
    
    normalization = 255 / max(max(P));
    P = round(P .* normalization);
end