%% Exercise 1
close all;
clear;
clc;

%c)
I = imread('lena.gif');

sigma = 3.0;
median_size = 3*sigma;

I_gauss = noise_linda(I, 'gaussian', sigma);
I_sp = noise_linda(I, 'salt&pepper');

J_gauss_gauss = gaussian_filter_linda(I_gauss, sigma);
J_sp_gauss = gaussian_filter_linda(I_sp, sigma);

J_gauss_median = median_filter_linda(I_gauss, median_size, median_size);
J_sp_median = median_filter_linda(I_sp, median_size, median_size);

%% visualize images

figure('Name', 'Exercise 2', 'NumberTitle', 'off');
subplot(2,3,1);
imagesc(I_gauss), axis equal tight off, colormap gray;
title('gaussian noise');

subplot(2,3,2);
imagesc(J_gauss_gauss), axis equal tight off, colormap gray;
title('gaussian noise and gaussian filter');

subplot(2,3,3);
imagesc(J_gauss_median), axis equal tight off, colormap gray;
title('gaussian noise and median filter');

subplot(2,3,4);
imagesc(I_sp), axis equal tight off, colormap gray;
title('salt and pepper noise');

subplot(2,3,5);
imagesc(J_sp_gauss), axis equal tight off, colormap gray;
title('salt and pepper noise and gaussian filter');

subplot(2,3,6);
imagesc(J_sp_median), axis equal tight off, colormap gray;
title('salt and pepper noise and median filter');


