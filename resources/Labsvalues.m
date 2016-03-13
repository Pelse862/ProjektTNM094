function LABvalues = Labsvalues( ca, blockSize, loopSize )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

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

end

