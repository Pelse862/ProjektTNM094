function out=errordif(in,filt)

% ***********************************************************
% out=errordif(in,filt)
%
% "in" är originalbilden.
% "out" är den rastrerade bilden.
% "filt" är felfiltret.
% "errordif" rastrerar inbilden med felspridningsmetoden.
% felfiltret måste också presenteras som en matris. T. ex.
% felfiltret som tas upp i labkompendiet på sidan 8 presenteras
% som filt=[0 0 7;
%           3 5 1]/16;
%*************************************************************
[nr,nc]=size(in);
[nrf,ncf]=size(filt);
x=floor(ncf/2);
out=ones(nr+nrf-1,nc+ncf-1);
in1=out;
in1(1:nr,1+x:nc+x)=in;

for i=1:nr
   for j=1+x:nc+x
      out(i,j)= in1(i,j)>=0.5;
      e=out(i,j)-in1(i,j);
      
      in1(i:i+nrf-1,j-x:j+x)=in1(i:i+nrf-1,j-x:j+x)-e*filt;
   end;
end;

out=out(1:nr,1+x:nc+x);