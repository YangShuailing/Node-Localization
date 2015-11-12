% delpoint：
%Eliminate Rule: Along a scanning direction, the lower boundary of the
%successor's area must be equal to or larger than the lower boundary of the
%predecessor's area, and the upper boundary of the predecessor's area must
%be equal to or smaller than the upper boundary of the successor's area.
% sb: Normal_node sequence
% k=-(a/b)

function  box = delpoint(sequence,a,b,box,Length,Width,p_band,sequence_index)

index=[];
for i = 1:length(sequence)  %% i:index of sequence  
   
    iindex=sequence(i);     
    
    if(i == 1)
        for j = 1:box(iindex).count             
       		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		 d_next_max=dismax(box,sequence(i+1),a,b); 
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
            
               x0=box(iindex).x(j);
               y0=box(iindex).y(j);
               dis = point2line(x0,y0,a,b,0) ; 
    
                if(dis > d_next_max)                  
                    box(iindex).flag(j) = 0;          
                end          
        end
        
    elseif (i == length(sequence))        
    %无后向节点，即序列中的最后一个节点  
      for j = 1:box(iindex).count
      	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            d_min = dismin(box,sequence(i-1),a,b,Length,Width);
			d_min=d_min-p_band; %%%low --little
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         
               x0=box(iindex).x(j);
               y0=box(iindex).y(j);
               dis = point2line(x0,y0,a,b,0) ;                
                if(dis < d_min)
                 box(iindex).flag(j) = 0;    
                end
       end
  
    
    else         
        %正常节点
         for j = 1:box(iindex).count	 
 
            d_min = dismin(box,sequence(i-1),a,b,Length, Width);			
            d_max = dismax(box,sequence(i+1),a,b);
			%%%%%%%%%%%%%%%%%%保护带，削弱删除条件，保留更多的点！！！%%%%%%%%%%%%%%%%%%%%%
			d_min=d_min-p_band; %%%low --little
			d_max = d_max + p_band;%%% up ---big
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         
               x0=box(iindex).x(j);
               y0=box(iindex).y(j);
               dis = point2line(x0,y0,a,b,0);               

                if(dis < d_min || dis > d_max)
                    box(iindex).flag(j) = 0;   
                end      
          end
        
    end  %%%if  else 
    
    
            index = find (box(iindex).flag(:) == 0);%标记需要删除的节点
            box(iindex).count =  box(iindex).count - length(index);
         if(box(iindex).count == 0)
               disp('****************************')
			     disp(['sequence: ',num2str(sequence_index)]);
               disp(['node ',num2str(iindex),'is keeped!'])
			 
               disp('****************************')     
               box(iindex).flag(index) = 1; %%%%change by jin  10.16  
               box(iindex).count =  box(iindex).count + length(index);
         else      
            box(iindex).x(index) = [];%删除节点
            box(iindex).y(index) = [];
            box(iindex).flag(index) = [];
         end 
    
    
   
    
end  %%%%  iiiiiiiiii  for loop sequence node 
    



%dismax
%function: get the max distance from point to line

function [d_max] = dismax(box,node_index,a,b)

d_max = 0;
for j = 1:box(node_index).count
        x0 = box(node_index).x(j);
        y0 = box(node_index).y(j);
        dis = point2line(x0,y0,a,b,0);
        if(dis > d_max)
            d_max = dis;
        end 
end


%dismin
%function: get the min distance from point to line

function [d_min] = dismin(box,node_index,a,b,Length,Width)


d_min = sqrt(Length*Length + Width*Width);

for j = 1:box(node_index).count
        x0 = box(node_index).x(j);
        y0 = box(node_index).y(j);
        dis = point2line(x0,y0,a,b,0);
        if(dis < d_min)
            d_min = dis;
        end
end


function [dis]=point2line(x,y,a,b,c)

dis=(a*x+b*y+c)/sqrt(a*a+b*b);

return

