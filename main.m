image = imread('bild.jpg');

image = im2double(image);

image = im2double(image);
%load db
load('DB2.mat');


rgbImage = imresize(image, [1024 1024]);

[rows, columns, numberOfColorBands] = size(rgbImage);
blockSize = 16;
loopSize = 64;
ca = mat2cell(rgbImage,blockSize*ones(1,size(rgbImage,1)/blockSize),blockSize*ones(1,size(rgbImage,2)/blockSize),3);

LABvalues = ones(blockSize,blockSize,3);
%find lab values
for n = 1:loopSize
    for j = 1:loopSize
        tempIm = ca{n,j};
        temp = tempIm;
   
        temp = rgb2lab(temp);
        LABvalues(n,j,1) = mean(mean(temp(:,:,1)));
        LABvalues(n,j,2) = mean(mean(temp(:,:,2)));
        LABvalues(n,j,3) = mean(mean(temp(:,:,3)));
     
    end
    
end


%delta e

swapIndex = zeros(16,16);
for n = 1:loopSize
   for j = 1:loopSize
       for k = 1:100
            temp = LABvalue{k};
            deltaEl = ( LABvalues(n,j,1)-temp(1) )^2; 
            deltaEa = ( LABvalues(n,j,2)-temp(2) )^2; 
            deltaEb = ( LABvalues(n,j,3)-temp(3) )^2; 
            deltaE(k) = sqrt(deltaEl+deltaEa+deltaEb);
                      
       end
       [~, swapIndex(n,j)] = min(deltaE);   
   end
end

image2 = zeros(size(rgbImage));


for n = 1:100
    imageArray{n} = imread(sprintf('databas/%d.jpg',n));
end

filt=[0 0 7; 3 5 1]/16;

for n = 1:loopSize
   for j = 1:loopSize
       
       temp = imageArray(swapIndex(n,j));
       temp = cell2mat(temp);

       rgbImage = imresize(temp, [blockSize blockSize]);
       rgbImage = im2double(rgbImage);
       
       tileXYZ = rgb2xyz(rgbImage);
       
       temp = ca{n,j};
       OriTile = rgb2xyz(temp); 
        
       Xdif = mean(mean(abs(OriTile(:,:,1) - tileXYZ(:,:,1))));
       Ydif = mean(mean(abs(OriTile(:,:,2) - tileXYZ(:,:,2))));
       Zdif = mean(mean(abs(OriTile(:,:,3) - tileXYZ(:,:,3))));
       
       %OriTile = xyz2rgb(OriTile);
       %rgbDif = xyz2rgb([Xdif, Ydif, Zdif]);
       
       %rgbDif = floor(255*rgbDif);
       
       OriTile(:,:,1) = errordif(OriTile(:,:,1),Xdif*filt);
       OriTile(:,:,2) = errordif(OriTile(:,:,2),Ydif*filt);
       OriTile(:,:,3) = errordif(OriTile(:,:,3),Zdif*filt);
       
       image2( (1+( (n-1)*blockSize)):(n*blockSize) , (1+( (j-1)*blockSize)):(j*blockSize),:) = OriTile;
      
   end
   n;
end

imshow(image);
figure;
imshow(image2);


% Return to RGB
%NewRGB = lab2rgb(LABvalues);
%image2 = im2double(xyz2rgb(image2));



