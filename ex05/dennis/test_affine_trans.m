% create a basic test image
% I = double(imread('tire.tif'));
I = zeros(50,50);

% these are our harris points ;-)
I(20,20) = 1;
I(30,30) = 1;
I(50,10) = 1;

harris_pts_y = [20, 30, 50]';
harris_pts_x = [20, 30, 10]';

% create reference of original image
ref_img = imref2d(size(I));
figure;
imagesc(I); axis equal tight off, colormap gray;

% create some rectangle
I(100,100) = 1;

% create some affine transform
theta = 0.3;
phi = -0.7;
lambdas = [1.3; 0.6];
H = create_affine_transform(theta, phi, lambdas, zeros(2,1));
tform = affine2d(H);
warped_img = imwarp(I,tform);

% transform points forward
[trans_y, trans_x] = transformPointsForward(tform, harris_pts_x, harris_pts_y);
disp(trans_x);
disp(trans_y);

figure;
imagesc(warped_img); axis equal tight off, colormap gray;

% warp it back!
inv_tform = invert(tform);
[back_y, back_x] = transformPointsForward(inv_tform, trans_x, trans_y);
disp(back_x);
disp(back_y);

restored_img = imwarp(warped_img, inv_tform, 'OutputView', ref_img);

figure;
imagesc(restored_img); axis equal tight off, colormap gray;
