function [ W ] = warp( I, R, wR, GD )
% I image
% R region = 4X2 (x,y)
% W warp
% MD maximum divergence
% GD grid distance of points

%s = size(I);

%r,w := homogenous coordinates of input
%disp(R);
%disp(wR);
[H,r,wr] = normalized_dlt(R,wR);

[x,y] = meshgrid(min(r(:,1)):GD:max(r(:,1)),min(r(:,2)):GD:max(r(:,2)));
%in = inpolygon(x(:),y(:),[w(:,1)',w(1,1)],[w(:,2)',w(1,2)]);

bw = [x(:),y(:),ones(size(y(:),1),1)]*inv(H)';
bw = bw./repmat(bw(:,3),1,3);
%bw = round(bw(:,1:2));

%get out of bounds backwarps
%oob = sum(bw > repmat([s(2),s(1)],size(bw,1),1),2)>0 | sum(bw < 1,2)>0;
%preserve out of bounds backwarps from failing hard
%bw(oob,:) = repmat([1,1],size(bw(oob),1),1);

%ind = sub2ind(size(I),bw(:,2),bw(:,1));
%testW = I(ind);
W = interp2(1:size(I,2),1:size(I,1),I,bw(:,1),bw(:,2),'linear',0);  

W = (W-mean(W))/std(W);
W = W+rand(size(W));

%rewrite preserved out of bound entries to random
%W(oob) = rand(size(W(oob)));

end

