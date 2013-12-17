clear all;
close all;
clc;

% Setup sift path
if exist('vl_version') == 0
    disp('loading sift implementation...');
    run('/Users/Pitou/Documents/München/DTCV/Exercises/Ex7/vlfeat-0.9.17/toolbox/vl_setup.m');
end

% Values
I0 = single(rgb2gray(imread('img_sequence/0000.png')));

A = [472.3 0.64, 329.0; 
    0, 471.0, 268.3; 
    0, 0, 1];

% Compute SIFT
[f0 d0] = vl_sift(I0);
figure;
imagesc(I0), colormap gray;
hold on;
plot(f0(1,:), f0(2,:), 'r+');


% 3D points
m = [f0(1:2, :); ones(1,size(f0,2))];
M = A\m;

save('ex1_result');
