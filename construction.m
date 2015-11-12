function aa=construction(i,j,cita,M)
aa=zeros(1,2*M);
%S=[-sin(cita*pi/180);cos(cita*pi/180)]; %% change 10-12
aa(2*(i-1)+1)=-sin(cita*pi/180);
aa(2*(i-1)+2)=cos(cita*pi/180);

aa(2*(j-1)+1)=sin(cita*pi/180);
aa(2*(j-1)+2)=-cos(cita*pi/180);