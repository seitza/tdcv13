function [ J ] = mean_filter( I, size_m, border_treatment )

    if nargin ~= 3
        % nothing specified fill with zeros - same behavior as conv2
        border_treatment = 0;
    else
        switch border_treatment
            case 'mirror'
                border_treatment = 'symmetric';
            case 'border'
                border_treatment = 'replicate';
            otherwise
                fprintf('Do not know border treatment %s - assuming "border"\n', border_treatment);
                border_treatment = 'replicate';
        end
    end
    
    % get half size of area to calculate median from
    m = floor(size_m/2);
    
    %pad image
    I_pad = padarray(I,m,border_treatment);
    
    % get size of input image
    s = size(I_pad);
    a = s(1);
    b = s(2);

    % create empty output image
    J = zeros(size(I));

    % now loop over image and calculate median
    for i = m(1)+1:a-m(1)
        for j = m(2)+1:b-m(2)
            %I_pad(i-m(1):i+m(1),j-m(2):j+m(2))
            J(i-m(1),j-m(2)) = median(reshape(I_pad(i-m(1):i+m(1),j-m(2):j+m(2)),1,size_m(1)*size_m(2)));
            
        end
    end

end

