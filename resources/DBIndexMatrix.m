function swapIndex = DBIndexMatrix( loopSize, LABvalues )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

load('DB.mat');

swapIndex = zeros(8,8);
for n = 1:loopSize
   for j = 1:loopSize
       for k = 1:150
            temp = LABvalue{k};
            
            deltaEa = ( LABvalues(n,j,2)-temp(2) )^2; 
            deltaEb = ( LABvalues(n,j,3)-temp(3) )^2;
      
            deltaE(k) = sqrt(deltaEa+deltaEb);                  
       end
       [~, swapIndex(n,j)] = min(deltaE);   
   end
end

end

