function [ panoramaImg ] = blendImages( I_left_warped, I_middle, offset_l)
    %alignment of offsets
    offset_m = -offset_l;
    min_Y = offset_l(2);
    offset_l(1) = 0;
    offset_l(2) = offset_l(2) - min_Y;
    offset_m(2) = offset_m(2) + offset_l(2);

    %add left image
    [hl wl c] = size(I_left_warped);
    panoramaImg(1+offset_l(2):hl+offset_l(2),1+offset_l(1):wl+offset_l(1),:) = I_left_warped(1:hl,1:wl);
    
    %add middle image
    [hm wm c] = size(I_middle);
    panoramaImg(1+offset_m(2):hm+offset_m(2),1+offset_m(1):wm+offset_m(1),:) =I_middle(1:hm,1:wm,:);
    
end