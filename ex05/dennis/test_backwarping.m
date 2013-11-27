I = double(imread('tire.tif'));

% create meshgrid
[meshX, meshY] = meshgrid(1:100:size(I,2), 1:100:size(I,1));
gridPoints = [meshY(:), meshX(:), ones(length(meshX(:)), 1)];

% apply some affine transformation
H = create_affine_transform(pi/4, 0.0, [1;1], [0;0]);
tform = affine2d(H);
I_warp = imwarp(I, tform);

%% plot
figure;
imagesc(I), axis equal tight off, colormap gray;
hold on;
% scatter(meshY(:), meshX(:), 25, 'rs', 'filled');
scatter(gridPoints(:,2), gridPoints(:,1), 25, 'bs', 'filled');

figure;
imagesc(I_warp), axis equal tight off, colormap gray;
hold on;
scatter(warped_grid(:,2), warped_grid(:,1), 25, 'rs', 'filled');
