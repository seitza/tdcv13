%% Exercise 2
close all;
clear;
clc;

% b)
I = imread('lena.gif');
I_double = double(I);

J1 = bilateral_filter(I_double, 1.0);
J5 = bilateral_filter(I_double, 5.0);
J11 = bilateral_filter(I_double, 11.0);

% c)
k1 = fspecial('gaussian', [3, 3], 1.0);
k5 = fspecial('gaussian', [15, 15], 5.0);
k11 = fspecial('gaussian', [33, 33], 11.0);
G1 = imfilter(I_double, k1);
G5 = imfilter(I_double, k5);
G11 = imfilter(I_double, k11);


%% show images

figure('Name', 'Exercise bilateral filter', 'NumberTitle', 'off');
subplot(2,2, 1);
imagesc(I_double), axis equal tight off, colormap gray;
title('original');

subplot(2,2,2);
imagesc(J1), axis equal tight off, colormap gray;
title('bilateral filter sigma = 1');

subplot(2,2,3);
imagesc(J5), axis equal tight off, colormap gray;
title('bilateral filter sigma = 5');

subplot(2,2,4);
imagesc(J11), axis equal tight off, colormap gray;
title('bilateral filter sigma = 11');

figure('Name', 'Exercise gaussian filter', 'NumberTitle', 'off');
subplot(2,2, 1);
imagesc(I_double), axis equal tight off, colormap gray;
title('original');

subplot(2,2,2);
imagesc(G1), axis equal tight off, colormap gray;
title('gaussian filter sigma = 1');

subplot(2,2,3);
imagesc(G5), axis equal tight off, colormap gray;
title('gaussian filter sigma = 5');

subplot(2,2,4);
imagesc(G11), axis equal tight off, colormap gray;
title('gaussian filter sigma = 11');
