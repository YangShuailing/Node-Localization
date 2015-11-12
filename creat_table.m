function [table_binary]=creat_table(count,k,Acoustic_Loc, Node_Location,XX_rank)
[list,row]=size(Node_Location); % Node_Number * Scan_Time
table_binary=zeros(list,1); %   

for i = 1:list
    x1 =  Node_Location(XX_rank(k, count),1);
    y1 =  Node_Location(XX_rank(k, count),2);
    x2 =  Node_Location(XX_rank(k, count),3);
    y2 =  Node_Location(XX_rank(k, count),4);
    X1 = [x1 y1];
    X2 = [x2 y2];
    dis = norm(X1 -Acoustic_Loc) - norm(X2 -Acoustic_Loc);
    if dis >= 0
        table_binary(i) = 0;
    else
        table_binary(i) = 1;
    end
end
