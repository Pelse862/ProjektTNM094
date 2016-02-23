image = imread('bild.jpg');
image = double(image);

height = 30;
width = 20;

rgbImage = imresize(image, [512 512]);
[rows, columns, numberOfColorBands] = size(rgbImage);
blockSize = 32;
ca = mat2cell(rgbImage,blockSize*ones(1,size(rgbImage,1)/blockSize),blockSize*ones(1,size(rgbImage,2)/blockSize),3);

LABvalues = ones(16,16,3);

for n = 1:16
    for j = 1:16
        temp = ca{n,j};
        temp = temp/255;
        figure
        imshow(temp)
        temp = rgb2lab(temp);
        LABvalues(n,j,1) = mean(mean(temp(:,:,1)));
        LABvalues(n,j,2) = mean(mean(temp(:,:,2)));
        LABvalues(n,j,3) = mean(mean(temp(:,:,3)));     
    end
end

