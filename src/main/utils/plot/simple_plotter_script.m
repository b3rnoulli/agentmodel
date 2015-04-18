% file_list = dir('wyniki');
%
%
% file_list(1:2) = [];
%
% for i=1:1:size(file_list,1)
%    simple_plotter(file_list(i).name);
% end

file_list = struct('name','');

p = [0.6];
a = 0.1:0.1:1;
j = [0.5];
h = [0.3, 0.7];
counter = 1;
for i=1:1:size(p,2)
    for r=1:1:size(h,2)
        for k=1:1:size(a,2)
            for m=1:1:size(j,2)
                name = ['abm_wfbm_p',strrep(num2str(p(i)),'.',''),...
                    '_j',strrep(num2str(j(m)),'.',''),...
                    '_a',strrep(num2str(a(k)),'.',''),...
                    '_h',strrep(num2str(h(r)),'.',''),'.mat'];
                file_list(counter).name = name;
                counter = counter +1;
            end
        end
    end
end


for i=1:1:size(file_list,2)
    try
        simple_plotter(file_list(i).name,1);
    catch
    end
end