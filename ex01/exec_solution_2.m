%this file is supposed to be the "main" executing file, to present our
%solutions during the exercises
% close all figure windows
close all;

% clear all workspace variables
clear;     

% clear command window
clc;       

%% Exercise 2
I = double(imread('lena.gif'))/255.0;

figure
imagesc(I), axis equal tight off, colormap gray
title('original')

s1 = 1;
s3 = 3;

border_treatment = 'border';

mask_2d_s1 = gen_gaussian_2D(s1);
mask_2d_s3 = gen_gaussian_2D(s3);

fprintf('Filtering with 2D-Gaussian with sigma %d\n', s1);
tic;
J_2D_s1 = convolution(I, mask_2d_s1, border_treatment);
toc;

fprintf('Filtering with 2D-Gaussian with sigma %d\n', s3);
tic;
J_2D_s3 = convolution(I, mask_2d_s3, border_treatment);
toc;

figure
imagesc(J_2D_s1), axis equal tight off, colormap gray
title('gauss 2D sigma1')

figure
imagesc(J_2D_s3), axis equal tight off, colormap gray
title('gauss 2D sigma3')

[mask_1d_s1_y,mask_1d_s1_x] = gen_gaussian_1D(1);
[mask_1d_s3_y,mask_1d_s3_x] = gen_gaussian_1D(3);

fprintf('\nFiltering with 2*1D-Gaussian with sigma %d\n', s1);
tic;
J_1D_s1 = convolution(convolution(I, mask_1d_s1_y, border_treatment),mask_1d_s1_x, border_treatment);
toc;

fprintf('Filtering with 2*1D-Gaussian with sigma %d\n', s3);
tic;
J_1D_s3 = convolution(convolution(I, mask_1d_s3_y, border_treatment),mask_1d_s3_x, border_treatment);
toc;

figure
imagesc(J_1D_s1), axis equal tight off, colormap gray
title('gauss 1D sigma1')

figure
imagesc(J_1D_s3), axis equal tight off, colormap gray
title('gauss 1D sigma3')

squared_diffs_s1 = sum(sum((J_1D_s1-J_2D_s1).*(J_1D_s1-J_2D_s1)));
fprintf('\nSum of squared differences between 2D-Gaussian and 2*1D-Gaussian with sigma %d = %f\n', s1, squared_diffs_s1);

squared_diffs_s3 = sum(sum((J_1D_s3-J_2D_s3).*(J_1D_s3-J_2D_s3)));
fprintf('Sum of squared differences between 2D-Gaussian and 2*1D-Gaussian with sigma %d = %f\n', s3, squared_diffs_s3);
