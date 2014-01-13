function [ W ] = warp( I, R, warp_rect, MD, GD )
% I image
% R region = 4X2 (x,y)
% W warp
% MD maximum divergence
% GD grid distance of points

s = size(I);

%r,w := homogenous coordinates of input
[H,r,w] = normalized_dlt(R,warp_rect);

[x,y] = meshgrid(min(r(:,1)):GD:max(r(:,1)),min(r(:,2)):GD:max(r(:,2)));
%in = inpolygon(x(:),y(:),[w(:,1)',w(1,1)],[w(:,2)',w(1,2)]);

bw = [x(:),y(:),ones(size(y(:),1),1)]*H';
bw = bw./repmat(bw(:,3),1,3);
bw = round(bw);

p = min(min(min(bw)),min([s(2),s(1),1]-max(bw)))*-1;
p = p+1;
I = padarray(I,[p,p],0);
bw= bw+p;

if p > 1
   disp([p size(I) min(bw) max(bw)]); 
end
ind = sub2ind(size(I),bw(:,2),bw(:,1));

W = I(ind);
W = (W-mean(W))/std(W);

%TODO randomization missing!!
end

