%this file is supposed to be the "main" executing file, to present our
%solutions during the exercises

% close all figure windows
close all;

% clear all workspace variables
clear;     

% clear command window
clc;       


%% Exercise 1

I = imread('lena.gif');
kernel = [1/9, 1/9, 1/9; 1/9, 1/9, 1/9; 1/9, 1/9, 1/9];
J_border = generic_convolution_andre(I, kernel, 'border');
J_mirror = generic_convolution_andre(I, kernel, 'mirror');

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

I = imread('lena.gif');

mask_2d_s1 = gen_gaussian_2D_andre(1);
mask_2d_s3 = gen_gaussian_2D_andre(3);

J_2D_s1 = uint8(generic_convolution_andre(I, mask_2d_s1, 'mirror'));
J_2D_s3 = uint8(generic_convolution_andre(I, mask_2d_s3, 'mirror'));

figure
imagesc(J_2D_s1), axis equal tight off, colormap gray
title('gauss 2D sigma1')

figure
imagesc(J_2D_s3), axis equal tight off, colormap gray
title('gauss 2D sigma3')

[mask_1d_s1_y,mask_1d_s1_x] = gen_gaussian_1D_andre(1);
[mask_1d_s3_y,mask_1d_s3_x] = gen_gaussian_1D_andre(3);

J_1D_s1 = generic_convolution_andre(generic_convolution_andre(I, mask_1d_s1_y, 'mirror'),mask_1d_s1_x, 'mirror');
J_1D_s3 = generic_convolution_andre(generic_convolution_andre(I, mask_1d_s3_y, 'mirror'),mask_1d_s3_y, 'mirror');

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

Dx = [-1 0 1; -1 0 1; -1 0 1];
Dy = [-1 -1 -1; 0 0 0; 1 1 1];

I = imread('lena.gif');

I_Dx = generic_convolution_andre(I,Dx,'mirror');
I_Dy = generic_convolution_andre(I,Dy,'mirror');

mag = magnitude_andre(I_Dx,I_Dy);


