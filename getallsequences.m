%获取所有锚节点和目标节点的序列
function [sb] = getallsequences(a,b,NUM_NORMAL,NUM_ANCHOR,anchor_node,normal_node)
%  ax+by+c=0

for  i=1:NUM_ANCHOR
x0=anchor_node(i,1);
y0=anchor_node(i,2);
tdis_anchor(i)=point2line(x0,y0,a,b,0);
end

for  i=1:NUM_NORMAL
x0=normal_node(i,1);
y0=normal_node(i,2);
tdis_normal(i)=point2line(x0,y0,a,b,0);
end




tdis=[tdis_anchor tdis_normal];

[sa,sb]=sort(tdis);
sb=sb';
% sa %距离大小
% sb %序号，目标节点序号在前