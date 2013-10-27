function Img_conv = generic_conv (Image, Mask, border)
    
    %Value
    Image = double(Image);
    Mask = double (Mask);
    
    size_I = size(Image);
    size_M = size(Mask);
    half_size_M = (size_M - 1)/2;

    Img_conv = zeros(size_I);
    
    %Border
    if strcmp(border,'replicate')
        Image_Bordered = padarray(Image, [half_size_M(1) half_size_M(2)], 'replicate', 'both');
    end
    if strcmp(border,'symmetric')
        Image_Bordered = padarray(Image, [half_size_M(1) half_size_M(2)], 'symmetric', 'both');
    end
     
    
    %Convolution
    for i = 1:size_I(1)
        for j = 1:size_I(2)          
            Img_conv (i,j) = sum(sum(Image_Bordered(i:i+2*half_size_M(1), j:j+2*half_size_M(2)).*Mask)); 
        end
    end
    
    Img_conv = uint8(Img_conv);
end
    
    
    
    
   
