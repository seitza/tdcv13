function [training_patches, training_class_labels] = create_training_patches(img, keypoints, patch_size, angle_range, lambda_range)
    % create random affine transformation
    theta = angle_range(1) + (angle_range(2) - angle_range(1)) * rand(1);
    phi = angle_range(1) + (angle_range(2) - angle_range(1)) * rand(1);
    lambdas = lambda_range(1) + (lambda_range(2)-lambda_range(1)).*rand(2,1);

%     % dbg
%     figure();
%     imagesc(img), axis equal tight off, colormap gray;
%     hold on;
%     plot(keypoints(:,1), keypoints(:,2), 'rx', 'MarkerSize', 10);
    
    % this is taken from the paper - smoothing size is 7x7
    smoothing_kernel = 7;
    sigma = smoothing_kernel/3;
    
    % warp image
    H = create_affine_transform(theta, phi, lambdas);
    tform = affine2d(H);
    
    img_warped = imwarp(img,tform, 'FillValues', -1);
    [xlim, ylim] = outputLimits(tform,[1, size(img,2)], [1, size(img,1)]);
    
    half_patch_size = [floor(patch_size(1)/2), floor(patch_size(2)/2)];
    % pad image
    img_warped = padarray(img_warped, half_patch_size, -1);
    % add gaussian noise with mean 0 and (large) variance of 25 - described in paper
    % to warped image
    noize = imnoise(zeros(size(img_warped)), 'gaussian', 0, 25)*255;
    % replace all -1s with gaussian noise
    img_warped(img_warped == -1) = noize(img_warped == -1);
    % smooth the warped image by gaussian kernel
    img_warped = conv2(img_warped, fspecial('gaussian', smoothing_kernel, sigma), 'same');
    
    % warp the keypoints forward
    warped_keypoints = transformPointsForward(tform,keypoints);
    % ATTENTION: do NOT forget to add the padding!
    warped_keypoints(:,1) = round(warped_keypoints(:,1) - xlim(1) + 1 + half_patch_size(2));
    warped_keypoints(:,2) = round(warped_keypoints(:,2) - ylim(1) + 1 + half_patch_size(1));
    
%     % dbg
%     figure;
%     imagesc(img_warped), axis equal tight off, colormap gray;
%     hold on;
%     plot(warped_keypoints(:,1), warped_keypoints(:,2), 'gx', 'MarkerSize', 10);
    
    % create the patches for the warped keypoints
    nr_classes = size(keypoints,1);
    training_patches = zeros(patch_size(1), patch_size(1), nr_classes);
    training_class_labels = zeros(nr_classes,1);
    
    for i=1:size(warped_keypoints,1)
        x = warped_keypoints(i,1);
        y = warped_keypoints(i,2);
        
        patch = img_warped(y-half_patch_size(1):y+half_patch_size(1)-1, x-half_patch_size(2):x+half_patch_size(2)-1);
        
        training_patches(:,:,i) = patch;
        training_class_labels(i) = i;
    end
end