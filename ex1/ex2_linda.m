close all;
clear;
clc;

%% a)
I = imread('lena.gif');
I_double = double(I)/255;

mask_2D_s1 = gauss_2D_linda(1.0);
mask_2D_s3 = gauss_2D_linda(3.0);

J_gauss_2D_s1 = convolution_linda(I_double, mask_2D_s1, 'mirror');
tic
J_gauss_2D_s3 = convolution_linda(I_double, mask_2D_s3, 'mirror');
time_2D_s3 = toc;

%% b)
[mask_1D_s1_horizontal, mask_1D_s1_vertical] = gauss_1D_linda(1.0);
[mask_1D_s3_horizontal, mask_1D_s3_vertical] = gauss_1D_linda(3.0);

J_gauss_1D_s1 = convolution_linda(convolution_linda(I_double, mask_1D_s1_horizontal, 'mirror'),mask_1D_s1_vertical, 'mirror');
tic
J_gauss_1D_s3 = convolution_linda(convolution_linda(I_double, mask_1D_s3_horizontal, 'mirror'),mask_1D_s3_vertical, 'mirror');
time_1D_s3 = toc;

%comparison
% sigma = 1.0
diff_s1 = sum(sum((J_gauss_2D_s1 - J_gauss_1D_s1).^2));
disp(['squared difference for sigma = 1.0 is ' num2str(diff_s1)]);

% sigma = 3.0
diff_s3 = sum(sum((J_gauss_2D_s3 - J_gauss_1D_s3).^2));
disp(['squared difference for sigma = 3.0 is ' num2str(diff_s3)]);