function [ H ] = basic_dlt( pointset1, pointset2 )
%input: two pointsets of size (nx3); if only 2D, set z-axis == 1

%check if equal number of points; n equals number of points
n=size(pointset1,1);
if(n ~= size(pointset2,1))
    return;
end

%init cell containing all A_i
Ai = cell(n,1);
A = zeros(2*n,9);
for i = 1:n
    
    %assign matrix A_i (2x9) to cell container just for debugging
    %skip last line [(-pointset2(i,2))*pointset1(i,:),pointset2(i,1)*pointset1(i,:),0,0,0]
    Ai{i} = [[0,0,0,(-pointset2(i,3))*pointset1(i,:),pointset2(i,2)*pointset1(i,:)];
            [pointset2(i,3)*pointset1(i,:),0,0,0,(-pointset2(i,1))*pointset1(i,:)]];

    %assemble big (2nx9) matrix
    A(2*i-1:2*i,:) = Ai{i};
end

%obtain svd of A
[U,S,V] = svd(A);

%get lowest singular value position and obtain h
%lowest = min(size(A));
h = V(:,9);

%reshape h to H
H=reshape(h,3,3)';
end

