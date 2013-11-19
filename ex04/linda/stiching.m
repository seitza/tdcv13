function [ stitched_image ] = stiching( im1, im2 )

    % compute interes points
    descr1 = vl_sift(im1);
    descr2 = vl_sift(im2);

    % find matching interes points
    matches = vl_ubcmatch(descr1, descr2);
    %ipoints1 = [descr1(2, matches(1,:)); descr1(1, matches(1,:))]';
    ipoints1 = (descr1(1:2,matches(1,:)))';
    %ipoints2 = [descr2(2, matches(2,:)); descr2(1, matches(2,:))]';
    ipoints2 = (descr2(1:2,matches(2,:)))';
    
    % compute homography
    H = ransac(ipoints1, ipoints2, 4, 15, 0.5, 50);
        
    % compute new coordinates
    trans_image = im1;
    orig_image = im2;
    new_coords_trans = zeros(size(trans_image, 1), size(trans_image, 2), 2);
    new_coords_orig = zeros(size(orig_image, 1), size(orig_image, 1), 2);
    for i = 1:size(trans_image,1)
        for j = 1:size(trans_image,2)
            t = H*[i; j; 1];
            t = t ./ t(3);
            new_coords_trans(i,j,1) = t(1);    % store new rows
            new_coords_trans(i,j,2) = t(2);    % store new cols
        end
    end
    for i = 1:size(orig_image,1)
        for j = 1:size(orig_image,2)
            new_coords_orig(i,j,1) = i;
            new_coords_orig(i,j,2) = j;
        end
    end
    
    new_coords_trans = round(new_coords_trans);
    
    % find mimimum
    rows_min_new = min(min(new_coords_trans(:,:,1)));
    rows_global_min = min(rows_min_new, 1);
    cols_min_new = min(min(new_coords_trans(:,:,2)));
    cols_global_min = min(cols_min_new, 1);
    % add absolute minimum values to the coordinates
    new_coords_orig(:,:,1) = new_coords_orig(:,:,1) - rows_global_min + 1;
    new_coords_orig(:,:,2) = new_coords_orig(:,:,2) - cols_global_min + 1;
    new_coords_trans(:,:,1) = new_coords_trans(:,:,1) - rows_global_min + 1;
    new_coords_trans(:,:,2) = new_coords_trans(:,:,2) - cols_global_min + 1;
    % compute maximum to know how big the stitched image has to be
    rows_max_new = max(max(new_coords_trans(:,:,1)));
    rows_global_max = max(rows_max_new, size(orig_image,1));
    cols_max_new = max(max(new_coords_trans(:,:,2)));
    cols_global_max = max(cols_max_new, size(orig_image,2));

    % stitch the images together
    stitched_image = zeros(rows_global_max, cols_global_max);
    
    % trans_image coordinates
    for i = 1:size(trans_image, 1)
        for j = 1:size(trans_image, 2)
%             disp('###################################');
%             disp(new_coords_trans(i,j,1));
%             disp(new_coords_trans(i,j,2));
            stitched_image(new_coords_trans(i,j,1), new_coords_trans(i,j,2)) = trans_image(i,j);
        end
    end
    % orig_image coordinates
    for i = 1:size(orig_image, 1)
        for j = 1:size(orig_image, 2)
            stitched_image(new_coords_orig(i,j,1), new_coords_orig(i,j,2)) = orig_image(i,j);
        end
    end
    
end

