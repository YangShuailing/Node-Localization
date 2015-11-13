% main function
clc;
clear all  %��� 
close all; %�ر�֮ǰ����

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%% ��ʼ������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
Size_Grid=10;  %�����С����λ��m 
Microphone_Distance = 0.2; %�ֻ�������mic֮����� ��m)
Node_Number =30; %�ڵ����
Anchor_Number = 3; % ê�ڵ����
Scale=2;%�����Ŵ�߶�
p_band=0.01;%%MSP�������Ǳ�����
mminbb= 0.1;  %% FOR lp %%%%%% have effect on the result!!!
Total_Number = Anchor_Number + Node_Number; % ��ͨ�ڵ� + ê�ڵ� 
RUNS = 10; %%�������
Scan_Time = 60; %%ɨ�����
Acoustic_Number = 10; % ��Դ�ĸ���
scans_min = 20;
scans_gap = 1;
scans_max = Scan_Time;
scans=scans_min :scans_gap:scans_max;
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
 
 Acoustic_Loc = fix(Size_Grid*abs((rand(Acoustic_Number,2))));%��Դλ����֪
for runs = 1:RUNS 
        disp(['runs = ',num2str(runs)]);
        disp(['---------- ']);
        
        rmse_lp_tmp=[];
        rmse_msp_tmp=[];
        count=1;
    for scan_Num =scans_min:scans_gap:scans_max;        
%         disp(['----- ']);
%         disp(['Scan_Time= ',num2str(scan_Num)]);
%         disp(['----- ']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%������˷�λ�ó�����Ϣ
    Microphone_Cita=zeros(Total_Number,1);
    Microphone_Center_Location =zeros(Total_Number,2);
    Microphone_Cita=fix(-90+180*(rand(Total_Number,1)));  %%���� [-90  90]    
    Microphone_Center_Location=fix(Size_Grid*abs((rand(Total_Number,2)))); % ���� λ��
    Microphone_1_Location=zeros(Total_Number,2); % ���� λ��
    Microphone_2_Location=zeros(Total_Number,2); % �ײ� λ��
    for  i=1:Total_Number
        %%(L/2,0)
        Microphone_1_Location(i,1)=Microphone_Center_Location(i,1) + 0.5*Microphone_Distance*(cos(Microphone_Cita(i)*pi/180));
        Microphone_1_Location(i,2)=Microphone_Center_Location(i,2) + 0.5*Microphone_Distance*(-sin(Microphone_Cita(i)*pi/180));  
         %%(-L/2,0)
        Microphone_2_Location(i,1)=Microphone_Center_Location(i,1) - 0.5*Microphone_Distance*(cos(Microphone_Cita(i)*pi/180));
        Microphone_2_Location(i,2)=Microphone_Center_Location(i,2) - 0.5*Microphone_Distance*(-sin(Microphone_Cita(i)*pi/180));        
    end
%%
% % disp('Microphone1: ');
% % disp(Microphone_1_Location);
% % disp('**********************************************');
% % disp('Microphone2: ');
% % disp(Microphone_2_Location);
% % disp('**********************************************');
% % figure('Position',[1 1 900 900])
% % plot(Microphone_1_Location(1:3,1),Microphone_1_Location(1:3,2),'b.',Microphone_2_Location(1:3,1),Microphone_2_Location(1:3,2),'b.',Microphone_Center_Location(1:3,1),Microphone_Center_Location(1:3,2),'r*');
% % hold on;
% % plot(Microphone_1_Location(4:Node_Number,1),Microphone_1_Location(4:Node_Number,2),'b.',Microphone_2_Location(4:Node_Number,1),Microphone_2_Location(4:Node_Number,2),'b.',Microphone_Center_Location(4:Node_Number,1),Microphone_Center_Location(4:Node_Number,2),'r.');
% % axis([0 Size_Grid 0 Size_Grid]) ;
% % % %
    X=[Microphone_Center_Location]; % �ڵ���������
    XX=[Microphone_1_Location Microphone_2_Location]; %% 33*4
    Node_Location=XX(1:Total_Number,:);%  �ڵ� 33 * 4
    Xanchor=X(1:Anchor_Number,:);  %ê�ڵ�����
    Xnode=X(Anchor_Number+1:Total_Number,:);% ��ͨ�ڵ�


    aa=max(X);
    max_anchor_x=max(Xanchor(:,1));
    max_anchor_y=max(Xanchor(:,2));
    max_anchor=max(max_anchor_x, max_anchor_y);
    mmaxb=max(max(aa),max_anchor) + 1;  %%%bound
            
    
    
    X= [Xanchor; Xnode];
    cita=-90:180/(Scan_Time-1):90;  
    S=[-sin(cita*pi/180);cos(cita*pi/180)];  
    X_new=X*S;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
    [Xa,X_rank]=sort(X_new,1);   

   est_lp=LP_EDSNL(Anchor_Number,Node_Number,Scan_Time,Xanchor,X_rank,cita,mminbb,mmaxb);
   size(est_lp)  
   t =0;
% %   plot_fig_lp(Xnode,est_lp,Xanchor,Node_Number,Anchor_Number,Size_Grid);   
%    rmse_lp_tmp(count) = sqrt( sum((est_lp(:)-Xnode(:)).^2) / Node_Number );    
%    count=count+1;


% % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%% ������Ϣ
 %%
%    
%     XX=[Microphone_1_Location Microphone_2_Location]; %% 33*4
%     XX_Node = [Microphone_1_Location;Microphone_2_Location]; %% 66*2
%     Xanchor=XX_Node(1:Anchor_Number,:);  %ê�ڵ�����
%     X_Node = XX_Node(2*Anchor_Number+1:end,:); % 60*2
%     Node_Location=XX(Anchor_Number+1:Total_Number,:);% ��ͨ�ڵ� 30 * 4
%      
%     aa=max(XX);
%     max_anchor_x=max(Xanchor(:,1));
%     max_anchor_y=max(Xanchor(:,2));
%     max_anchor=max(max_anchor_x, max_anchor_y);
%     mmaxb=max(max(aa),max_anchor) + 1;  %%%bound
%             
%     
%     cita=-90:180/(Scan_Time-1):90;  
%     S=[-sin(cita*pi/180);-sin(cita*pi/180);cos(cita*pi/180);cos(cita*pi/180)];  
%     XX_new=Node_Location*S;
%     [XXa,XX_rank]=sort(XX_new,1);
  %%% 

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %����TDOA��ֵ��������Ƕȣ�cita�� 
         angle = zeros( Acoustic_Number ,Total_Number);
for i = 1 : Acoustic_Number         
    % point[x0,y0] %��Դ
    % lin ax+by+c=0  
    x0 = Acoustic_Loc(i,1);
    y0 = Acoustic_Loc(i,2);      
        
   for j = 1 : Total_Number
       cc =0;
       for k = -90:180/(Scan_Time-1):90
            cc = cc+1;       
            a = -sin(k*pi/180); 
            b = cos(k*pi/180);
            c = (sin(k*pi/180)*x0 - cos(k*pi/180)*y0);
            lin = [a b c];
            point1(1,1) = Node_Location(j,1);
            point1(1,2) = Node_Location(j,2);
            point2(1,1) = Node_Location(j,3);    
            point2(1,2) = Node_Location(j,4);     
            temp1 = abs(fun_dis(point1,lin) - fun_dis(point2,lin));
            dis(cc) = temp1;
            
       end
       [m n] = min(dis);
      temp2(j)=fix(-cita(n));
     
   end
        
          angle_temp(i,:) = temp2;
 
end     
% �� mode �������޳��쳣ֵ
[m,n] = size(angle_temp);
for i =1:n
    [k,l] = mode(angle_temp(:,i)); % k��l�ֱ����������������Ƶ��
    angle(i)=k;
end

   for  i=1:Total_Number
        %%(L/2,0)
        Microphone_1_Location(i,1)=Microphone_Center_Location(i,1) + 0.5*Microphone_Distance*(cos(Microphone_Cita(i)*pi/180));
        Microphone_1_Location(i,2)=Microphone_Center_Location(i,2) + 0.5*Microphone_Distance*(-sin(Microphone_Cita(i)*pi/180));  
         %%(-L/2,0)
        Microphone_2_Location(i,1)=Microphone_Center_Location(i,1) - 0.5*Microphone_Distance*(cos(Microphone_Cita(i)*pi/180));
        Microphone_2_Location(i,2)=Microphone_Center_Location(i,2) - 0.5*Microphone_Distance*(-sin(Microphone_Cita(i)*pi/180));        
    end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% 
% 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
     
% rmse_LP_final_Anchors(runs,:)=rmse_lp_tmp;
t = 0 ;
end

% rmse_LP_Anchors_MC=mean(rmse_LP_final_Anchors);
% save scans_LP_result.mat  RUNS Scale Size_Grid Node_Number Anchor_Number scans  rmse_LP_Anchors_MC  rmse_LP_final_Anchors;



