
clear;
clc;
close all;

%%
profile clear;
profile on;

%%
im = double(rgb2gray(imread('imagesequence/img1.ppm')));

patchsize=31;
fern_number = 20;
fern_depth = 10;

[classes, patches] = prepare_train(im,patchsize);

F = ferns_simple(fern_number, fern_depth, size(classes,2));

F.train_many(classes,patches);

%%
profile off;
profile viewer;