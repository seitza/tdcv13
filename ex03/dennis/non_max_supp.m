function S = non_max_supp(I, w)
    half_w = [floor(w(1)/2), floor(w(2)/2)];
    I_padded = padarray(I,half_w, 'replicate');
    S = I;
    
    for i=1:size(S,1)
        for j=1:size(S,2)
            for p=1:w(1)
                for q=1:w(2)
                    if p-(half_w(1)+1) == 0 && ...
                            q-(half_w(2)+1) == 0
                        continue;
                    elseif I_padded(i+p-1, j+q-1) >= S(i,j)
                        S(i,j) = 0;
                        break;
                    end
                end
            end
        end
    end
end