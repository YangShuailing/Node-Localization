clear all;
load scans_LP_result.mat
figure('Position',[1 1 400 300])
box on
plot(scans, rmse_LP_Anchors_MC, 'bd-', 'LineWidth', 2, 'MarkerFaceColor', 'b');% 

legend('\fontsize{12}\bf LP');
xlabel('\fontsize{12}\bf Number of Scans');
ylabel('\fontsize{12}\bf Localization Error(in units)');