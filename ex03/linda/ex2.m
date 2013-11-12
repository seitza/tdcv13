%% Exercise 2

clc;
close all;
clear;


I = imread('lena.gif');
I_double = double(I);
%I = imread('harris.jpg');
%I_double = double(I(:,:,1));

res_level = 5;
s0 = 1.5;
k = 1.2;
alpha = 0.04;
th = 1000000;
tl = 50;

points = harris_laplace( I_double, res_level, s0, k, alpha, th, tl );

%% visualize

figure;
imagesc(I);
axis equal tight off, colormap(gray);
hold on;

for i=1:size(points,1)
   plot(points(i,2),points(i,1),'ro','MarkerSize',(points(i,3)^2)*5); 
end

% for i = 1:res_level
%     figure('Name', ['resolution level ' num2str(i)], 'NumberTitle', 'off');
%     imagesc(I), colormap gray, axis equal tight off;
%     hold on;
%     p = points{1,i};
%     plot(p(:,2), p(:,1), 'r+');
%     title(['resolution level ' num2str(i)]);
% end