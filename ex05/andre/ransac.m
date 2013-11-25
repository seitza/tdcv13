function [ dts_max, S1i_max, S2i_max, H ] = ransac( S1, S2, t, T, s, N )
%input:
%S1,S2 set of associated points (nx3)
%s number of randomly drawn points
%t distance Threshold
%T threshold for inliers in random set to terminate ransac
%N max number of iterations
%ouput:
%Si Set of inliers which is maximized according to distance
%Hm model

adaptive = 0;

if nargin < 6
    if nargin < 4
        return
    end
    s=1;
    e=1;
    p=0.99;
    N=Inf;
    adaptive = 1;
end

sizeS=size(S1,1);
if(sizeS ~= size(S2,1))
    return;
end

%extend from 2D to 3D coordinates
if(size(S1,2)<3)
    S1 = [S1,ones(sizeS,1)];
    S2 = [S2,ones(sizeS,1)];
end

S1i_max = [];
S2i_max = [];

n=1;

while n <= N && not(adaptive) || N > s && adaptive

%select 4 random sample indices
if s > sizeS
    %unexpected
    return;
end

%draw random sample of size s
is = randsample(sizeS,s);

%compute H as init model
[H,Se1,Se2] = normalized_dlt(S1(is,:),S2(is,:));

%compute putatitve correspondences
S1p = S1*H';
S1pn = S1p./repmat(S1p(:,3),1,3);

%compute distances
ds = sqrt(sum(((S2-S1pn).^2),2));

%check for distance threshold t
%get indices of Si
dts = find(ds<t);

%define Si (set of inliers of random sample)
S1i = S1(dts,:);
S2i = S2(dts,:);

%check wether ransac can be stopped, as the number of distances below
%threshold T is reached
if size(dts,1) > T
    dts_max = dts;
    S1i_max = S1i;
    S2i_max = S2i;
    H = normalized_dlt(S1i_max,S2i_max);
    return;
end %if size(dts) > T

if size(dts,1) > size(S1i_max,1)
    dts_max = dts;
    S1i_max = S1i;
    S2i_max = S2i;
end %if size(dts) > size(S1i_max)

if adaptive
    e = 1-(size(dts,1)/sizeS);
    N = log(1-p)/log(1-(1-e)^s);
    s = s+1;
else
   n = n+1; 
end
end %while

H = normalized_dlt(S1i_max,S2i_max);

end %function

