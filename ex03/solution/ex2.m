%% Exercise 2
clc;
close all;
clear;
%%
I = imread('lena.gif');
I_double = double(I);

res_level = 5;
s0 = 1.5;
k = 1.2;
alpha = 0.04;
th = 1000000;
tl = 50;

points = harris_laplace( I_double, res_level, s0, k, alpha, th, tl );

%% visualize

figure;
imagesc(I);
axis equal tight off, colormap(gray);
hold on;

for i=1:size(points,1)
   plot(points(i,1),points(i,2),'ro','MarkerSize',(points(i,3)^2)*5); 
end