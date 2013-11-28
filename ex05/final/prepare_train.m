function [ classes,patches ] = prepare_train( im, patchsize )
%image as grayscale, double
%patchsize scalar defining nxn patches around 

if mod(patchsize,2)~=1
   patchsize=patchsize+1; 
end

points = corner(im);
half = floor(patchsize/2);

points = points(points(:,1)-half>=1&points(:,1)+half<=size(im,1)&points(:,2)-half>=1&points(:,2)+half<=size(im,2),:); 

classes = 1:size(points,1);
patches = zeros(size(points,1),patchsize,patchsize);

for i=1:size(points,1);
    patches(i,:,:) = im(points(i,1)-half:points(i,1)+half,points(i,2)-half:points(i,2)+half);
end

end

