function [ O ] = grad_response( I, TAU)
[ix,iy] = gradient(I);
mag = sqrt(ix.^2 + iy.^2);
dir = atan2(iy,ix);

[~,M] = max(mag,[],3);
[m1,m2] = meshgrid(1:size(M,2),1:size(M,1));
mag = reshape(mag(sub2ind(size(mag),m2(:),m1(:),M(:))),size(I,1),size(I,2));
O = reshape(dir(sub2ind(size(dir),m2(:),m1(:),M(:))),size(I,1),size(I,2));
O(mag<=TAU) = 0;
end

