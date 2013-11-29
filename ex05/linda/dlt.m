function [ H ] = dlt( coords_reference, coords_warped )
% coordinates as n x 3 matrices, where each line corresponds to one point
% (x,y, z) with z = 1 and the number of lines is >= 4

    n = size(coords_reference,1);   % number of points
    
    % compute A
    A = zeros(n*2, 9);
    j = 1;
    for i = 1:n
        A(j:j+1,:) = [0,0,0, -1.*coords_reference(i,:), coords_warped(i,2).*coords_reference(i,:);
            coords_reference(i,:), 0,0,0, -coords_warped(i,1).*coords_reference(i,:)];
        j = j+2;
    end

    [U,S,V] = svd(A);
%    h = V(:,min(size(S,1), size(S,2))); % take column of V corresonding to the column with the smallest singular value
    h = V(:,9);
    H = reshape(h,3,3)';
end

