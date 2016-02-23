image = imread('bild.jpg');
image = double(image);
%load db
load('DB.mat');


rgbImage = imresize(image, [512 512]);
[rows, columns, numberOfColorBands] = size(rgbImage);
blockSize = 32;
ca = mat2cell(rgbImage,blockSize*ones(1,size(rgbImage,1)/blockSize),blockSize*ones(1,size(rgbImage,2)/blockSize),3);

LABvalues = ones(16,16,3);
%find lab values
for n = 1:16
    for j = 1:16
        temp = ca{n,j};
        temp = temp/255;
   
        temp = rgb2lab(temp);
        LABvalues(n,j,1) = mean(mean(temp(:,:,1)));
        LABvalues(n,j,2) = mean(mean(temp(:,:,2)));
        LABvalues(n,j,3) = mean(mean(temp(:,:,3)));     
    end
end

%delta e

swapIndex = zeros(16,16);
for n = 1:16
   for j = 1:16
       for k = 1:50
            temp = LABvalue{k};
            deltaEl = ( LABvalues(n,j,1)-temp(1) )^2; 
            deltaEa = ( LABvalues(n,j,2)-temp(2) )^2; 
            deltaEb = ( LABvalues(n,j,3)-temp(3) )^2; 
            deltaE(k) = sqrt(deltaEl+deltaEa+deltaEb);
                      
       end
       [~, swapIndex(n,j)] = min(deltaE);   
   end
end

image2 = zeros(size(image));


for n = 1:16
   for j = 1:16
       temp = imread(sprintf('DB/%d.jpg',swapIndex(n,j)));
       rgbImage = imresize(temp, [blockSize blockSize]);
       rgbImage = im2double(rgbImage);
       image2( (1+( (n-1)*blockSize)):(n*blockSize) , (1+( (j-1)*blockSize)):(j*blockSize),:) = rgbImage;
      
   end
end










