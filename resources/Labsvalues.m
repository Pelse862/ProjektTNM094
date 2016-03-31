function LABvalues = Labsvalues( ca, blockSize, loopSize )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

LABvalues = ones(blockSize,blockSize,3);
%find lab values
for n = 1:loopSize
    for j = 1:loopSize
        DBImage = ca{n,j};
   
        Rmean = mean(mean(DBImage(:,:,1)));
        Gmean = mean(mean(DBImage(:,:,2)));
        Bmean = mean(mean(DBImage(:,:,3)));
        
        DBImage_Lab = rgb2lab([Rmean, Gmean, Bmean]);
       
        LABvalues(n,j,1) = DBImage_Lab(1);
        LABvalues(n,j,2) = DBImage_Lab(2);
        LABvalues(n,j,3) = DBImage_Lab(3);
    end
end

end

