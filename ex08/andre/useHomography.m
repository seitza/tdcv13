function [ warpedRegionGrid ] = useHomography( regionGrid, homography )

warpedRegionGrid = [regionGrid(:,1),regionGrid(:,2),ones(size(regionGrid,1),1)]*homography';
warpedRegionGrid = warpedRegionGrid./repmat(warpedRegionGrid(:,3),1,3);
warpedRegionGrid = warpedRegionGrid(:,1:2);

end

