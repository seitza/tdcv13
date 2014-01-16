clc;
clear;
close all;

%% a)
% region defining the red car
rect = [507,310, 555,344];       % {(xmin, ymin), (xmax, ymax)}
% first image
I1 = imread(num2str(140,'sequence/2043_000%03d.jpeg'));
% region in the first image defined by rect
region = I1(rect(2):rect(4), rect(1):rect(3),:);
% compute color histogram of the region
h = colorHist(region);

%% b)
% initialize the center of the rectangular region
xhalf = (rect(3)-rect(1))/2;
yhalf = (rect(4)-rect(2))/2;
xc = rect(1) + xhalf;
yc = rect(2) + yhalf;
[n,m] = size(region);

% run over the image sequence
for i = 140:190
    It = imread(num2str(i,'sequence/2043_000%03d.jpeg'));
    
    for j = 1:20
        region = It(yc-yhalf:yc+yhalf, xc-xhalf:xc+xhalf,:);
        P = probMap(region, h);
        % update region:
        % centers
        [y,x] = meshgrid(yc-yhalf:yc+yhalf, xc-xhalf:xc+xhalf);
        xc = sum(sum(x*P)) / sum(sum(P));
        yc = sum(sum(y*P)) / sum(sum(P));
    end
    
end


