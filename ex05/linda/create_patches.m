function [ patches, classes ] = create_patches( I, keypoints, patch_size )
    % finds the corners in an image and creates patches in this basis
    
    half_patch_size = (patch_size-1)/2;
    rowsI = size(I,1);
    colsI = size(I,2);
    
    patches = zeros(patch_size, patch_size, size(keypoints,1));    % matrix including
                    % stacked patches
    
    number_good_patches = 0;    % number of patches that allow a rectangle around them
    for i = 1:size(keypoints, 1)
        if keypoints(i,1)-half_patch_size > 0 && keypoints(i,1)+half_patch_size <= rowsI && keypoints(i,2)-half_patch_size > 0 && keypoints(i,2)+half_patch_size < colsI
            patches(:,:,i) = I(keypoints(i, 1)-half_patch_size:keypoints(i, 1)+half_patch_size,keypoints(i, 2)-half_patch_size:keypoints(i, 2)+half_patch_size);
            number_good_patches = number_good_patches +1;
        end
    end
    
    patches = patches(:,:,1:number_good_patches);
    classes = 1:1:size(patches, 3);
end

