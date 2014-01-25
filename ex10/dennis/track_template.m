function [P,R] = track_template(I,T, method)
    if nargin < 3
        method = 'SSD';
    end
    
    % determine template size
    [m,n] = size(I);
    
    if strcmp(method, 'SSD') == 1
        R = -ones([m n]);
    else
        R = zeros([m n]);
        % compute mean values of 
        T_mean = mean(mean(T));
        T = T - T_mean;
        
        % divide by std. deviation
        T = T / sqrt(sum(sum(T.^2)));
    end
    
    % TODO: implement version if template is odd!
    [m_t,n_t] = size(T);    
    h_half_t = floor(m_t/2);
    w_half_t = floor(n_t/2);
    
    switch(method)
        case 'NCC'
            for y=h_half_t+1:m-h_half_t
                for x=w_half_t+1:n-w_half_t
                    I_norm = I(y-h_half_t:y+h_half_t, x-w_half_t:x+w_half_t);
                    I_norm = I_norm - mean(mean(I_norm));
                    I_norm = I_norm / sqrt(sum(sum(I_norm.^2)));
                    
                    val = 0;
                    for i=1:m_t
                        for j=1:n_t
                            val = val + (T(i,j)*I_norm(i,j));
                        end
                    end
                    R(y,x) = val;
                end
            end
            
            best_score = max(max(R));
            best_match = find(R == best_score);
            [match_y, match_x] = ind2sub(size(R), best_match);
            P = [match_x; match_y];
            
        case 'SSD'
            for y=h_half_t+1:m-h_half_t
                for x=w_half_t+1:n-w_half_t
                    val = 0;
                    for i=1:m_t
                        for j=1:n_t
                            val = val + (T(i,j) - I(y-h_half_t+i-1, x-w_half_t+j-1))^2;
                        end
                    end
                    R(y,x) = val;
                end
            end
            
            best_score = max(max(R));
            R = best_score - R;

            best_match = find(R == best_score);
            [match_y, match_x] = ind2sub(size(R), best_match);
            P = [match_x; match_y];
    end
end

