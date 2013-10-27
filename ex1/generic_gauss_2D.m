function Gaussian_2D = generic_gauss_2D (sigma)

    %Value
    Gaussian_2D = zeros(3*sigma);
    center = ((3*sigma+1)/2);

    %Gaussian
    for i = 1:3*sigma
        for j = 1:3*sigma
            Gaussian_2D(i,j) = 1/(sqrt(2*pi*sigma^2))*exp(-0.5*((i-center)^2+(j-center)^2)/(sigma^2));
        end
    end

end
