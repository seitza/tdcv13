function [ score ] = compute_score( x,y,I,T,method )

    [a,b,c] = size(I);
    all_scores = zeros(c,1);
    if strcmp(method, 'ssd')
        for i = 1:c
            all_scores(i) = ssd(x,y,I(:,:,i),T(:,:,i));
        end
    else
        for i = 1:c
            all_scores(i) = ncc(x,y,I(:,:,i),T(:,:,i));
        end
    end
    score = mean(all_scores);
end

