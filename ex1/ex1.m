%% init
close all;
clear all;
clc;

%% 1 b)
H = [[1,1,1];[1,1,1];[1,1,1]]/9;

I = double(imread('lena.gif'))/255.0;
J = conv_dennis(I,H,'replicate');

%% plotting
figure('NumberTitle', 'Off', 'Name', 'Exercise 1');
subplot(1,2,1);
imagesc(I),axis equal tight off, colormap gray;
title('Original image');

subplot(1,2,2);
imagesc(J),axis equal tight off, colormap gray;
title('Filtered image');