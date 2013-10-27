clear all;
clc;

disp('Testing gaussian_1d function against MATLAB-builtins');
disp('----------------------------------------------------');

eps = 0.0001;
sigmas = [1.0; 3.0; 5; 7; 10];

for i=1:length(sigmas)
    sigma = sigmas(i);
    fprintf('Sigma = %.2f\n', sigma);
    disp('Generating matlab filter...');
    tic;
    H_matlab_x = fspecial('gaussian', [1, 3*sigma], sigma);
    H_matlab_y = fspecial('gaussian', [3*sigma, 1], sigma);
    toc;
    
    disp('Generating custom filter...');
    tic;
    [H_custom_y, H_custom_x] = gaussian_1D_dennis(sigma);
    toc;
    
    disp('Comparing different matrices...');
    D_x = (H_matlab_x - H_custom_x).^2;
    D_y = (H_matlab_y - H_custom_y).^2;
    squared_diffs_x = sum(sum(D_x));
    squared_diffs_y = sum(sum(D_y));
      
    if squared_diffs_x > eps || squared_diffs_y > eps
        fprintf('TEST NOT PASSED!! - Squared differences are: x: %f - y: %f\n\n', squared_diffs_x, squared_diffs_y);
    else
        fprintf('TEST PASSED!\n\n');
    end
end