%this file is supposed to be the "main" executing file, to present our
%solutions during the exercises

% close all figure windows
close all;

% clear all workspace variables
clear;     

% clear command window
clc;       

%% Exercise 3
%% calculating gradients, magnitude and orientation
border_treatment = 'border';
I = double(imread('lena.gif'))/255.0;

Dx = [[-1,0,1];
    [-1,0,1];
    [-1,0,1]];

Dy = [[-1,-1,-1];
    [0,0,0];
    [1,1,1]];

%% 3 a) and b)
Ix = conv_dennis(I,Dx,border_treatment);
Iy = conv_dennis(I,Dy,border_treatment);

Gmag = sqrt(Ix.^2 + Iy.^2);
Gdir = atan2(Iy,Ix);

%% 3 c)
[Gy,Gx] = gen_gaussian_1D_andre(1.0);
Ix_smooth = conv_dennis(I,conv_dennis(Dx,Gx),border_treatment);
Iy_smooth = conv_dennis(I,conv_dennis(Dy,Gy),border_treatment);

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
