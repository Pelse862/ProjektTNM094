%Set image dimensions
w = 32; h = 32;

for n = 1:150

    image = imread(sprintf('databas/1 (%d).jpg',n));

    subImageTemp = imresize((im2double(image)), [w, h]);
    
    Rmean = mean2(subImageTemp(:,:,1));
    Gmean = mean2(subImageTemp(:,:,2));
    Bmean = mean2(subImageTemp(:,:,3));
    
    temp = rgb2lab([Rmean,Gmean,Bmean]);
    
    LABvalue{n} = [temp(1),temp(2),temp(3), n];    

end

save('DB.mat', 'LABvalue');