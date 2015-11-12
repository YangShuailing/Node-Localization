function [dis] = fun_dis(point, lin)
% 求解点到直线间的距离
  % point=[x0,y0] 
  % lin ax+by+c = 0  
temp1 = abs(point(1)*lin(1)+point(2)*lin(2)+lin(3));
temp2 = sqrt(lin(1)^2 +lin(2)^2);

if temp2 == 0
    dis = abs( point(2) + lin(3)/lin(2));
else
    dis = temp1/temp2;
end

end