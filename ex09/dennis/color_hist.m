function [H] = color_hist(region, plot)
    if nargin == 2 && plot == 1
        plot_histogram = 1;
    else
        plot_histogram = 0;
    end
    
    hsv_img = rgb2hsv(region);
    hue_channel = hsv_img(:,:,1);
    [H, centers] = hist(hue_channel(:),256);
    
    if plot_histogram
        figure('Name', 'Plotting color histogram', 'NumberTitle', 'Off');
        bar(centers, H)
    end
end