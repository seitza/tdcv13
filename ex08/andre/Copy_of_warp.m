function [ W ] = warp( I, R )
% I image
% R region = 4X2 (x,y)
% W warp

MAX_DIVERGENCE = 10;

rand_rect = randi((2*MAX_DIVERGENCE)+1,4,2)-MAX_DIVERGENCE;
warp_rect = R+rand_rect;

%r,w := homogenous coordinates of input
[H,r,w] = normalized_dlt(R,warp_rect);

[x,y] = meshgrid(min(w(:,1)):max(w(:,1)),min(w(:,2)):max(w(:,2)));
in = inpolygon(x(:),y(:),[w(:,1)',w(1,1)],[w(:,2)',w(1,2)]);

%in = reshape(in,max(w(:,2))-min(w(:,2))+1,max(w(:,1))-min(w(:,1))+1);
W = zeros(max(w(:,2))-min(w(:,2))+1,max(w(:,1))-min(w(:,1))+1);

bw = [x(:),y(:),ones(size(y(:),1),1)]*inv(H)';
bw = bw./repmat(bw(:,3),1,3);
bw = round(bw);

in = in & bw(:,1)>0 & bw(:,2)>0 & bw(:,1)<size(I,2) & bw(:,2)<size(I,1);

for(i = 1:size(in,1))
    if(in(i)==1)
        W(i) = I(bw(i,2),bw(i,1));
    end
end


end

