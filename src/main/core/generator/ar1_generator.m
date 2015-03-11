function [val] = ar1_generator(prev_value, generator_params)
    val = generator_params(1).*prev_value + randn(size(prev_value));
end

