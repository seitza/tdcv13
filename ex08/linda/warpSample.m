function [ warped_sample ] = warpSample( I, grid, H )

%     figure;
%     imagesc(I), colormap gray;
%     hold on;
%     plot([corners_shifted(:,1); corners_shifted(1,1)], [corners_shifted(:,2); corners_shifted(1,2)], 'r-');
%     plot([corners(:,1); corners(1,1)], [corners(:,2); corners(1,2)], 'b-');

%     [n,m] = size(I);
    
%     % different approach: warp the image!
%     Hinv = inv(H);
%     tform = projective2d(Hinv');
%     I_warped = imwarp(I, tform, 'FillValue', 0);
% %     figure;
%     imagesc(I_warped), colormap gray, axis equal tight;
% %     hold on;
%     [nw, mw] = size(I_warped);
%     disp([num2str(nw) ' ' num2str(mw)]);
%     
%     % move the grid to the original position in the warped image
%     % therefore, warp the corners of the image
%     img_corners = [1,1; m,1; m,n; 1,n];
%     warped_img_corners = (H\[img_corners, ones(size(img_corners,1),1)]')';
%     warped_img_corners = round(warped_img_corners ./ repmat(warped_img_corners(:,3), 1,3));
%     
%     Xtrans = min(warped_img_corners(:,1))+1;
%     Ytrans = min(warped_img_corners(:,2))+1;
% 
% %     Xtrans = max([warped_img_corners(1,1), warped_img_corners(4,1)]) - min([warped_img_corners(1,1), warped_img_corners(4,1)]);
% %     Ytrans = max([warped_img_corners(1,2), warped_img_corners(2,2)]) - min([warped_img_corners(1,2), warped_img_corners(2,2)]);
% 
%     grid(:,1) = round(grid(:,1)-Xtrans);
%     grid(:,2) = round(grid(:,2)-Ytrans);
% %     plot(grid(:,1), grid(:,2), 'gx');
% %     close all;
%     
%     % extract intensities
%     intensities = I_warped(sub2ind(size(I_warped), grid(:,2), grid(:,1)));
%     normed_intensities = normIntensities(intensities);
%     
%     warped_sample = [grid, normed_intensities];
%     
%     % add some random noise
%     warped_sample(:,3) = warped_sample(:,3) + rand(size(warped_sample(:,3)));
    
    
    
    % warp the grid
    grid_warped = (H*[grid, ones(size(grid,1),1)]')';
    grid_warped = grid_warped ./ repmat(grid_warped(:,3), 1,3);
    grid_warped = grid_warped(:,1:2);
    
    % find intensities covered by the warped grid
    % pad the image to handle out of bounds patches
%     xmin = min(grid_warped(:,1));
%     ymin = min(grid_warped(:,2));
%     xmax = max(grid_warped(:,1));
%     ymax = max(grid_warped(:,2));
%     pad = (round(min([xmin, ymin, n-xmax+1, m-ymax+1]))*-1)+1;
%     %disp(pad);
%     I_padded = I;
%     if pad > 0
%         I_padded = padarray(I, [pad, pad]);
%         ind = sub2ind(size(I_padded), grid_warped(:,2)+pad, grid_warped(:,1)+pad);
%     else
%         ind = sub2ind(size(I_padded), grid_warped(:,2), grid_warped(:,1));
%     end
%     intensities = I_padded(ind);

    intensities = interp2(1:size(I,2),1:size(I,1),I,grid_warped(:,1),grid_warped(:,2),'linear',0);  

    intensities = normIntensities(intensities);
    % add some random noise
    intensities = intensities + 0.00001*rand(size(intensities));
    
    warped_sample = [grid_warped, intensities];

end

