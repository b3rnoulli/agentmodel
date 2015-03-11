function [ value ] = uniform_generator(prev_value, generator_params)
    value = 2*rand(size(prev_value))-1;
end

