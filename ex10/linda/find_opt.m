function [ best_scores ] = find_opt( scores, best, SCORING )
% best --> how many
    if strcmp(SCORING, 'ssd')
        val = quantile(scores(:,3),best);
        best_scores = scores(scores(:,3)<=val,:);
    else
        val = quantile(scores(:,3),1-best);
        best_scores = scores(scores(:,3)>=val,:);
    end
end

