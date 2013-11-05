function [ J ] = bilateral_filter( I_in, sigma_domain, sigma_range )

%just some note here^
I_d = double(I_in);
J = zeros(size(I_d));
[kernelsize_y,kernelsize_x] = size(zeros(3*max(sigma_domain,sigma_range)));
half_kernelsize_y = floor(kernelsize_y/2);
half_kernelsize_x = floor(kernelsize_x/2);
I = padarray(I_d,[half_kernelsize_y,half_kernelsize_x],'replicate');
[padsize_y,padsize_x] = size(I);

for i = half_kernelsize_y+1:padsize_y-half_kernelsize_y
    for j = half_kernelsize_x+1:padsize_x-half_kernelsize_x
        normalize = 0;
        for m = -half_kernelsize_y:half_kernelsize_y
            for n = -half_kernelsize_x:half_kernelsize_x
                distance = sqrt(m^2+n^2);
                closeness = exp(-0.5*((distance/sigma_domain)^2));
                delta = abs(I(i+m,j+n)-I(i,j));
                similarity = exp(-0.5*((delta/sigma_range)^2));
                J(i-half_kernelsize_y,j-half_kernelsize_x) = J(i-half_kernelsize_y,j-half_kernelsize_x) + (I(i+m,j+n)*closeness*similarity);
                normalize = normalize + (closeness*similarity);
            end
        end
        J(i-half_kernelsize_y,j-half_kernelsize_x) = J(i-half_kernelsize_y,j-half_kernelsize_x)/normalize;
    end
end


end

