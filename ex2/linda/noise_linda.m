function [ J ] = noise_linda( I, type, varargin )
    % type of noise that can be added:
    %   - gaussian noise --> 'gaussian', additional parameter: varianz
    %   - salt and pepper noise --> 'salt&pepper'
    if nargin == 2 && strcmp(type, 'salt&pepper')
        r = rand(size(I));
        J = double(I);
        J(r > 0.99) = 255;
        J(r < 0.01) = 0;
    elseif nargin == 3 && strcmp(type, 'gaussian')
        varianz = varargin{1};
        J = double(I) + randn(size(I)).*varianz;
    else
        throw(MException('MATLAB:wronginput', 'wrong input parameters!'));
    end
end

