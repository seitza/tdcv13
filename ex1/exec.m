%this file is supposed to be the "main" executing file, to present our
%solutions during the exercises

% close all figure windows
close all;

% clear all workspace variables
clear;     

% clear command window
clc;       


%% Exercise 1

I = double(imread('lena.gif'))/255.0;
kernel = ones(3)/9;
J_border = conv_dennis(I, kernel, 'border');
J_mirror = conv_dennis(I, kernel, 'mirror');

% show original image
figure
imagesc(I), axis equal tight off, colormap gray
title('original image')

% show convoluted image using the second border handling (border)
figure
imagesc(J_border), axis equal tight off, colormap gray
title('border')

% show convoluted image using the second border handling (border)
figure
imagesc(J_mirror), axis equal tight off, colormap gray
title('mirror')

%% Exercise 2

I = double(imread('lena.gif'))/255.0;

mask_2d_s1 = gen_gaussian_2D_andre(1);
mask_2d_s3 = gen_gaussian_2D_andre(3);

J_2D_s1 = conv_dennis(I, mask_2d_s1, 'replicate');
J_2D_s3 = conv_dennis(I, mask_2d_s3, 'replicate');

figure
imagesc(J_2D_s1), axis equal tight off, colormap gray
title('gauss 2D sigma1')

figure
imagesc(J_2D_s3), axis equal tight off, colormap gray
title('gauss 2D sigma3')

[mask_1d_s1_y,mask_1d_s1_x] = gen_gaussian_1D_andre(1);
[mask_1d_s3_y,mask_1d_s3_x] = gen_gaussian_1D_andre(3);

J_1D_s1 = conv_dennis(conv_dennis(I, mask_1d_s1_y, 'replicate'),mask_1d_s1_x, 'replicate');
J_1D_s3 = conv_dennis(conv_dennis(I, mask_1d_s3_y, 'replicate'),mask_1d_s3_x, 'replicate');

figure
imagesc(J_1D_s1), axis equal tight off, colormap gray
title('gauss 1D sigma1')

figure
imagesc(J_1D_s3), axis equal tight off, colormap gray
title('gauss 1D sigma3')

s1 = sum(sum((J_1D_s1-J_2D_s1).*(J_1D_s1-J_2D_s1)));
disp(s1)

s3 = sum(sum((J_1D_s3-J_2D_s3).*(J_1D_s3-J_2D_s3)));
disp(s3)

%% Exercise 3
