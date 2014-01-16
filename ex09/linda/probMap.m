function [ prob ] = probMap( region, h )
% region: region from a colored image
% h: histogram produced by colorHist.m
    
    hsv = rgb2hsv(region);
    ind = round(hsv(:,:,1).*255)+1;
    prob = h(ind);
    % normalize distribution
    maximum = max(max(prob));
    prob = round(prob .* (255/maximum));

end

