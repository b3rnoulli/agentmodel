function [ val ] = volume_depend_alpha_func(param, volumen, grid_size)
    
val = param*volumen/grid_size(1)/grid_size(2);
    
end

