function [a]=get_lp(xrank,cita)
% 得到扫描线

[M,N_scans]=size(xrank);
T_count=(M-1);
a=zeros(T_count*N_scans,2*M+T_count*N_scans);
count=1;
for ii=1:N_scans
    
    for iii=1:M-1
        for jjj=iii+1:iii+1  %%只计算相邻！！            
          %  tmpp=(ii-1)*T_count + count;          
  www=construction(xrank(iii,ii),xrank(jjj,ii),cita(ii),M);
  %  a(tmpp,:)=www;    
       a(count,1:2*M)=www;
       a(count,2*M+count)=-1;       
    count=count+1;
        end
    end

end

end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%