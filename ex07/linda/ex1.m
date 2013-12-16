clc; clear; close all;

%%

num_images = 45;

% setup sift path
if exist('vl_version') == 0
    disp('loading sift implementation...');
    run('/Users/Linda/Documents/MATLAB/vlfeat-0.9.17/toolbox/vl_setup.m');
end

A = [472.3 0.64, 329.0; 0, 471.0, 268.3; 0, 0, 1]; % internal calibration matrix, fixed

I0 = single(rgb2gray(imread('img_sequence/0000.png')))./255;

% compute SIFT features
[f0, d0] = vl_sift(I0);
figure;
imagesc(I0), colormap gray;
hold on;
scatter(f0(1,:), f0(2,:), 'Xr');

 % corners of the image figure
 boundary = [103, 75;
             550, 75;
             105, 385;
             553, 385];
         
min_x = min(boundary(:,1));
max_x = max(boundary(:,1));
min_y = min(boundary(:,2));
max_y = max(boundary(:,2));

% discard features that are not within the area of the object
valid_frames = f0(1,:) > min_x & f0(1,:) <= max_x & ...
             f0(2,:) > min_y & f0(2,:) <= max_y;

f0_rect = f0(:, valid_frames);
d0_rect = d0(:, valid_frames);
scatter(f0_rect(1,:), f0_rect(2,:), 'Xg');

% compute corresponding 3D points
m = [f0_rect(1:2, :); ones(1,size(f0_rect, 2))];
M = A\m;
% homogenious coordinates
M = [M; ones(1,size(f0_rect, 2))];

save('ex1_result');

