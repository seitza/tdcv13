function [ H,pe1,pe2 ] = normalized_dlt( pointset1, pointset2 )
%input: two pointsets of size(nx2 or nx3)

%check if equal number of points; n equals number of points
n=size(pointset1,1);
if(n ~= size(pointset2,1))
    return;
end

%add 3d coordinate if necessary
if(size(pointset1,2)<3)
    pe1 = [pointset1,ones(n,1)];
    pe2 = [pointset2,ones(n,1)];
else
    pe1 = pointset1;
    pe2 = pointset2;
end
%calc movement over origin
m1 = mean(pe1,1);
m2 = mean(pe2,1);

%move
pm1 = zeros(size(pe1));
pm2 = zeros(size(pe2));
for i = 1:n
    pm1(i,:) = (pe1(i,:)'-m1')';
    pm2(i,:) = (pe2(i,:)'-m2')';
end

% %add 3d coordinate
% pe1 = [pm1,ones(n,1)];
% pe2 = [pm2,ones(n,1)];

%calc normalization to mean = square2
scale1 = sqrt(2) / mean(sqrt(sum(pm1.^2,2)));
scale2 = sqrt(2) / mean(sqrt(sum(pm2.^2,2)));
if scale1 == Inf
    scale1 = 1;
end
if scale2 == Inf
    scale2 = 1;
end

% %add 3d coordinate
% pe1 = [pointset1,ones(n,1)];
% pe2 = [pointset2,ones(n,1)];

%compose transforms U and T
U=([[scale1,0,-m1(1)*scale1];[0,scale1,-m1(2)*scale1];[0,0,1]]);
T=([[scale2,0,-m2(1)*scale2];[0,scale2,-m2(2)*scale2];[0,0,1]]);

%use transforms

pe1t = (U*pe1')';
pe2t = (T*pe2')';

%basic dlt
Hb = basic_dlt(pe1t,pe2t);

%denormalize
H = inv(T)*Hb*U;
end


