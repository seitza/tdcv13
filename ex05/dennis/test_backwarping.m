close all;
clear all;
clc;

I = imread('cameraman.tif');
% create affine transform
theta = 0 + 2*pi*rand(1);
phi = 0 + 2*pi*rand(1);
lambdas = 0.6 + (1.5-0.6).*rand(2,1);

H = create_affine_transform(theta,phi, lambdas);
tform = affine2d(H);

I_warp = imwarp(I,tform);
[xlim, ylim] = outputLimits(tform, [1 size(I,2)], [1 size(I,1)]);

warpHandle = figure('Name', 'Warped image', 'NumberTitle', 'Off');
imagesc(I_warp); axis equal tight off; colormap gray;
hold on;

% get points from user
[userX, userY] = getpts(warpHandle);
scatter(userX, userY, 25, 'rs', 'filled');
hold off;

% warp points back
% set offset appropiate
userX = userX + xlim(1) - 1;
userY = userY + ylim(1) - 1;
[backX, backY] = transformPointsInverse(tform, userX, userY);

backX = round(backX);
backY = round(backY);

% plot stuff
figure('Name', 'Original image', 'NumberTitle', 'Off');
imagesc(I); axis equal tight off; colormap gray;
hold on;
scatter(backX, backY, 25, 'rs', 'filled');
