function [ J ] = gaussian_noise( I_in, stddev )

    I = double(I_in);
    m = mean(mean(I));
    s = size(I);
    J = zeros(s);
    for i = 1: s(1)
       for j = 1:s(2)
           J(i,j) = I(i,j) + gauss(I(i,j),m,stddev);
       end
    end

end

function[g] = gauss(z, m, stddev)
    g = 1/(stddev*sqrt(2*pi))*exp(-((z-m)^2/(2*stddev^2)));
end