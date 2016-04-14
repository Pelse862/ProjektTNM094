addpath('resources/');
addpath('resources/scielab');

% load database
load('resources/DB.mat');

% Input image
imageLoad = im2double(imread('eye.jpg'));

% Resize image
rgbImage = imresize(imageLoad, [1024 1024]);

% Gridsize
blockSize = 16;

% Rows and columns
loopSize = 64;

% Filter for error diffusion
filter=[0.0 0.0 7.0; 3.0 5.0 1.0]/16.0;

% Convering image of blocks to cell 
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
              
       % Converting to Lab
       tileImage_lab = rgb2lab(ca{n,j});
       databasImage_lab = rgb2lab(rgbImageResize);
        
       % Luminance difference
       Lvalue = mean(mean(tileImage_lab(:,:,1))) - mean(mean(databasImage_lab(:,:,1)));  
        
       % Luminance correction
       databasImage_lab(:,:,1) = databasImage_lab(:,:,1) + Lvalue;
       
       % Convering to RGB
       tileImage_RGB = lab2rgb(databasImage_lab);
       
       % Result without luminance correction 
       ResultImage( (1+( (n-1)*blockSize)):(n*blockSize) , (1+( (j-1)*blockSize)):(j*blockSize),:) = tileImage_RGB;
    
       subImage = ca{n,j};
       
       % Finding difference 
       Rdif = mean(mean(subImage(:,:,1))) - mean(mean(tileImage_RGB(:,:,1)));
       Gdif = mean(mean(subImage(:,:,2))) - mean(mean(tileImage_RGB(:,:,2)));
       Bdif = mean(mean(subImage(:,:,3))) - mean(mean(tileImage_RGB(:,:,3)));
       
       % Adding differnce and applying error diffusson
       subImage(:,:,1) = errordif(subImage(:,:,1), filter + Rdif);
       subImage(:,:,2) = errordif(subImage(:,:,2), filter + Gdif);
       subImage(:,:,3) = errordif(subImage(:,:,3), filter + Bdif);
       
       LabCorrected = Labsvalues({subImage}, blockSize, 1 );
       newSwapIndex = DBIndexMatrix( 1, LabCorrected );

       cellImage = DBArray(newSwapIndex(1,1));
       rgbImage = cell2mat(cellImage);
        
       rgbImageResize = im2double(imresize(rgbImage, [blockSize blockSize]));      
       
       % Converting to Lab
       tileImage_lab = rgb2lab(subImage);
       databasImage_lab = rgb2lab(rgbImageResize);
       
       % Luminance difference
       Lvalue = mean(mean(tileImage_lab(:,:,1))) - mean(mean(databasImage_lab(:,:,1)));  
        
       % Luminance correction
       databasImage_lab(:,:,1) = databasImage_lab(:,:,1) + Lvalue;
       
       % Convering to RGB
       tileImage_RGB = lab2rgb(databasImage_lab);
       
       % Restult after error diffusion
       correctedResultImage( (1+( (n-1)*blockSize)):(n*blockSize) , (1+( (j-1)*blockSize)):(j*blockSize),:) = tileImage_RGB;
       
   end
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
