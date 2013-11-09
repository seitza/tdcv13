function [ J ] = harris_laplace( I, res_level, s0, k, alpha, th, tl )
% res_level - resolution level
% s0 - initial scale
% k - factor between two levels of resolution
% alpha
% th - threshold for harris detector
% tl - threshold for laplace detector

    harris = zeros(size(I), res_level);

    for i = 1:res_level
        harris(:,:,i) = harris_detector(I, n, s0, k, alpha, t);
    end


end

