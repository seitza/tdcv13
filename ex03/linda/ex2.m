%% Exercise 2

clc;
close all;
clear;


%I = imread('lena.gif');
%I_double = double(I);
I = imread('harris.jpg');
I_double = double(I(:,:,1));

res_level = 5;
s0 = 1.5;
k = 1.2;
alpha = 0.06;
th = 1500;
tl = 10;

points = harris_laplace( I_double, res_level, s0, k, alpha, th, tl );

%% visualize
for i = 1:res_level
    figure('Name', ['resolution level ' num2str(i)], 'NumberTitle', 'off');
    imagesc(I), colormap gray, axis equal tight off;
    hold on;
    p = points{1,i};
    plot(p(:,2), p(:,1), 'r+');
    title(['resolution level ' num2str(i)]);
end