%% init
close all;
clear all;
clc;

%% load image and create filters
I = double(rgb2gray(imread('lena_noisy.jpg')))/255.0;

Dx = [[-1,0,1];
    [-1,0,1];
    [-1,0,1]];

Dy = [[-1,-1,-1];
    [0,0,0];
    [1,1,1]];

[Gy,Gx] = gen_gaussian_1D(1.0);

%% 3 a) and b) - gradient creation
Ix = convolution(I, Dx, 'border');
Iy = convolution(I, Dy, 'border');

Imag = sqrt(Ix.^2 + Iy.^2);
Idir = atan2(Iy,Ix);

%% 3 c) smoothing kernel before convoluting
Ix_smooth = convolution(I,convolution(Dx, Gx), 'border');
Iy_smooth = convolution(I,convolution(Dy, Gy), 'border');

Imag_smooth = sqrt(Ix_smooth.^2 + Iy_smooth.^2);
Idir_smooth = atan2(Iy_smooth, Ix_smooth);

%% plotting
figure;
imshow(Imag);

figure;
imshow(Idir);

figure;
imshow(Imag_smooth);

figure;
imshow(Idir_smooth);
