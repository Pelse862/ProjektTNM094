function LABvalues = Labsvalues( ca, blockSize, loopSize )
% Calculate L*a*b and store it
% ca is the database
% blocksize is the database
% loopSize is the number of rows and columns

LABvalues = ones(blockSize,blockSize,3);

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

