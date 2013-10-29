%% init
close all;
clear all;
clc;

%% computing
sigma1 = 1.0;
sigma3 = 3.0;

img = double(imread('lena.gif'))/255;

%% 2 a)
G_2d_sigma1 = gaussian_2D_dennis(sigma1);
G_2d_sigma3 = gaussian_2D_dennis(sigma3);

fprintf('Computing convolution with 2D-Gaussian (sigma = %d)\n',sigma1);
tic;
Img_2D_sigma1 = conv_dennis(img,G_2d_sigma1, 'replicate');
toc;

fprintf('Computing convolution with 2D-Gaussian (sigma = %d)\n',sigma3);
tic;
Img_2D_sigma3 = conv_dennis(img,G_2d_sigma3, 'replicate');
toc;

%% 2 b)
[Gx_sigma1, Gy_sigma1] = gaussian_1D_dennis(sigma1);
[Gx_sigma3, Gy_sigma3] = gaussian_1D_dennis(sigma3);

fprintf('Computing convolution with 1D-Gaussians (sigma = %d)\n',sigma1);
tic;
Img_1D_sigma1 = conv_dennis(conv_dennis(img,Gx_sigma1, 'replicate'),Gy_sigma1,'replicate');
toc;

fprintf('Computing convolution with 1D-Gaussians (sigma = %d)\n',sigma3);
tic;
Img_1D_sigma3 = conv_dennis(conv_dennis(img,Gx_sigma3, 'replicate'),Gy_sigma3,'replicate');
toc;

squared_diffs_sigma1 = sum(sum((Img_2D_sigma1 - Img_1D_sigma1).^2));
fprintf('Sum of squared differences between 2D and 1D-Gaussians for sigma = %d: %f\n', sigma1, squared_diffs_sigma1)

squared_diffs_sigma3 = sum(sum((Img_2D_sigma3 - Img_1D_sigma3).^2));
fprintf('Sum of squared differences between 2D and 1D-Gaussians for sigma = %d: %f\n', sigma3, squared_diffs_sigma3)

%% plotting
figure('Name', 'Exercise 2', 'NumberTitle', 'off');
subplot(3,2,[1 2]);
imagesc(img), axis equal tight off, colormap gray;
title('Lena original');

subplot(3,2,3);
imagesc(Img_2D_sigma1), axis equal tight off, colormap gray;
title('Lena filtered with sigma = 1');

subplot(3,2,4);
imagesc(Img_2D_sigma3), axis equal tight off, colormap gray;
title('Lena filtered with sigma = 3');

subplot(3,2,5);
imagesc(Img_1D_sigma1), axis equal tight off, colormap gray;
title('Lena filtered with 1D filters (sigma=1)');

subplot(3,2,6);
imagesc(Img_1D_sigma3), axis equal tight off, colormap gray;
title('Lena filtered with 1D filters (sigma=3)');