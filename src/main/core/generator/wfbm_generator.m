function [ value ] = wfbm_generator(length, generator_param)
    
    value = diff(wfbm(generator_param, length));

end

