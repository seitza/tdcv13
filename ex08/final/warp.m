function [ homography, warpedRegionGrid ] = warp( region, warpedRegion, regionGrid )

[homography,~,~] = normalized_dlt(region,warpedRegion);

warpedRegionGrid = useHomography(regionGrid, homography);

end

