clc;
clear;
close all;

%%
I = imread(num2str(140,'sequence/2043_000%03d.jpeg'));

% define a rectangular region manually
figure;
imagesc(I);
rect = round(getrect);     % [xmin, ymin, width, height]

% compute probability dirstribution within the rectangle for all images
for i = 140:190
    I = imread(num2str(i,'sequence/2043_000%03d.jpeg'));
    region = I(rect(2):rect(2)+rect(4), rect(1):rect(1)+rect(3), :);
    % create histogram of the hue intensities of the rectangle
    h = colorHist(region);
    % compute probability distribution
    prob = probMap(region, h);
    % plot probability distribution
    imagesc(prob);
    drawnow;
    input('input');
end

