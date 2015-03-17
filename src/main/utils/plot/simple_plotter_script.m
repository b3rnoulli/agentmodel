% file_list = dir('wyniki');
% 
% 
% file_list(1:2) = [];
% 
% for i=1:1:size(file_list,1)
%    simple_plotter(file_list(i).name);  
% end

file_list = struct('name','');

file_list(1).name='abm_ar1_p06_j1_a005_fi1';
file_list(2).name='abm_ar1_p06_j1_a005_fi02';
file_list(3).name='abm_ar1_p06_j1_a005_fi04';
file_list(4).name='abm_ar1_p06_j1_a005_fi06';
file_list(5).name='abm_ar1_p06_j1_a005_fi08';

for i=1:1:size(file_list,2)
   simple_plotter(file_list(i).name,1);  
end