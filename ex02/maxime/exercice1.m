% Exercice 1
clear all;
close all;
clc;

% Values
I = double(imread('lena.gif'));
sigma = 3.0;

% Noise filter
J_gauss = noise(I, 'gaussian', sigma);
J_sp = noise(I, 's&p');

% Gaussian filter
H = fspecial('gaussian', [3 3], sigma);
J_gauss_gauss = imfilter(J_gauss, H, 'replicate');
J_gauss_sp = imfilter(J_sp, H,  'replicate');

% Median filter
J_median_gauss = median_filter(J_gauss, [3 3]);
J_median_sp = median_filter(J_sp, [3 3]);

% Plot
figure('Name', 'Original Image', 'NumberTitle', 'Off')
imagesc(I), axis equal tight off, colormap gray
title('Lena');

figure('Name', 'Corrupted Images', 'NumberTitle', 'Off')
subplot(1,2,1);
imagesc(J_gauss), axis equal tight off, colormap gray
title('Gaussian noise');

subplot(1,2,2);
imagesc(J_sp), axis equal tight off, colormap gray
title('Salt and pepper noise');

figure('Name', 'Gaussian filter', 'NumberTitle', 'Off')
subplot(1,2,1);
imagesc(J_gauss_gauss), axis equal tight off, colormap gray
title('Gaussian noise with gaussian filter');

diff1 = sum(sum((J_gauss_gauss - I).^2));

subplot(1,2,2);
imagesc(J_gauss_sp), axis equal tight off, colormap gray
title('Salt and pepper noise with gaussian filter');

diff2 = sum(sum((J_gauss_sp - I).^2));

figure('Name', 'Median filter', 'NumberTitle', 'Off')
subplot(1,2,1);
imagesc(J_median_gauss), axis equal tight off, colormap gray
title('Gaussian noise with median filter');

diff3 = sum(sum((J_median_gauss - I).^2));

subplot(1,2,2);
imagesc(J_median_sp), axis equal tight off, colormap gray
title('Salt and pepper noise with median filter');

diff4 = sum(sum((J_median_sp - I).^2));
