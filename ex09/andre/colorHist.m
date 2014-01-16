function [ H ] = colorHist( image_hue, region, plot )
%image only hue of hsv
%region as (nx2) grid definition x,y;
%plot := false, true if it should be plotted or not

image_region = image_hue(sub2ind(size(image_hue),region(:,2),region(:,1)));
image_points = image_region(:);

H = hist(image_points,255);

if(plot)
    figure;
    bar(H);
end

end

