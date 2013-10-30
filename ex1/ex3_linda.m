close all;
clear;
clc;

%% a)

Dx = [-1,0,1;-1,0,1;-1,0,1];
Dy = [-1,-1,-1;0,0,0;1,1,1];

I = double(imread('lena.gif'))/255;

J_Dx = convolution_linda(I, Dx, 'mirror');
J_Dy = convolution_linda(I, Dy, 'mirror');

%% b)
%gradient magnitudes
gradient_magnitude = sqrt(J_Dx.^2+J_Dy.^2);

%gradient orientations
gradient_orientations = atan2(J_Dy,J_Dx);

%% c)

[Gx, Gy] = gauss_1D_linda(1.0);

Jx_smooth = convolution_linda(I, convolution_linda(Gx, Dx, 'mirror'), 'mirror');
Jy_smooth = convolution_linda(I, convolution_linda(Gy, Dy, 'mirror'), 'mirror');

%gradient magnitudes
gradient_magnitude_smooth = sqrt(Jx_smooth.^2+Jy_smooth.^2);

%gradient orientations
gradient_orientations_smooth = atan2(Jy_smooth,Jx_smooth);

%% display images

% show gradient magnitude
figure
imagesc(gradient_magnitude), axis equal tight off, colormap gray
title('gradient magnitude')

% show gradient orientations
figure
imagesc(gradient_orientations), axis equal tight off, colormap gray
title('gradient orientations')


% show gradient magnitude smoothed
figure
imagesc(gradient_magnitude_smooth), axis equal tight off, colormap gray
title('gradient magnitude smoothed')

% show gradient orientations
figure
imagesc(gradient_orientations_smooth), axis equal tight off, colormap gray
title('gradient orientations smoothed')

