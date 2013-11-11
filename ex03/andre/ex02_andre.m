I = double(imread('lena.gif'));
poi = harris_laplace_andre(I,5);

figure;
imagesc(I);
colormap(gray);
hold on;

for i=1:size(poi,1)
   plot(poi(i,1),poi(i,2),'ro','MarkerSize',(poi(i,3)^2)*5); 
end