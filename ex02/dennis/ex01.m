clear all;
close all;
clc;

sigma = 10.0;
I = double(imread('lena.gif'));

%% corrupting images
I_sp = gen_noise(I,'salt-and-pepper');
I_gauss = gen_noise(I,'gaussian',sigma);

H_gauss = fspecial('gaussian',[3 3], sigma);

%% filtering
I_gauss_median_filt = median_filter(I_gauss, [3 3]);
I_sp_median_filt = median_filter(I_sp, [3 3]);

I_gauss_gauss_filt = imfilter(I_gauss, H_gauss, 'replicate');
I_sp_gauss_filt = imfilter(I_sp, H_gauss, 'replicate');

%% plotting
figure('Name', 'Corrupted Images', 'NumberTitle', 'Off')
subplot(1,2,1);
imagesc(I_gauss), axis equal tight off, colormap gray
title(sprintf('Gaussian noise with sigma = %d', sigma));

subplot(1,2,2);
imagesc(I_sp), axis equal tight off, colormap gray
title('Salt and pepper noise');

figure('Name', 'Filtering with gauss filter', 'NumberTitle', 'Off')
subplot(1,2,1);
imagesc(I_gauss_gauss_filt), axis equal tight off, colormap gray
title('Gaussian noise');

subplot(1,2,2);
imagesc(I_sp_gauss_filt), axis equal tight off, colormap gray
title('Salt and pepper noise');

figure('Name', 'Filtering with median filter', 'NumberTitle', 'Off')
subplot(1,2,1);
imagesc(I_gauss_median_filt), axis equal tight off, colormap gray
title('Gaussian noise');

subplot(1,2,2);
imagesc(I_sp_median_filt), axis equal tight off, colormap gray
title('Salt and pepper noise');
