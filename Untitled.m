Scan_Time =20;
cita=-90:180/(Scan_Time-1):90;  
N_scans =20;
M =30;


XX=[Microphone_1_Location Microphone_2_Location]; %% 33*4
XX_Node = [Microphone_1_Location;Microphone_2_Location]; %% 66*2
Xanchor=XX_Node(1:2*Anchor_Number,:);  %锚节点坐标
X_Node = XX_Node(2*Anchor_Number+1:end,:); % 60*2
Node_Location=XX(Anchor_Number+1:Total_Number,:);% 普通节点

aa=max(XX);
max_anchor_x=max(Xanchor(:,1));
max_anchor_y=max(Xanchor(:,2));
max_anchor=max(max_anchor_x, max_anchor_y);
mmaxb=max(max(aa),max_anchor) + 1;  %%%bound


cita=-90:180/(Scan_Time-1):90;  
S=[-sin(cita*pi/180);-sin(cita*pi/180);cos(cita*pi/180);cos(cita*pi/180)];  
XX_new=XX*S;
[XXa,xrank]=sort(XX_new,1);
for i=1:N_scans
        table_binary = creat_table(Acoustic_Loc(i),X_Node); %生成二进制表信息
    for j=1:M
        for k=j+1:j+1  %%只计算相邻！！            
          %  tmpp=(ii-1)*T_count + count;         
          aa=construct_Line(xrank(j,i),xrank(k,i),X_Node,table_binary,M);
  www=construction(xrank(j,i),xrank(k,i),cita(i),M);
t = 0 ;
       a(count,1:2*M)=www;
       a(count,2*M+count)=-1;       
    count=count+1;
        end
    end

end

   
