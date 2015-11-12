function aa=construct_Line(i,Node_Location,table_binary,M)
aa=zeros(1,2*M);

x1 =  Node_Location(i,1);
y1 =  Node_Location(i,2);
x2 =  Node_Location(i,3);
y2 =  Node_Location(i,4); 

if  table_binary(i) <= 0
%S=[-sin(cita*pi/180);cos(cita*pi/180)]; %% change 10-12
    aa(i+1)=x1;
    aa(i+2)=y1;
    aa(i+3)=-x2;
    aa(i+4)=-y2;
else
    aa(i+1)=-x1;
    aa(i+2)=-y1;
    aa(i+3)=x2;
    aa(i+4)=y2; 
end

end