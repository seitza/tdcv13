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

%linda
boundary = [103, 75;
             550, 75;
             105, 385;
             553, 385];
         
min_x = min(boundary(:,1));
max_x = max(boundary(:,1));
min_y = min(boundary(:,2));
max_y = max(boundary(:,2));

in = f0(1,:) > min_x & f0(1,:) <= max_x & ...
             f0(2,:) > min_y & f0(2,:) <= max_y;

f0 = f0(:, in);

figure;
imagesc(I0), colormap gray;
hold on;
plot(f0(1,:), f0(2,:), 'r+');

% 3D points
f0 = [f0(1:2, :); ones(1,size(f0,2))];
M0 = A\f0;
M0 = [M0;ones(1,size(M0,2))];

save('ex1_result');

