function [ xxest_normal, xxest_anchor] = LP_Angle(Acoustic_Loc,Anchor_Number,Node_Number,Scan_Time,XX_rank,mminbb,mmaxb,Node_Location,Xanchor)

N = Scan_Time;
M =Node_Number;
Num_equa=N*M;%  等式个数
A = get_flag(Acoustic_Loc,XX_rank, Node_Location) ;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bb = -mminbb-0.0001; %%%%%%%
b = kron(bb,ones(N*M,1));


c=zeros(2*M+Num_equa,1);
cc=0;
c(1:2*M)= kron(cc,ones(2*M,1));
c(2*M+1:2*M+Num_equa)= 1;

%%%%%%%%%%%% Bound of x %%%%%%%%%%%% 
lb = zeros(Num_equa,1);
ub = mmaxb*ones(Num_equa,1);  
% lb = zeros(2*M+Num_equa,1);
% ub = mmaxb*ones(2*M+Num_equa,1);  
%%%%%%%%%%% mmaxb the place of wrong code ！！！
%%1 singleton variables in the equality constraints are not within bounds.


%%%%%%%%%%   equation constraint  %%%%%%%%%%  
%%%%%%%%%%%%%%%% 
% realx=[XX;zeros(Num_equa ,1)];
% sa=2*M+Num_equa; %[sa,sb]=size(realx);
sa=2*M+Num_equa;

Aequ=zeros(Anchor_Number,sa);
for i=1:Anchor_Number*2
    Aequ(i,i)=1;
end

bequ=reshape(Xanchor',2*Anchor_Number,1);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Aequ
% bequ
% pause;

[x,fval,exitflag,output,lambda] = linprog(c,A,b,Aequ,bequ,lb,ub);  % without equation constraint,do not work correctly

%[x,fval,exitflag,output,lambda] = linprog(c,A,b,Aequ,bequ);  %%%%%% without Bound do not work correctly %%
%[x,fval,exitflag,output,lambda] = linprog(c,A,b,Aequ,bequ,lb,ub,init_x);
if size(x,1)==2*M+Num_equa
 X_est=x(2*Anchor_Number+1:2*M); 
 X_est_anchor=x(1:2*Anchor_Number); 
else
disp('LP wrong!');
X_est=zeros(2*NUM_NORMAL,1);
pause;
end

 for i=1:Anchor_Number
     xxest_normal(i,1)=X_est(2*(i-1)+1);
     xxest_normal(i,2)=X_est(2*(i-1)+2);
end

for i=1:Anchor_Number
     xxest_anchor(i,1)=X_est_anchor(2*(i-1)+1);
     xxest_anchor(i,2)=X_est_anchor(2*(i-1)+2);
end



end
