clear all;
close all;
clc;

% I = double(rgb2gray(imread('harris.jpg')));
I = double(imread('lena.gif'));

s0 = 1.5;
k = 1.2;
t = 1000000;
alpha = 0.06;
n = [0; 5; 17];

% calculate corners
for i=1:length(n)
    fprintf('Calculating corners for scale %d\n', n(i));
    [row, col] = harris_corner_detector(I, n(i), s0, k, alpha, t);
    
    figure('Name', sprintf('Multiscale Harris with n=%d', n(i)), ...
        'NumberTitle', 'Off');
    imagesc(I), axis equal tight off, colormap gray    
    hold on;    
    plot(col(:), row(:), 'ro');
    hold off;
end
