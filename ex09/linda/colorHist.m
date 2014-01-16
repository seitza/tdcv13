function [ h ] = colorHist( region )
% region: region from a colored image

    hsv = rgb2hsv(region);
    hue = hsv(:,:,1);
    
    h = hist(hue(:), 256);
    hist(hue(:), 256);

end

