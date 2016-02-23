image = imread('gudde.jpg');

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
        temp = ca{n,j};
        temp = temp;
   
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

for n = 1:loopSize
   for j = 1:loopSize
       temp = imageArray(swapIndex(n,j));
       temp = cell2mat(temp);
       rgbImage = imresize(temp, [blockSize blockSize]);
       rgbImage = im2double(rgbImage);
       image2( (1+( (n-1)*blockSize)):(n*blockSize) , (1+( (j-1)*blockSize)):(j*blockSize),:) = rgbImage;
      
   end
   n
end
%%

% Load filter for error diffusion
load('Filters.mat');

% Return to RGB
%NewRGB = lab2rgb(LABvalues);
image2 = im2double(image2);
R = image2(:,:,1);
G = image2(:,:,2);
B = image2(:,:,3);

% Error diffusion of all channels
Rf = errordif(R, SF); % SF, FanDi, JaJuNi
Gf = errordif(G, SF); % SF, FanDi, JaJuNi
Bf = errordif(B, SF); % SF, FanDi, JaJuNi
DifIm(:,:,1) = Rf;
DifIm(:,:,2) = Gf;
DifIm(:,:,3) = Bf;
imshow(DifIm)
figure


Rf = dither(R);
Gf = dither(G);
Bf = dither(B);


DifIm(:,:,1) = Rf;
DifIm(:,:,2) = Gf;
DifIm(:,:,3) = Bf;
DifIm = im2double(DifIm);
imshow(image)
figure
imshow(image2)
figure
imshow(DifIm)



