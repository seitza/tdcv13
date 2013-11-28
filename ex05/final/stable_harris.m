function [ res ] = stable_harris( I, n_rand, n_thres)
%n_rand = number of random drwas

%distance threshold after backwarping
%should maybe be paramterized
dt = 2;

orig = corner(I,intmax); %XY
counts = zeros(size(orig,1),1);

%transforms = cell(1,n_rand);
for i = 1:n_rand
    random = rand(4,1);
    random = random.*[360;360;0.9;0.9]+[0;0;0.6;0.6];
    
    H = gen_transform(random(1),random(2),random(3),random(4)); 
    
    %just for DEBUG
    %H = gen_transform(10,1,1,1); 
    
    tform = affine2d(H);
    iform = invert(tform);
    T = imwarp(I,tform);
    %W = imwarp(T,iform); %just for DEBUG
    %figure;
    %imagesc(T), colormap gray, axis equal tight;
    tcorner = corner(T,intmax); % XY
    
    [xlim,ylim] = outputLimits(tform, [0 size(I,2)], [0 size(I,1)]);
    tcorner = tcorner+repmat([xlim(1),ylim(1)],size(tcorner,1),1); %XY
    
    points = round(transformPointsForward(iform,tcorner));%XY
    
    %filter rounding errors and rearrange points to row-column index
    p=points(points(:,1)<=size(I,2)&points(:,2)<=size(I,1)&points(:,1)>0&points(:,2)>0,:);
    p=p(:,[2,1]);%YX
    
    %prepare binary matrix for neighborhood comparison
    %maybe cont distance should be used
    bin = zeros(size(I));
    bin(sub2ind(size(bin),p(:,1),p(:,2))) = 1; %needs(size, I,J) == YX
    bin = padarray(bin, [dt,dt]);
    for w = 1:size(orig,1)
        counts(w)=counts(w)+(sum(sum(bin(orig(w,2)+dt-dt:orig(w,2)+dt+dt,orig(w,1)+dt-dt:orig(w,1)+dt+dt)))>0);
    end
end

%get the entries of original corners that have maximum count
%maybe change to threshold or quantile if only few or one point is returned
res = orig(counts(:)>=n_thres,:);%XY

