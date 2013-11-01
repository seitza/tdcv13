function I = gen_noise(I,type,sigma)
    [m,n] = size(I);
     
    switch type
        case 'gaussian'
            if nargin < 3
                disp('Standard deviation sigma for the gaussian noise was not specified - aborting')
            end
            gaussian_noise = randn(m,n).*sigma;
            I = I + gaussian_noise;
            % do not exceed limits
            I(I < 0) = 0;
            I(I > 255) = 255;
        case 'salt-and-pepper'
            salt_pepper = randi([0,255],m,n);
            I(salt_pepper==0) = 0;
            I(salt_pepper==255) = 255;
    end
end

