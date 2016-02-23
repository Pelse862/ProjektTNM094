
%Set image dimensions
w = 32; h = 32;

images = zeros(w*h, 16);
for i = 1:50
    
    image = imread(sprintf('DB/%d.jpg',i));

    subImageTemp = imresize((im2double(image)), [w, h]);
    
    
end
