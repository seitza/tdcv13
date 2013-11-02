%% Exercise 2
close all;
clear;
clc;

% b)
I = imread('lena.gif');

J1 = bilateral_filter_linda(double(I)/255, 1.0);

imagesc(J1), axis equal tight off, colormap gray;
