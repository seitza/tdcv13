clear all;
clc;

disp('Testing gaussian_2d function against MATLAB-builtins');
disp('----------------------------------------------------');

eps = 0.0001;
sigmas = [1.0; 3.0; 5; 7; 10];

for i=1:length(sigmas)
    sigma = sigmas(i);
    fprintf('Sigma = %.2f\n', sigma);
    disp('Generating matlab filter...');
    tic;
    H_matlab = fspecial('gaussian', [3*sigma, 3*sigma], sigma);
    toc;
    
    disp('Generating custom filter...');
    tic;
    H_custom = gaussian_2D_dennis(sigma);
    toc;
    
    disp('Comparing different matrices...');
    D = (H_matlab - H_custom).^2;
    squared_diffs = sum(sum(D));
    
    if squared_diffs > eps
        fprintf('TEST NOT PASSED!! - Squared differences are %f\n\n', squared_diffs);
    else
        fprintf('TEST PASSED!\n\n');
    end
end