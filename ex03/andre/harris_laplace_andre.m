function [ poi ] = harris_laplace_andre( I_n, n )

I = double(I_n);

s0 = 1.5;
k = 1.2;
alpha = 0.04;
th=1000000;
tl=50;

scale_space_max = cell(n+1);
sigma_In= cell(n+1);
scale_space_2nd = cell(n+1);



diff_x = [[-1,-1,-1];[0,0,0];[1,1,1]];
diff_y = [[-1;-1;-1],[0;0;0],[1;1;1]];

%prepare scale space and local harris maxima
for i=0:n
    
    %get harris detector results as local maxima coordinates
    [R,r,J,JJ] = harris_detector_andre(I,i,alpha,th,s0,k);
    scale_space_max{i+1} = JJ;
    %disp([i alpha t s0 k size(JJ)]);
    sigma_In{i+1} = s0*k^i;
    [gauss_y_I,gauss_x_I] = gen_gaussian_1D(sigma_In{i+1});
    %disp('lap I');
    %disp(gauss_y_I);
    %get second order derivatives in x and y direction for all scales
    G = conv2(conv2(I,gauss_x_I,'same'),gauss_y_I,'same');
    scale_space_2nd{i+1} = (sigma_In{i+1}^2)*(abs(conv2(conv2(G,diff_y,'same'),diff_y,'same')+conv2(conv2(G,diff_x,'same'),diff_x,'same')));
    scale_space_2nd{i+1}(scale_space_2nd{i+1}<tl) = 0;
    %scale_space_2nd_x{i+1} = conv2(conv2(I,gauss_x_I,'same'),gauss_x_I,'same');
    
end

poi = [-1,-1,-1];
%find maximas in scale space direction using laplacian
for i=0:n
    
    
    for m = 1:size(scale_space_max{i+1},2)
        y = scale_space_max{i+1}(1,m);
        x = scale_space_max{i+1}(2,m);
        laplacian_m = scale_space_2nd{i+1}(y,x);
        if i+1==1
            laplacian_m_up = scale_space_2nd{i+2}(y,x);
            if laplacian_m > laplacian_m_up
               poi = vertcat(poi,[y,x,k^i]);
            end
        elseif i+1==n+1
            laplacian_m_down = scale_space_2nd{i}(y,x);
            if laplacian_m > laplacian_m_down
                poi = vertcat(poi,[y,x,k^i]);
            end
        else
            laplacian_m_up = scale_space_2nd{i+2}(y,x);
            laplacian_m_down = scale_space_2nd{i}(y,x);
            %disp([laplacian_m laplacian_m_up laplacian_m_down]);
            if laplacian_m > laplacian_m_up & laplacian_m > laplacian_m_down
                poi = vertcat(poi,[y,x,k^i]);
                %disp([i laplacian_m laplacian_m_down laplacian_m_up]);
            end
        end
            
            
    end
    
end
poi = poi(2:size(poi,1),:);

end

