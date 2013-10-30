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

% [Gy,Gx] = gen_gaussian_1D_andre(3.0)
Gy = fspecial('gaussian',[3 3], 3.0);
Gx = Gy;

%% 3 a) and b) - gradient creation
Ix = conv_dennis(I, Dx, 'border');
Iy = conv_dennis(I, Dy, 'border');

Imag = sqrt(Ix.^2 + Iy.^2);
Idir = atan2(Iy,Ix);

%% 3 c) smoothing kernel before convoluting
Ix_smooth = conv_dennis(I,conv_dennis(Dx, Gx), 'border');
Iy_smooth = conv_dennis(I,conv_dennis(Dy, Gy), 'border');

Imag_smooth = sqrt(Ix_smooth.^2 + Iy_smooth.^2);
Idir_smooth = atan2(Iy_smooth, Ix_smooth);

%% plotting
figure;
% imagesc(Imag), axis equal tight off, colormap gray;
imshow(Imag);

figure;
% imagesc(Idir), axis equal tight off, colormap gray;
imshow(Idir);

figure;
% imagesc(Imag_smooth), axis equal tight off, colormap gray;
imshow(Imag_smooth);

figure;
% imagesc(Idir_smooth), axis equal tight off, colormap gray;
imshow(Imag_smooth);
