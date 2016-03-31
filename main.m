
addpath('resources/');
addpath('resources/scielab');

imageLoad = im2double(imread('eye.jpg'));

%load db
load('resources/DB.mat');

rgbImage = imresize(imageLoad, [1024 1024]);

[rows, columns, numberOfColorBands] = size(rgbImage);

blockSize = 16;
loopSize = 64;

filter=[0.0 0.0 7.0; 3.0 5.0 1.0]/16.0;

ca = mat2cell(rgbImage,blockSize*ones(1,size(rgbImage,1)/blockSize),blockSize*ones(1,size(rgbImage,2)/blockSize),3);

disp('1: Calculating Lab-values from databas')
LABvalues = Labsvalues( ca, blockSize, loopSize );

disp('2: Finding the most fitting image from datadas')
swapIndex = DBIndexMatrix( loopSize, LABvalues );

disp('3: Importing databas to array')
for n = 1:25
    DBArray{n} = imread(sprintf('databas/1 (%d).jpg',n));
end

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
    
       subImage = ca{n,j};
       
        
       Rdif = mean(mean(subImage(:,:,1))) - mean(mean(tileImage_RGB(:,:,1)));
       Gdif = mean(mean(subImage(:,:,2))) - mean(mean(tileImage_RGB(:,:,2)));
       Bdif = mean(mean(subImage(:,:,3))) - mean(mean(tileImage_RGB(:,:,3)));
      
       subImage(:,:,1) = errordif(subImage(:,:,1) + Rdif, filter);
       subImage(:,:,2) = errordif(subImage(:,:,2) + Gdif, filter);
       subImage(:,:,3) = errordif(subImage(:,:,3) + Bdif, filter);

       ResultImage( (1+( (n-1)*blockSize)):(n*blockSize) , (1+( (j-1)*blockSize)):(j*blockSize),:) = tileImage_RGB;
       
       LabCorrected = Labsvalues({subImage}, blockSize, 1 );
       newSwapIndex = DBIndexMatrix( 1, LabCorrected );

       
       cellImage = DBArray(newSwapIndex(1,1));
       rgbImage = cell2mat(cellImage);

       rgbImageResize = im2double(imresize(rgbImage, [blockSize blockSize]));      
       
       tileImage_lab = rgb2lab(subImage);
       databasImage_lab = rgb2lab(rgbImageResize);

       Lvalue = mean(mean(tileImage_lab(:,:,1))) - mean(mean(databasImage_lab(:,:,1)));  

       databasImage_lab(:,:,1) = databasImage_lab(:,:,1) + Lvalue;
       tileImage_RGB = lab2rgb(databasImage_lab);
       
       
       correctedResultImage( (1+( (n-1)*blockSize)):(n*blockSize) , (1+( (j-1)*blockSize)):(j*blockSize),:) = tileImage_RGB;
       
   end
   disp('4: Iteration ' + n)
end

figure;
inputImage = imresize(imageLoad, [1024 1024]);
imshow(inputImage)
figure;
imshow(ResultImage);
figure;
imshow(correctedResultImage);

disp('5: Calculating SCLab values')
ImageQuality(inputImage, ResultImage, 1);
ImageQuality(inputImage, correctedResultImage);
