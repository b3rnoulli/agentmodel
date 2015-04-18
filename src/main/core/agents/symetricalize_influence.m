function [ neighbours ] = symetricalize_influence(size, neighbours)
   for i=1:2:(size(1)*size(2))
       neighbours(i).elements(1).influence_parameter = neighbours(neighbours(i).elements(1).index).elements(2).influence_parameter;
       neighbours(i).elements(2).influence_parameter = neighbours(neighbours(i).elements(2).index).elements(1).influence_parameter;
       neighbours(i).elements(3).influence_parameter = neighbours(neighbours(i).elements(3).index).elements(4).influence_parameter;
       neighbours(i).elements(4).influence_parameter = neighbours(neighbours(i).elements(4).index).elements(3).influence_parameter;
   end
   for i=2:2:(size(1)*size(2))
       neighbours(i).elements(1).influence_parameter = neighbours(neighbours(i).elements(1).index).elements(2).influence_parameter;
       neighbours(i).elements(2).influence_parameter = neighbours(neighbours(i).elements(2).index).elements(1).influence_parameter;
       neighbours(i).elements(3).influence_parameter = neighbours(neighbours(i).elements(3).index).elements(4).influence_parameter;
       neighbours(i).elements(4).influence_parameter = neighbours(neighbours(i).elements(4).index).elements(3).influence_parameter;
   end
end

