% create a basic test image
I = double(imread('tire.tif'));

% create reference of original image
ref_img = imref2d(size(I));
figure;
imagesc(I); axis equal tight off, colormap gray;

% create some affine transform
theta = 0.3;
phi = -0.7;
lambdas = [1.3; 0.6];
H = create_affine_transform(theta, phi, lambdas, zeros(2,1));
tform = affine2d(H);
warped_img = imwarp(I,tform);

figure;
imagesc(warped_img); axis equal tight off, colormap gray;

% warp it back!
inv_tform = invert(tform);
restored_img = imwarp(warped_img, inv_tform, 'OutputView', ref_img);

figure;
imagesc(restored_img); axis equal tight off, colormap gray;
