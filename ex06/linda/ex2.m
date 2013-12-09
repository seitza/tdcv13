clc;
clear;
close all;

%% classification
load('Classifiers.mat');
haar = HaarFeatures(classifiers(:,2:size(classifiers,2)));

%% I1
I1 = double(rgb2gray(imread('face1.jpg')));

[scores1, J1] = classify_face(haar, I1);
figure;
imagesc(J1);
figure;
imagesc(scores1);

%% I2
I2 = double(rgb2gray(imread('face2.jpg')));
[scores2, J2] = classify_face(haar, I2);
figure;
imagesc(J2);
figure;
imagesc(scores2);

%% I3
I3 = double(rgb2gray(imread('face3.jpg')));

[scores3, J3] = classify_face(haar, I3);
figure;
imagesc(J3);
figure;
imagesc(scores3);