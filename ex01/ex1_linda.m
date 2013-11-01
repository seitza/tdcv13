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
J_border = convolution_linda(I, kernel, 'border');
J_mirror = convolution_linda(I, kernel, 'mirror');

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
