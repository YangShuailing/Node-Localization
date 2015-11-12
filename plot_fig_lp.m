  function  plot_fig_lp(Xnode,xxest,Xanchor,NUM_NORMAL,NUM_ANCHOR,xxest_anchor)
  
  figure(2) 

   plot(Xnode(1:end,1),Xnode(1:end,2),'k.' ,xxest(1:end,1) ,xxest(1:end,2),'b*',Xanchor(1:NUM_ANCHOR,1),Xanchor(1:NUM_ANCHOR,2),'rsquare');
    legend('True','ESP','Achohor');  

   hold on;   
  
%     for i=1:NUM_NORMAL
%    plot([Xnode(i,1) xxest(i,1)],[Xnode(i,2) xxest(i,2)],'-g','LineWidth',2);
%    end   
%    hold on;
% 
%     for i=1:NUM_NORMAL
%    plot([Xanchor(i,1) xxest_anchor(i,1)],[Xanchor(i,2) xxest_anchor(i,2)],'-g','LineWidth',2);
%    end   

   
   grid;
   hold off;
title('LP');