function [ J ] = gaussian_noise( I, sigma )

    J = double(I) + sigma.*randn(size(I));

end