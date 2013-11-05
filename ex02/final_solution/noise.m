function [ J ] = noise( I, type, varargin )
    % type of noise that can be added:
    %   - gaussian noise --> 'gaussian', additional parameter: varianz
    %   - salt and pepper noise --> 'salt&pepper'
    if nargin == 2 && strcmp(type, 'salt&pepper')
        r = randi([0 255], size(I));
        J = double(I);
        J(r == 255) = 255;
        J(r == 0) = 0;
    elseif nargin == 3 && strcmp(type, 'gaussian')
        varianz = varargin{1};
        J = double(I) + randn(size(I)).*varianz;
    else
        throw(MException('MATLAB:wronginput', 'wrong input parameters!'));
    end
end

