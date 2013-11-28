function [ keypoints, patches ] = create_classify_patches( I, patch_size )
    
    % find harris points
    %keypoints = corner(I, intmax);
    keypoints = robust_harris(I, 10, 10);
    % pad image and add noise
    half_patch_size = (patch_size-1)/2;
    I = padarray(I, [half_patch_size, half_patch_size], -1);
    noise = round(imnoise(zeros(size(I)), 'gaussian')*2*255);
    I(I(:)==-1) = noise(I(:)==-1);
    % create patches
    patches = zeros(patch_size, patch_size, size(keypoints, 1));
    for i = 1:size(keypoints, 1)
        if (keypoints(i, 2) > 0 && keypoints(i, 1) > 0 && keypoints(i, 2)+2*half_patch_size <= size(I,1) && keypoints(i, 1)+2*half_patch_size <= size(I,2))
            patches(:,:,i) = I(keypoints(i, 2):keypoints(i, 2)+2*half_patch_size, keypoints(i, 1):keypoints(i, 1)+2*half_patch_size);
        end
    end
    
end

