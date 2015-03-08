function [ agent ] = von_neumann_neighbours(linear_index , size ,influence_parameter, influence_probability);
    
    n_row = size(1);
    n_col = size(2);
    [x,y] = ind2sub(size,linear_index);
    
    if rand > influence_probability
       influence_parameter = 0; 
    end
    
    agent(1).position = [shift_position(x,n_col,@(x) x-1), y];    
    agent(2).position = [shift_position(x,n_col,@(x) x+1), y];    
    agent(3).position = [x, shift_position(y,n_row,@(y) y-1)];   
    agent(4).position = [x, shift_position(y,n_row,@(y) y+1)];
    
    for i=1:1:length(agent)
       agent(i).index = sub2ind(size, agent(i).position(1), agent(i).position(2));
       agent(i).influence_parameter = influence_parameter;
    end
    

end


function shifted = shift_position(x, size, operation)

shifted = operation(x);
if shifted == 0
    shifted = size;
elseif shifted > size
    shifted = 1;
end
 
end
