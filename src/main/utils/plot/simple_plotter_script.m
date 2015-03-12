file_list = dir('wyniki');


file_list(1:2) = [];

for i=1:1:size(file_list,1)
   simple_plotter(file_list(i).name);  
end


