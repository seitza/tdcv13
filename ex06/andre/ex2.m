clear;
clc;
close all;

%%
s=19;
I = double(rgb2gray(imread('face3.jpg')));



load('Classifiers.mat');
HF = HaarFeatures(classifiers(:,2:size(classifiers,2)));

It = I;
minSize = min(size(It));
while minSize >= s
    figure;
    imagesc(It), colormap gray;
    size(It)
    Ii = integral(It);
    tmp = zeros(size(Ii));
    for i = 1:size(Ii,1)-s+1
        for j = 1:size(Ii,2)-s+1
           x = HF.HaarFeaturesCompute(Ii(i:i+s-1,j:j+s-1));
           tmp(i,j) = x;
        end
    end
    figure;
    imagesc(tmp);
    It = imfilter(It,fspecial('gaussian'));
    It = It(1:2:size(It,1),1:2:size(It,2));
    minSize = min(size(It));
end

