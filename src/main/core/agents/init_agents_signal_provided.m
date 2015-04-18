function [balances, stocks, signal_m, threshold, state, neighbours] = init_agents_signal_provided(params)

threshold = zeros([ params.grid_size 2]);

fprintf('Creating signal matrix \n');
signal = zeros([ params.grid_size params.simulation_length]);

for i=1:1:params.grid_size(1)*params.grid_size(2)
    [x, y] = ind2sub(params.grid_size,i);
    fprintf('Initializing signal for agent %d \n',i);
    signal(x,y,:) = params.agent_signal_generator(params.simulation_length, params.signal_generator_params);
    neighbours(x,y).elements =  von_neumann_neighbours(i, params.grid_size, params.influence_parameter, params.influence_probability);
end
fprintf('Saving signal matrix \n');
save([params.full_name,'_signal.mat'],'signal','-v7.3');
signal_m = matfile([params.full_name,'_signal.mat']);
clear signal;
[balances, stocks, state, threshold(:,:,1)] = init_first_step(params,signal_m.signal(:,:,1));

neighbours = symetricalize_influence(params.grid_size, neighbours);

end

