function [ J ] = convolution( I, kernel, border )
% I --> image that should be changed
% kernel --> matrix for convolution
% border --> treatment of the border: either mirroring ('mirror') or same as
% corresponding border pixels ('border')

    % transpose kernel
    kernel = kernel.';

    size_I = size(I);
    size_kernel = size(kernel);
    
    J = zeros(size_I);
    
    % run through the image
    for i=1:size_I(1)
        for j=1:size_I(2)
            % run through the kernel
            for m = 1:size_kernel(1)
                m_I = m-(size_kernel(1)-1)/2;
                for n = 1:size_kernel(2)
                    n_I = n-(size_kernel(2)-1)/2;
                    if i+m_I < 1 && j+n_I < 1       % upper left corner
                        if strcmp(border,'mirror')
                            J(i,j) = J(i,j) + I((i+m_I)*(-1)+1,(j+n_I)*(-1)+1)*kernel(m,n);
                        else
                            J(i,j) = J(i,j) + I(1,1)*kernel(m,n);
                        end
                    elseif i+m_I < 1 && j+n_I > size_I(2)   % upper right corner
                        if strcmp(border,'mirror')
                            J(i,j) = J(i,j) + I((i+m_I)*(-1)+1,2*size_I(2)-(j+n_I)+1)*kernel(m,n);
                        else
                            J(i,j) = J(i,j) + I(1,size_I(2))*kernel(m,n);
                        end
                    elseif i+m_I > size_I(1) && j+n_I > size_I(2)   % bottom right corner
                        if strcmp(border,'mirror')
                            J(i,j) = J(i,j) + I(2*size_I(1)-(i+m_I)+1,2*size_I(2)-(j+n_I)+1)*kernel(m,n);
                        else
                            J(i,j) = J(i,j) + I(size_I(1),size_I(2))*kernel(m,n);
                        end
                    elseif i+m_I > size_I(1) && j+n_I < 1   % bottom left corner
                        if strcmp(border,'mirror')
                            J(i,j) = J(i,j) + I(2*size_I(1)-(i+m_I)+1,(j+n_I)*(-1)+1)*kernel(m,n);
                        else
                            J(i,j) = J(i,j) + I(size_I(1),1)*kernel(m,n);
                        end
                    elseif i+m_I < 1    % up
                        if strcmp(border,'mirror')
                            J(i,j) = J(i,j) + I((i+m_I)*(-1)+1,j+n_I)*kernel(m,n);
                        else
                            J(i,j) = J(i,j) + I(1,j+n_I)*kernel(m,n);
                        end
                    elseif i+m_I > size_I(1)  % down
                        if strcmp(border,'mirror')
                            J(i,j) = J(i,j) + I(2*size_I(1)-(i+m_I)+1,j+n_I)*kernel(m,n);
                        else
                            J(i,j) = J(i,j) + I(size_I(1),j+n_I)*kernel(m,n);
                        end
                    elseif j+n_I < 1    %left
                        if strcmp(border,'mirror')
                            J(i,j) = J(i,j) + I(i+m_I,(j+n_I)*(-1)+1)*kernel(m,n);
                        else
                            J(i,j) = J(i,j) + I(i+m_I,1)*kernel(m,n);
                        end
                    elseif j+n_I > size_I(2)    % right
                        if strcmp(border,'mirror')
                            J(i,j) = J(i,j) + I(i+m_I,2*size_I(2)-(j+n_I)+1)*kernel(m,n);
                        else
                            J(i,j) = J(i,j) + I(i+m_I,size_I(2))*kernel(m,n);
                        end
                    else
                        J(i,j) = J(i,j) + I(i+m_I,j+n_I)*kernel(m,n);
                    end
                end
            end
        end
    end
end

