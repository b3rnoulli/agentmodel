function [balances, stocks, signal, threshold, state, neighbours] = init_agents_memory_preserve(params)

signal = zeros([ params.grid_size 2]);
threshold = zeros([ params.grid_size 2]);

signal(:,:,1) = params.agent_signal_generator(params.grid_size, params.signal_generator_params);
[balances, stocks, state, threshold(:,:,1)] = init_first_step(params,signal);

for i=1:1:params.grid_size(1)*params.grid_size(2)
    [x, y] = ind2sub(params.grid_size,i);
    neighbours(x,y).elements =  von_neumann_neighbours(i, params.grid_size, params.influence_parameter, params.influence_probability);
end


neighbours = symetricalize_influence(params.grid_size, neighbours);

end

