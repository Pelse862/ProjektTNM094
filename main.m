
addpath('resources/');
addpath('resources/scielab');

imageLoad = im2double(imread('bild.jpg'));

%load db
load('resources/DB.mat');

rgbImage = imresize(imageLoad, [1024 1024]);

[rows, columns, numberOfColorBands] = size(rgbImage);

blockSize = 16;
loopSize = 64;

filter=[0 0 7; 3 5 1]/16;

ca = mat2cell(rgbImage,blockSize*ones(1,size(rgbImage,1)/blockSize),blockSize*ones(1,size(rgbImage,2)/blockSize),3);

disp('1: Calculating Lab-values from databas')
LABvalues = Labsvalues( ca, blockSize, loopSize );
disp('1: END')

disp('2: Finding the most fitting image from datadas')
swapIndex = DBIndexMatrix( loopSize, LABvalues );
disp('2: END')

disp('3: Importing databas to array')
for n = 1:150
    DBArray{n} = imread(sprintf('databas/%d.jpg',n));
end
disp('3: END')

disp('4: Matching databas images to tiles')
for n = 1:loopSize
   for j = 1:loopSize
       
       cellImage = DBArray(swapIndex(n,j));
       rgbImage = cell2mat(cellImage);

       rgbImageResize = im2double(imresize(rgbImage, [blockSize blockSize]));      
       
       tileImage_lab = rgb2lab(ca{n,j});
       databasImage_lab = rgb2lab(rgbImageResize);

       Lvalue = mean(mean(tileImage_lab(:,:,1))) - mean(mean(databasImage_lab(:,:,1)));  

       databasImage_lab(:,:,1) = databasImage_lab(:,:,1) + Lvalue;
       tileImage_RGB = lab2rgb(databasImage_lab);
   
     %{
       Xdif = mean(mean(OriTile(:,:,1) - tileXYZ(:,:,1)));
       Ydif = mean(mean(OriTile(:,:,2) - tileXYZ(:,:,2)));
       Zdif = mean(mean(OriTile(:,:,3) - tileXYZ(:,:,3)));
      
       OriTileRGB = xyz2rgb( OriTile );
       rgbDif = xyz2rgb([Xdif, Ydif, Zdif]);
       
       OriTileRGB(:,:,1) = errordif(OriTileRGB(:,:,1),rgbDif(1)*filter);
       OriTileRGB(:,:,2) = errordif(OriTileRGB(:,:,2),rgbDif(2)*filter);
       OriTileRGB(:,:,3) = errordif(OriTileRGB(:,:,3),rgbDif(3)*filter);
       %}
       
       ResultImage( (1+( (n-1)*blockSize)):(n*blockSize) , (1+( (j-1)*blockSize)):(j*blockSize),:) = tileImage_RGB;
       cellImage{n,j} = tileImage_RGB;   
       
   end
end
disp('4: END')

figure;
imshow(ResultImage);
%%
3
LABvalues = Labsvalues( cellImage, blockSize, loopSize );

%delta e
4
swapIndex = DBIndexMatrix( loopSize, LABvalues );


for n = 1:loopSize
   for j = 1:loopSize
        
       OriTile = rgb2xyz(ca{n,j});
       
       LabTile = xyz2lab(OriTile);
       temp = imageArray(swapIndex(n,j));
       temp = cell2mat(temp);
       temp2 = rgb2lab(temp);
       lval = mean(mean(LabTile(:,:,1))) - mean(mean(temp2(:,:,1)))
       temp2(:,:,1) = temp2(:,:,1) + lval;
       temp = lab2rgb(temp2);
       rgbImage = imresize(temp, [blockSize blockSize]);
       rgbImage = im2double(rgbImage);
       
       image2( (1+( (n-1)*blockSize)):(n*blockSize) , (1+( (j-1)*blockSize)):(j*blockSize),:) = rgbImage;
       
   end
end

figure;
imshow(image);
[xRes, yRes, ~] = size(imageLoad);
imageNewRes = imresize(image2, [xRes yRes]);
figure;
imshow(imageNewRes);

