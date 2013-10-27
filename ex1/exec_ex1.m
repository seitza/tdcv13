% close all figure windows
    close all;

% clear all workspace variables
    clear;

% clear command window
    clc; 

% Exercise 1
    % 'replicate' = set the pixels outside the image to the same intensity as the corresponding border pixel
    % 'symmetric' =  mirror the pixel intensities on the border

    I = imread('lena.gif');
    M = 1/9*[1 1 1 ;1 1 1 ; 1 1 1];
    J_replicate = generic_conv (I, M, 'replicate');
    J_symmetric = generic_conv (I, M, 'symmetric');

    % show original image
    figure
    imagesc(I), axis equal tight off, colormap gray
    title('Original image')

    % show convoluted image using the first border treatments (replicate)
    figure
    subplot(1,2,1);
    imagesc(J_replicate), axis equal tight off, colormap gray
    title('Replicate')

    % show convoluted image using the second border treatmentshandling (symmetric)
    subplot(1,2,2);
    imagesc(J_symmetric), axis equal tight off, colormap gray
    title('Symmetric')

    
    
    
% Exercise 2

    I = imread('lena.gif');
    
    %Gaussian 2D
    Gaussian_2D_sigma1 = generic_gauss_2D(1);
    Gaussian_2D_sigma3 = generic_gauss_2D(3);

    tic;
    J_Gaussian_2D_sigma1 = generic_conv(I, Gaussian_2D_sigma1, 'replicate');
    toc;
    J_Gaussian_2D_sigma3 = generic_conv(I, Gaussian_2D_sigma3, 'replicate');

    % show image using the Gaussian filter 2D for sigma = 1
    subplot(1,2,1);
    imagesc(J_Gaussian_2D_sigma1), axis equal tight off, colormap gray
    title('Gauss 2D sigma1')

    % show image using the Gaussian filter 2D for sigma = 3
    subplot(1,2,2);
    imagesc(J_Gaussian_2D_sigma3), axis equal tight off, colormap gray
    title('Gauss 2D sigma3')
    
    %Gaussian 1D
    [Gaussian_1D_sigma1_x, Gaussian_1D_sigma1_y] = generic_gauss_1D(1);
    [Gaussian_1D_sigma3_x, Gaussian_1D_sigma3_y] = generic_gauss_1D(3);
    
    tic;
    J_Gaussian_1D_sigma1 = generic_conv(generic_conv(I, Gaussian_1D_sigma1_x, 'replicate'), Gaussian_1D_sigma1_y, 'replicate');
    toc;
    J_Gaussian_1D_sigma3 = generic_conv(generic_conv(I, Gaussian_1D_sigma3_x, 'replicate'), Gaussian_1D_sigma3_y, 'replicate');
    
    % show image using the Gaussian filter 1D for sigma = 1
    figure
    subplot(1,2,1);
    imagesc(J_Gaussian_1D_sigma1), axis equal tight off, colormap gray
    title('Gauss 1D sigma1')

    % show image using the Gaussian filter 1D for sigma = 3
    subplot(1,2,2);
    imagesc(J_Gaussian_1D_sigma3), axis equal tight off, colormap gray
    title('Gauss 1D sigma3')
    
    %Compare results
    result_sigma1 = sum(sum((J_Gaussian_2D_sigma1-J_Gaussian_1D_sigma1).*(J_Gaussian_2D_sigma1-J_Gaussian_1D_sigma1)));
    disp(result_sigma1)

    result_sigma3 = sum(sum((J_Gaussian_2D_sigma3-J_Gaussian_1D_sigma3).*(J_Gaussian_2D_sigma3-J_Gaussian_1D_sigma3)));
    disp(result_sigma3)
    
    
    
    
%Exercise 3
    
    Dx = [-1 0 1; -1 0 1; -1 0 1];
    Dy = [-1 -1 -1; 0 0 0; 1 1 1];
    
    J_gradiant_image_x = generic_conv(I, Dx, 'replicate');
    J_gradiant_image_y = generic_conv(I, Dy, 'replicate');
    
    % show two gradiant images
    figure
    subplot(1,2,1);
    imagesc(J_gradiant_image_x), axis equal tight off, colormap gray
    title('Gradiant image x-direction')

    subplot(1,2,2);
    imagesc(J_gradiant_image_y), axis equal tight off, colormap gray
    title('Gradiant image y-direction')

    % show the gradiant magnitudes and orientations
    J_gradiant_image_x = double(J_gradiant_image_x);
    J_gradiant_image_y = double(J_gradiant_image_y);
    J_gradiant_magnitudes = sqrt((J_gradiant_image_x.*J_gradiant_image_x)+(J_gradiant_image_y.*J_gradiant_image_y));
    J_gradiant_orientations = atan(J_gradiant_image_y./J_gradiant_image_x);
    
    figure
    subplot(1,2,1);
    imagesc(J_gradiant_magnitudes), axis equal tight off, colormap gray
    title('Gradiant magnitudes')
    
    subplot(1,2,2);
    imagesc(J_gradiant_orientations), axis equal tight off, colormap gray
    title('Gradiant orientations')

    % show gradiant images and reduce noise
    J_gradiant_image_x_noiseless = generic_conv(I, generic_conv(Dx, Gaussian_1D_sigma1_x, 'replicate'), 'replicate');
    J_gradiant_image_y_noiseless = generic_conv(I, generic_conv(Dy, Gaussian_1D_sigma1_y, 'replicate'), 'replicate');
     
    figure
    subplot(1,2,1);
    imagesc(J_gradiant_image_x_noiseless), axis equal tight off, colormap gray
    title('Gradiant image x-direction noiseless')

    subplot(1,2,2);
    imagesc(J_gradiant_image_y_noiseless), axis equal tight off, colormap gray
    title('Gradiant image y-direction noiseless')

