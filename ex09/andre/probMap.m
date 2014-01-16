function [ probDist ] = probMap( image_hue, region, H )
%image_hue only hue of hsv
%region as (nx2) grid x,y
%H := colorHist output only frequencies

%convert pixel values to histogram frequencies
freqMap = H(round(image_hue(sub2ind(size(image_hue),region(:,2),region(:,1)))*255+0.5));

%normalize freqMap to 255
probDist = freqMap./max(max(freqMap)).*255;

end

