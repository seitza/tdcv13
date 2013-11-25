function [ patches, classes ] = create_patches( I, keypoints, patch_size )
    % create patches for one warped image
    
    half_patch_size = (patch_size-1)/2;
    rowsI = size(I,1);
    colsI = size(I,2);
    
    patches = zeros(patch_size, patch_size, size(keypoints,1));    % matrix including
                                                                   % stacked patches
    % transform the image randomly
    %T = create_affine_transformation();
    T = [0.9848, -0.1736, 0; 0.1736, 0.9848, 0; 0,0,1];
    tform = affine2d(T);
    I_warped = imwarp(I, tform);
    % transform keypoints in the new coordinate system
    [x_out, y_out] = outputLimits(tform, [1, size(I, 2)], [1, size(I, 1)]);
    keypoints_trans = [keypoints(:,1)+x_out(1)-1, keypoints(:,2)+y_out(1)-1];
    % warp transformed keypoints
    keypoints_trans_warp = round(transformPointsForward(tform, keypoints_trans));
    
    figure;
    imagesc(I_warped), colormap gray, axis equal tight off;
    hold on;
    scatter(keypoints_trans_warp(:,1), keypoints_trans_warp(:,2), 'Xr');
                                              
                                                                   
    for i = 1:size(keypoints, 1)
        if keypoints(i,1)-half_patch_size > 0 && keypoints(i,1)+half_patch_size <= rowsI && keypoints(i,2)-half_patch_size > 0 && keypoints(i,2)+half_patch_size < colsI
            patches(:,:,i) = I(keypoints(i, 1)-half_patch_size:keypoints(i, 1)+half_patch_size,keypoints(i, 2)-half_patch_size:keypoints(i, 2)+half_patch_size);
            number_good_patches = number_good_patches +1;
        end
    end
    
    patches = patches(:,:,1:number_good_patches);
    classes = 1:1:size(patches, 3);
end

