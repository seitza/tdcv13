%% Exercise 1
clc;
close all;
clear;
%%
I = imread('lena.gif');
I_double = double(I);

s0 = 1.5;
k = 1.2;
alpha = 0.04;
t = 1000000;

n = 0;
J0 = harris_detector(I_double, n, alpha, t , s0, k);

n = 5;
J5 = harris_detector(I_double, n, alpha, t , s0, k);

n = 17;
J17 = harris_detector(I_double, n, alpha, t , s0, k);

%% visualize
figure('Name', 'Harris Corner Detector', 'NumberTitle', 'off');
subplot(1,3,1);
imagesc(I), colormap gray, axis equal tight off;
hold on;
plot(J0(1,:), J0(2,:), 'r+');
title('n = 0');

subplot(1,3,2);
imagesc(I), colormap gray, axis equal tight off;
hold on;
plot(J5(1,:), J5(2,:), 'r+');
title('n = 5');

subplot(1,3,3);
imagesc(I), colormap gray, axis equal tight off;
hold on;
plot(J17(1,:), J17(2,:), 'r+');
title('n = 17');
