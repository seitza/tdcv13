%%include sift stuff
run('../../../vlfeat-0.9.17/toolbox/vl_setup.m');

%% clean workspace
close all;
clear;
clc;

%% do sift stuff
%read images
I1 = single(rgb2gray(imread('tum_mi_1.JPG')));
I2 = single(rgb2gray(imread('tum_mi_2.JPG')));

%calc sift
%f: y,x,scale,orientation
%d: descriptors
[f1,d1] = vl_sift(I1);
[f2,d2] = vl_sift(I2);

%calc sift descriptor matches
%matches: 1 and 2 indizes of matched descriptors 
[matches, scores] = vl_ubcmatch(d1,d2);

%% do ransac stuff
%prepare for ransac ((nx2))
S1 = round(f1(1:2,matches(1,:)))';
S2 = round(f2(1:2,matches(2,:)))';

%visualize matched features
figure;
imagesc(I1), colormap gray, axis equal tight off;;
hold on;
%h1 = vl_plotframe(f1); % all features
h1 = vl_plotframe(f1(:,matches(1,:)));

figure;
imagesc(I2), colormap gray, axis equal tight off;;
hold on;
%h2 = vl_plotframe(f2); %all features
h2 = vl_plotframe(f2(:,matches(2,:)));

%run ransac
[S1_m, S2_m, H] = ransac(S1,S2,1,10);%,4,500);
disp(H);

%% prepare visualization
%use ransac solution on image

J = zeros(size(I1,1),size(I1,2),2);
for i = 1:size(I1,1);
    for j = 1:size(I1,2);
        n = [j,i,1]*H';
        n = n./n(3);
        %disp(n(3))
        J(i,j,1) = n(2);
        J(i,j,2) = n(1);
    end
end
J = round(J);

% max2 = max(max(J(:,:,2)));
% min2 = min(min(J(:,:,2)));
% max1 = max(max(J(:,:,1)));
% min1 = min(min(J(:,:,1)));
max2 = max(max(max(J(:,:,2))),size(I1,2));
min2 = min(min(min(J(:,:,2))),size(I1,2));
max1 = max(max(max(J(:,:,1))),size(I1,1));
min1 = min(min(min(J(:,:,1))),size(I1,1));
disp([min1 max1 min2 max2]);

R = zeros(max1-min1+1,max2-min2+1);
for i = 1:size(I1,1);
    for j = 1:size(I1,2);
        R(J(i,j,1)-min1+1,J(i,j,2)-min2+1) = I1(i,j);
    end
end
for i = 1:size(I2,1);
    for j = 1:size(I2,2);
        R(i-min1,j-min2)=I2(i,j);
    end
end


%%visualize
% figure;
% imagesc(I1), colormap gray, axis equal tight off;
% figure;
% imagesc(I2), colormap gray, axis equal tight off;
figure;
imagesc(R), colormap gray, axis equal tight off;