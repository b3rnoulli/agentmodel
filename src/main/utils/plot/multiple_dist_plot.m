
clear;
clc;
file_list = struct('name','');
p=1;
j=1;
a = 0.1:0.1:1;
h = 0.3;

for i=1:1:size(a,2)
    file_list(i).name = ['abm_wfbm_p',strrep(num2str(p),'.',''),...
        '_j',strrep(num2str(j),'.',''),...
        '_a',strrep(num2str(a(i)),'.',''),...
        '_h',strrep(num2str(h),'.',''),'.mat']; 
end


figure
legend_elements = struct('name','');
for i=1:1:size(file_list,2)
    data = load(file_list(i).name);
    lrr = zscore(diff(log(data.market_maker.price)));    
    [y,x] = ecdf(abs(lrr(3000:end)));
    loglog(x,1-y);
    legend_elements(i).name = strrep(strrep(file_list(i).name,'.mat',''),'_','-');
    hold on;
end
legend(legend_elements(1:end).name);
title(['1-CDF ','p1-j1-a005-05']);
xlim([0.01,100]);
ylim([10^-5,1]);