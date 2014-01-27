function [P,R] = track_template_color(I,T, method)
    if nargin < 3
        method = 'SSD';
    end
    
    % determine template size
    [m,n,color_depth] = size(I);
    [m_t,n_t,~] = size(T);    
    h_half_t = floor(m_t/2);
    w_half_t = floor(n_t/2);
    
    if strcmp(method, 'SSD') == 1
        R = -ones([m n]);
    else
        R = zeros([m n]);
        
        % compute mean values of all channels
        T_mean = mean(mean(T));
        T = T - repmat(T_mean, m_t, n_t, 1);
        
        % divide by std. deviation
        T = T ./ repmat(sqrt(sum(sum(T.^2))), m_t, n_t, 1);
    end
    
    switch(method)
        case 'NCC'
            for y=h_half_t+1:m-h_half_t
                for x=w_half_t+1:n-w_half_t
                    I_norm = I(y-h_half_t:y+h_half_t, x-w_half_t:x+w_half_t,:);
                    I_norm = I_norm - repmat(mean(mean(I_norm)), m_t, n_t, 1);
                    I_norm = I_norm ./ repmat(sqrt(sum(sum(I_norm.^2))), m_t, n_t, 1);
                    
                    val = zeros(color_depth,1);
                    for i=1:m_t
                        for j=1:n_t
                            for c=1:color_depth
                                val(c) = val(c) + (T(i,j,c)*I_norm(i,j,c));
                            end
                        end
                    end
                    R(y,x) = sum(val)/3;
                end
            end
            
            best_score = max(max(R));
            best_match = find(R == best_score);
            [match_y, match_x] = ind2sub(size(R), best_match);
            P = [match_x; match_y];
            
        case 'SSD'
            for y=h_half_t+1:m-h_half_t
                for x=w_half_t+1:n-w_half_t
                    val = zeros(color_depth,1);
                    for i=1:m_t
                        for j=1:n_t
                            for c=1:color_depth
                                val(c) = val(c) + (T(i,j,c) - I(y-h_half_t+i-1, x-w_half_t+j-1,c))^2;
                            end
                        end
                    end
                    R(y,x) = sum(val)/3;
                end
            end
            
            best_score = max(max(R));
            R = best_score - R;

            best_match = find(R == best_score);
            [match_y, match_x] = ind2sub(size(R), best_match);
            P = [match_x; match_y];
    end
end