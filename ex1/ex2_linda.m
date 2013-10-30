close all;
clear;
clc;

%% a)
I = imread('lena.gif');

mask_2D_s1 = gauss_2D_linda(1.0);
mask_2D_s3 = gauss_2D_linda(3.0);

J_gauss_2D_s1 = convolution_linda(I, mask_2D_s1, 'mirror');
tic
J_gauss_2D_s3 = convolution_linda(I, mask_2D_s3, 'mirror');
time_2D_s3 = toc;

%% b)
mask_1D_s1 = gauss_1D_linda(1.0);
mask_1D_s3 = gauss_1D_linda(3.0);

