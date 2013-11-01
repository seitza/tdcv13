function [ J ] = gaussian_filter_linda( I, sigma )

    [Gx, Gy] = gauss_1D_linda(sigma);
    J = convolution_linda(convolution_linda(I, Gx, 'border'), Gy, 'border');

end

