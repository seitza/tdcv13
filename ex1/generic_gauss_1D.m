function [ Gaussian_1D_i, Gaussian_1D_j ] = generic_gauss_1D (sigma)

    %Value
    Gaussian_1D_i = zeros(1,3*sigma);
    Gaussian_1D_j = zeros(3*sigma,1);
    center = ((3*sigma+1)/2);

    %Gaussian
    for k = 1:3*sigma
     Gaussian_1D_i(1,k) = 1/(sqrt(2*pi*sigma^2))*exp(-0.5*((k-center)^2)/(sigma^2));
     Gaussian_1D_j(k,1) = 1/(sqrt(2*pi*sigma^2))*exp(-0.5*((k-center)^2)/(sigma^2));
    end
    
end
