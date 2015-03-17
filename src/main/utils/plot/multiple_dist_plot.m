
folder_name = 'C:\Users\Kowalski\Documents\MATLAB\Agent-based-model\wyniki\uniform\p1_j1_a005-05';

file_list = dir(folder_name);
file_list(1:2) = [];
figure
legend_elements = struct('name','');
colors = ['y','']
for i=1:1:size(file_list,1)
    data = load([folder_name,'\',file_list(i).name]);
    lrr = zscore(diff(log(data.market_maker.price)));    
    [y,x] = ecdf(abs(lrr));
    loglog(x,1-y);
    legend_elements(i).name = strrep(strrep(file_list(i).name,'.mat',''),'_','-');
    hold on;
end
legend(legend_elements(1:end).name);
title(['1-CDF ','p1-j1-a005-05']);
xlim([0.01,100]);
ylim([10^-5,1]);