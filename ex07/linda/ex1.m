clc; clear; close all;

%%
A = [472.3 0.64, 329.0; 0, 471.0, 268.3; 0, 0, 1]; % internal calibration matrix, fixed

R = [1,0,0; 0,1,0; 0,0,1]; % initial rotation matrix

T = [0;0;0]; % initial translation vector

I0 = single(rgb2gray(imread('img_sequence/0000.png')));

% compute SIFT features
[f0, d0] = vl_sift(I0);
% figure;
% imagesc(I0), colormap gray;
% hold on;
% scatter(f0(1,:), f0(2,:), 'Xr');

% discard features that are not within the area of the object
f0 = f0(:, f0(1,:)>98 & f0(1,:)<560 & f0(2,:)>70 & f0(2,:)<394);
d0 = d0(:, f0(1,:)>98 & f0(1,:)<560 & f0(2,:)>70 & f0(2,:)<394);
% scatter(f0(1,:), f0(2,:), 'Xg');

% compute corresponding 3D points
m = [f0(1:2, :); ones(1,size(f0, 2))];
M = A\m;

save('ex1_result', 'M', 'f0', 'd0');

