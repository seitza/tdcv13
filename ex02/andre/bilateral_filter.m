function [ J ] = bilateral_filter( I_in, sigma_domain, sigma_range )

I_d = double(I_in);
J = zeros(size(I_d));
[kernelsize_y,kernelsize_x] = size(zeros(3*max(sigma_domain,sigma_range)));
half_kernelsize_y = floor(kernelsize_y/2);
half_kernelsize_x = floor(kernelsize_x/2);
I = padarray(I_d,[half_kernelsize_y,half_kernelsize_x]);
[padsize_y,padsize_x] = size(I);

for i = half_kernelsize_y+1:padsize_y-half_kernelsize_y
    for j = half_kernelsize_x+1:padsize_x-half_kernelsize_x
        n = 0;
        t = 0;
        for m = -half_kernelsize_y:half_kernelsize_y
            for n = -half_kernelsize_x:half_kernelsize_x
                distance = sqrt(sum(([i+m j+n] - [i j]) .^ 2));
                closeness = exp(-0.5*(distance/sigma_range)^2);
                delta = I(i+m,j+n)-I(i,j);
                similarity = exp(-0.5*(delta/sigma_domain)^2);
                t = t + I(i+m,j+n)*closeness*similarity;
                n = n + closeness*similarity;
            end
        end
        J(i-half_kernelsize_y,j-half_kernelsize_x) = t/n;
    end
end


end

