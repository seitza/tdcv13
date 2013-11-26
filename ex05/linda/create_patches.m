function [ patches, classes ] = create_patches( I, keypoints, patch_size )
    % create patches for one warped image
    
    half_patch_size = (patch_size-1)/2;
    
    patches = zeros(patch_size, patch_size, size(keypoints,1));    % matrix including
                                                                   % stacked patches
    % transform the image randomly
    T = create_affine_transformation();
    %T = [0.9848, -0.1736, 0; 0.1736, 0.9848, 0; 0,0,1];
    tform = affine2d(T);
    I_warped = imwarp(I, tform, 'FillValues', -1);
    I_warped = padarray(I_warped, [half_patch_size, half_patch_size], -1);
    noise = round(imnoise(zeros(size(I_warped)), 'gaussian')*2*255);
    I_warped(I_warped(:)==-1) = noise(I_warped(:)==-1);
    
    % warp keypoints
    keypoints_warp = transformPointsForward(tform, keypoints);
    % transform warped keypoints in the new coordinate system
    [x_out, y_out] = outputLimits(tform, [1, size(I, 2)], [1, size(I, 1)]);
    keypoints_warp_trans = round([keypoints_warp(:,1)-x_out(1)+1, keypoints_warp(:,2)-y_out(1)+1]);
    
%     figure;
%     imagesc(I_warped), colormap gray, axis equal tight off;
%     hold on;
%     scatter(keypoints_warp_trans(:,1), keypoints_warp_trans(:,2), 'Xr');

    % run pver each keypoint and create the correlated patch
    for i = 1:size(keypoints, 1)
        if (keypoints_warp_trans(i, 2) > 0 && keypoints_warp_trans(i, 1) > 0 && keypoints_warp_trans(i, 2)+2*half_patch_size <= size(I_warped,1) && keypoints_warp_trans(i, 1)+2*half_patch_size <= size(I_warped,2))
            patches(:,:,i) = I_warped(keypoints_warp_trans(i, 2):keypoints_warp_trans(i, 2)+2*half_patch_size, keypoints_warp_trans(i, 1):keypoints_warp_trans(i, 1)+2*half_patch_size);
%             imagesc(patches(:,:,i)), colormap gray, axis equal tight off;
%             drawnow;
        end
    end
    
    classes = 1:1:size(keypoints,1);
end

