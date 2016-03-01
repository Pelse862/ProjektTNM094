function swapIndex = DBIndexMatrix( loopSize, LABvalues )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

load('DB2.mat');

swapIndex = zeros(16,16);
for n = 1:loopSize
   for j = 1:loopSize
       for k = 1:200
            temp = LABvalue{k};
            deltaEl = ( LABvalues(n,j,1)-temp(1) )^2;  
            deltaEa = ( LABvalues(n,j,2)-temp(2) )^2; 
            deltaEb = ( LABvalues(n,j,3)-temp(3) )^2;
           
            deltaE(k) = sqrt(deltaEl+deltaEa+deltaEb);
            %deltaE(k) = sqrt(deltaEa+deltaEb);
                      
       end
       
       [~, swapIndex(n,j)] = min(deltaE);   
   end
end



end

