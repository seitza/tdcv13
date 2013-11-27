% this function tries to find the most n robust harris points
% this is done by transforming the image by a number of affine
% transforms. for every affine transform the harris corner points
% are detected and backwarped. The backwarped points are compared
% with the harris points in the reference image and in the end
% the n harris points with the highest occurence are taken

% parameters:
% - reference image
% - number of robust points
% - number of transforms

% returns:
% a nx2 vector of the most robust corner points where
% the first column denotes the y-index, the second column the x-index