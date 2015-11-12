function  [a] = get_flag(Acoustic_Loc,xrank, Node_Location)  
% 得到扫描线


[M,N_scans]=size(xrank); % M 是节点个数 30

T_count=(M-1);
a=zeros(T_count*N_scans,2*M+T_count*N_scans);
% a=zeros(T_count*N_scans,2*M+T_count*N_scans);
count=1;
for i=1:N_scans
    table_binary = creat_table(Acoustic_Loc(i), Node_Location); %生成二进制表信息
    for j=1:M
       
            aa=construct_Line(xrank(j,i),Node_Location,table_binary,M);
            %  a(tmpp,:)=www;    
            a(count,1:2*M)=aa;
            a(count,2*M+count)=-1;       
            count=count+1;
       
    end

end

end