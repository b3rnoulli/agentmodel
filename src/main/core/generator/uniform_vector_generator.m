function [ value ] = uniform_vector_generator(sim_length , generator_params)
        value = 2*rand([1 sim_length])-1;
end

