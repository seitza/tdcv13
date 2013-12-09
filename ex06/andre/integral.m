function [ J ] = integral( I )

I=double(I);

%init new image
J = double(zeros(size(I)));

%calculate first row and first column
J(1,1) = I(1,1);

for i = 2:size(I,1)
    J(i,1) = J(i-1,1)+I(i,1); 
end

for j = 2:size(I,2)
    J(1,j) = J(1,j-1)+I(1,j);
end

%calculate the rest of the image
for i = 2:size(I,1)
    for j = 2:size(I,2)
        J(i,j) = J(i-1,j)+J(i,j-1)-J(i-1,j-1)+I(i,j);
    end
end

end

