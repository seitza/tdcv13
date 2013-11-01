%% init
close all;
clear all;
clc;

%% calculating gradients, magnitude and orientation
I = double(imread('lena.gif'))/255.0;

Dx = [[-1,0,1];
    [-1,0,1];
    [-1,0,1]];

Dy = [[-1,-1,-1];
    [0,0,0];
    [1,1,1]];

%% 3 a) and b)
Ix = conv_dennis(I,Dx,'replicate');
Iy = conv_dennis(I,Dy,'replicate');

Gmag = sqrt(Ix.^2 + Iy.^2);
Gdir = atan2(Iy,Ix);

%% 3 c)
[Gy,Gx] = gaussian_1D_dennis(1.0);
Ix_smooth = conv_dennis(I,conv_dennis(Dx,Gx));
Iy_smooth = conv_dennis(I,conv_dennis(Dy,Gy));

Gmag_smooth = sqrt(Ix_smooth.^2 + Iy_smooth.^2);
Gdir_smooth = atan2(Iy_smooth,Ix_smooth);

%% plotting data
figure('Name','Exercise 3: Image Gradients - No smoothing', 'NumberTitle', 'Off');
subplot(1,2,1);
imagesc(Gmag), axis equal tight off, colormap gray
title('Gradient magnitude');

subplot(1,2,2);
imagesc(Gdir), axis equal tight off, colormap gray
title('Gradient orientation');

figure('Name','Exercise 3: Image Gradients - Smoothed derivative', 'NumberTitle', 'Off');
subplot(1,2,1);
imagesc(Gmag_smooth), axis equal tight off, colormap gray
title('Smooth gradient magnitude');

subplot(1,2,2);
imagesc(Gdir_smooth), axis equal tight off, colormap gray
title('Smooth gradient orientation');