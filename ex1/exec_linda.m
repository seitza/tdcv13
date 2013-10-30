%this file is supposed to be the "main" executing file, to present our
%solutions during the exercises

% close all figure windows
close all;

% clear all workspace variables
clear;     

% clear command window
clc;       

%% Exercise 1

I = imread('lena.gif');
kernel = [1/9, 1/9, 1/9; 1/9, 1/9, 1/9; 1/9, 1/9, 1/9];
J_border = convolution_linda(I, kernel, 'border');
J_mirror = convolution_linda(I, kernel, 'mirror');

% show original image
figure
imagesc(I), axis equal tight off, colormap gray
title('original image')

% show convoluted image using the second border handling (border)
figure
imagesc(J_border), axis equal tight off, colormap gray
title('border')

% show convoluted image using the second border handling (border)
figure
imagesc(J_mirror), axis equal tight off, colormap gray
title('mirror')

%% Exercise 2

I = imread('lena.gif');

%a)
% sigma = 1.0
mask_2D_s1 = gauss_2D_linda(1.0);                         %generate gaussian mask
J_gauss_2D_s1 = convolution_linda(I, mask_2D_s1, 'border');

% show convoluted image using the second border handling (border)
figure
imagesc(J_gauss_2D_s1), axis equal tight off, colormap gray
title('2D gauss with sigma = 1.0')


% sigma = 3.0
mask_2D_s3 = gauss_2D_linda(3.0);                         %generate gaussian mask
J_gauss_2D_s3 = convolution_linda(I, mask_2D_s3, 'border');

% show convoluted image using the second border handling (border)
figure
imagesc(J_gauss_2D_s3), axis equal tight off, colormap gray, title('2D gauss with sigma = 3.0')

%b)
% sigma = 1.0
[mask_1D_s1_horizontal, mask_1D_s1_vertical] = gauss_1D_linda(1.0);                         %generate gaussian mask
J_gauss_1D_s1 = convolution_linda(convolution_linda(I, mask_1D_s1_horizontal, 'border'), mask_1D_s1_vertical, 'border');

% show convoluted image using the second border handling (border)
figure
imagesc(J_gauss_1D_s1), axis equal tight off, colormap gray
title('1D gauss with sigma = 1.0')

% sigma = 3.0
[mask_1D_s3_horizontal, mask_1D_s3_vertical] = gauss_1D_linda(3.0);                         %generate gaussian mask
J_gauss_1D_s3 = convolution_linda(convolution_linda(I, mask_1D_s3_horizontal, 'border'), mask_1D_s3_vertical, 'border');

% show convoluted image using the second border handling (border)
figure
imagesc(J_gauss_1D_s3), axis equal tight off, colormap gray
title('1D gauss with sigma = 3.0')

%comparison
% sigma = 1.0
diff_s1 = sum(sum((J_gauss_2D_s1 - J_gauss_1D_s1).^2));
disp(['squared difference for sigma = 1.0 is ' num2str(diff_s1)]);
% sigma = 3.0
diff_s3 = sum(sum((J_gauss_2D_s3 - J_gauss_1D_s3).^2));
disp(['squared difference for sigma = 3.0 is ' num2str(diff_s3)]);

%c)
% 1D
tic
J_gauss_1D_s3 = convolution_linda(I, mask_1D_s3_horizontal, 'border');
J_gauss_1D_s3 = convolution_linda(J_gauss_1D_s3, mask_1D_s3_vertical, 'border');
time_1D = toc;
disp(['time to process 1D two times: ' num2str(time_1D)]);

% 2D
tic
J_gauss_2D_s3 = convolution_linda(I, mask_2D_s3, 'border');
time_2D = toc;
disp(['time to process 2D: ' num2str(time_2D)]);

%% Exercise 3
%a)
Dx = [-1,0,1;-1,0,1;-1,0,1];
Dy = [-1,-1,-1;0,0,0;1,1,1];

I = imread('lena.gif');

J_Dx = convolution_linda(I, Dx, 'mirror');
J_Dy = convolution_linda(I, Dy, 'mirror');

figure
imagesc(J_Dx), axis equal tight off, colormap gray
title('convolution using Dx')

figure
imagesc(J_Dy), axis equal tight off, colormap gray
title('convolution using Dy')


