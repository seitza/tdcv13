function [ R ] = non_max_supp_linda(R, neighbour_size)
%NON_MAX_SUPP_LINDA Summary of this function goes here
%   Detailed explanation goes here
    half_size = (neighbor_size-1)/2;
    
    for i = half_size+1:size(R,1)-half_size
        for j = half_size+1:size(R,2)-half_size
            for m = i-half_size:i+half_size
                for n = j-half_size:j+half_size
                    if i == m && j == n
                        continue;
                    elseif R(m,n) >= R(i,j)
                        R(i,j) = 0;
                    end
                end
            end
        end
    end
end

