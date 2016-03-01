clc

%imageLoad = imread('sloth.jpg');
imageLoad = imread('bild.jpg');

image = im2double(imageLoad);

%load db
load('DB2.mat');


rgbImage = imresize(image, [1024 1024]);

[rows, columns, numberOfColorBands] = size(rgbImage);
blockSize = 16;
loopSize = 64;
ca = mat2cell(rgbImage,blockSize*ones(1,size(rgbImage,1)/blockSize),blockSize*ones(1,size(rgbImage,2)/blockSize),3);

1
LABvalues = Labsvalues( ca, blockSize, loopSize );

%delta e
2
swapIndex = DBIndexMatrix( loopSize, LABvalues );

image2 = zeros(size(rgbImage));


for n = 1:200
    imageArray{n} = imread(sprintf('databas/%d.jpg',n));
end

filt=[0 0 7; 3 5 1]/16;
%%
for n = 1:loopSize
   for j = 1:loopSize
       
       temp = imageArray(swapIndex(n,j));
       temp = cell2mat(temp);

       rgbImage = imresize(temp, [blockSize blockSize]);
       rgbImage = im2double(rgbImage);
       
       tileXYZ = rgb2xyz(rgbImage);
       
       temp = ca{n,j};
       OriTile = rgb2xyz(temp);
       
       LunRatio = ( mean(mean(OriTile(:,:,2))) / mean(mean(tileXYZ(:,:,2))) );
       
       
       Xdif = mean(mean(abs(OriTile(:,:,1) - tileXYZ(:,:,1))));
       Ydif = mean(mean(abs(OriTile(:,:,2) - tileXYZ(:,:,2))));
       Zdif = mean(mean(abs(OriTile(:,:,3) - tileXYZ(:,:,3))));
       
       %OriTile(:,:,2) = LunRatio.*OriTile(:,:,2);
       
       OriTileRGB = xyz2rgb( OriTile );
       rgbDif = xyz2rgb([Xdif, Ydif, Zdif]);
       
       OriTileRGB(:,:,1) = errordif(OriTileRGB(:,:,1),rgbDif(1)*filt);
       OriTileRGB(:,:,2) = errordif(OriTileRGB(:,:,2),rgbDif(2)*filt);
       OriTileRGB(:,:,3) = errordif(OriTileRGB(:,:,3),rgbDif(3)*filt);
       
       image2( (1+( (n-1)*blockSize)):(n*blockSize) , (1+( (j-1)*blockSize)):(j*blockSize),:) = rgbImage;
      cellImage{n,j} = OriTileRGB;   
       
   end
end
imshow(image2);
figure;
3
LABvalues = Labsvalues( cellImage, blockSize, loopSize );

%delta e
4
swapIndex = DBIndexMatrix( loopSize, LABvalues );


for n = 1:loopSize
   for j = 1:loopSize
       
       temp = imageArray(swapIndex(n,j));
       temp = cell2mat(temp);

       rgbImage = imresize(temp, [blockSize blockSize]);
       rgbImage = im2double(rgbImage);
       
       image2( (1+( (n-1)*blockSize)):(n*blockSize) , (1+( (j-1)*blockSize)):(j*blockSize),:) = rgbImage;
       
   end
end

imshow(image);
%figure;
%imshow(image2);
[xRes, yRes, ~] = size(imageLoad);
imageNewRes = imresize(image2, [xRes yRes]);
figure;
imshow(imageNewRes);

%%


load('illum.mat');
load('xyz.mat');

pixels = sqrt(1920^2 + 1080^2);
screenInch = 12;
ppi = pixels / screenInch;

% Distens (inch)
D = 19.7;

samplePerDegree = ppi*D*tan(pi/180);

xyzIm = rgb2xyz(image);
xyzNewIm = rgb2xyz(imageNewRes);

ill = CIED65*xyz;

scieVal = scielab(samplePerDegree,xyzIm,xyzNewIm,ill,'xyz');

scieValScal = mean(mean(scieVal))

