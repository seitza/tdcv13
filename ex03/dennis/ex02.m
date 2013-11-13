%% init
clear all;
close all;
clc;

I = double(imread('lena.gif'));

% parameters from paper - except n
n = 5;
k = 1.2;
s0 = 1.5;
alpha = 0.06;

th = 1500;
tl = 10;

feature_points = harris_laplace(I,n,k,s0,alpha,th,tl);

%% plotting stuff
figure('Name', 'Harris-Laplace Detector', 'NumberTitle', 'Off');
imagesc(I), axis equal tight off, colormap gray
hold on;
% draw all points
for i=1:size(feature_points,1)
    plot(feature_points(i,2), feature_points(i,1), 'ro', 'MarkerSize', feature_points(i,3)*7);
end
