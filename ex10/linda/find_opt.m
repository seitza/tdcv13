function [ best_scores ] = find_opt( scores, best, SCORING )
% best --> how many
    val = quantile(scores(:,3),best);
    if strcmp(SCORING, 'ssd')
        best_scores = scores(scores(:,3)<=val,:);
    else
        best_scores = scores(scores(:,3)>=val,:);
    end
end

