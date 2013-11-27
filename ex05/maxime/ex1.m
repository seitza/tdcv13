clear;
clc;
close all;


fern_number = 20;
fern_depth = 10;


I = double(imread('imagesequence/img1.ppm'));

% Process
features = corner(I, 'harris');
F = ferns(fern_number, fern_depth, size(features));
F.train();
F.normalize();

% Gaussian
F.classify();


