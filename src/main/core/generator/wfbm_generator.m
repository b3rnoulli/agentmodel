function [ value ] = wfbm_generator(size, generator_param)
    
    value = diff(wfbm(generator_param, size+1));
end

