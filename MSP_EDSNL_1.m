
function  Est_Normal = MSP_EDSNL(Num_Achohor,Num_Target,scan_time,anchor_node,X_rank,cita,p_band,normal_node)
%%% input:normal_node  for plot!
plotflag=0;
debug=1;
PB_anchor=p_band;

global SCAN_TIMES;
global NUM_ANCHOR;
global NUM_NORMAL;%目标节点数量

%监测区域设置
global Length Width;%区域大小
global LENGTH_S LENGTH_E WIDTH_S WIDTH_E;%区域起点与终点坐标
global AreaX AreaY;%网格节点
global LGRID WGRID;%网格个数
global Grid_all;%所有的网格节点坐标，顺序：由下至上，由左至右


% %初始化
 NUM_ANCHOR =  Num_Achohor;
 NUM_NORMAL = Num_Target;
 SCAN_TIMES=scan_time;

Length = LENGTH_E - LENGTH_S;%长度
Width = WIDTH_E -WIDTH_S;%宽度

%生成离散点
AreaX = LENGTH_S : Length/LGRID : LENGTH_E;
AreaY = WIDTH_S : Width/WGRID : WIDTH_E;

for i=0:LGRID
    for j=0:WGRID
        Grid_all(i*(LGRID+1)+j+1,1) = AreaX(i+1);
        Grid_all(i*(WGRID+1)+j+1,2) = AreaY(j+1);
    end
end


%%%%%改动部分（start）%%%%% by sunwei 10.14
%%说明：初始化box为区域内所有的点%%

for normal_counter = 1:NUM_NORMAL
   box(normal_counter).count=(LGRID+1)*(WGRID+1);
   box(normal_counter).x=Grid_all(:,1);
   box(normal_counter).y=Grid_all(:,2);
   box(normal_counter).flag=ones(size(Grid_all(:,1)));
end



  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % cita=[-90:90]
%if cita[-180 -90] need patch!!!
   disp('***************************************************')
         for ii=1:SCAN_TIMES  
		 if cita(ii)<-90
          X_rank(:,ii)=X_rank(end:-1:1,ii);
          end
	  end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


disp('******************************************')
disp('Step1: Del point using anchor:');
disp('******************************************')
[box_after_anchor]= del_point_using_anchor(box,X_rank,NUM_ANCHOR,NUM_NORMAL,SCAN_TIMES,anchor_node,cita,PB_anchor,LGRID,WGRID,normal_node); %% added by Naigao-10.13

if plotflag==1
plot_box(box_after_anchor,NUM_NORMAL,NUM_ANCHOR,anchor_node,normal_node);
end

for k=1:NUM_NORMAL
count_after_anchor(k)=box_after_anchor(k).count;
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% IMSP， 进一步删除点！！
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ax+by+c=0  y=tan(cita)x     -tan(cita)*x +1*y =0  a=-tan(cita)  b=1   a=-sin b=cos  
% d= -tan(cita)*x +1*y= -sin*x + cos*y 
%%%[x' y']=[c -s; s c] [x y]  y'就是距离   y'=-sin*x+cos*y

A = -tan(cita*pi/180);
b = 1;

%%%%%%%%%make sure exist data in box_after_anchor
disp('******************************************')
disp('Step2: IMSP:');
disp('******************************************')
order = zeros(1,NUM_NORMAL);
[box_a,box_b] = size(box_after_anchor);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Jin %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
count_loop=0;
while 1
    count_loop=count_loop+1;
    disp(['count_loop = ',num2str(count_loop)]);
    
    for i = 1:SCAN_TIMES  
          %  disp(['SCAN_TIMES  = ',num2str(i)]);
        a = A(i);
		%%%删除锚节点后，重新排序，生成只有目标节点的sequence
         order_normal_list=rank_only_normal_node(X_rank(:,i),SCAN_TIMES,NUM_ANCHOR,NUM_NORMAL); %% added by Naigao-10.13
         box_after_anchor=delpoint(order_normal_list,a,b,box_after_anchor,Length, Width,p_band,i); 
		 if plotflag==1
		 disp(['Sequence_index=',num2str(i)]);
		 plot_box(box_after_anchor,NUM_NORMAL,NUM_ANCHOR,anchor_node,normal_node);
		 end
    end  %%%%%%%%%%%%%%%%%%%% for i = 1:SCAN_TIMES  
    
    box_after_del=box_after_anchor; %%%modify this bug!!  

for k=1:NUM_NORMAL
count_after_del(k)=box_after_del(k).count;
end
count_after_del;

    %当box行数不变时结束循环，即在边界在迭代过程中不可能进一步缩小的情况下
%       if count_loop == 2
%         break;
%        end    
    if count_after_del == count_after_anchor
        break;
    end
 count_after_anchor =  count_after_del; 
end  %% while 1

  
disp('Center of Gravity');
%经过节点过滤后，求剩余节点的坐标平均值为最后的估计位置
Est_MSP = [];
tmp = [];
tmp_1 = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j = 1:NUM_NORMAL
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
      for i = 1: box_after_del(j).count
          tmp = [tmp; box_after_del(j).x(i),box_after_del(j).y(i)]; 
      end    
    tmp_1 = [mean(tmp(:,1))  mean(tmp(:,2))];
    Est_MSP = [Est_MSP; j tmp_1];
    tmp = [];    
end  %%for j = 1:NUM_NORMAL
% 估计位置
%Est_MSP = [目标节点序号 目标节点横坐标 目标节点纵坐标] 3列
Est_Normal = [Est_MSP(:,2) Est_MSP(:,3)];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [dis]=point2line(x,y,a,b,c)

dis=(a*x+b*y+c)/sqrt(a*a+b*b);

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function order_normal_list=rank_only_normal_node(order_list,SCAN_TIMES,NUM_ANCHOR,NUM_NORMAL)


    rank_tmp=order_list;
   
    for j=1:length(rank_tmp)
        if rank_tmp(j)<=NUM_ANCHOR
            rank_tmp(j)=0;
        end
    end
    
        index = find (rank_tmp == 0);%标记需要删除的节点
        rank_tmp(index) = [];%删除节点
  
        for k=1:NUM_NORMAL
    order_normal_list(k)=rank_tmp(k)-NUM_ANCHOR;
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
