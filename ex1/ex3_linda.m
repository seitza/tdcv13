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
gradient_orientations = atan2(J_Dy./J_Dx);

%% c)


%% display images

% show convoluted image using the second border handling (border)
figure
imagesc(J_mirror), axis equal tight off, colormap gray
title('mirror')
