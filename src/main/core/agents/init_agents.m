function [balances_m, stocks_m, signal_m, threshold_m, state_m, neighbours] = init_agents(params)


%% initialize agent signal and create signal mat file reference
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

%% initialize rest of agent params adn create proper mat file references
threshold_m = create_mfile(params,'threshold');
balances_m = create_mfile(params,'balances');
stocks_m = create_mfile(params,'stocks');
state_m = create_mfile(params,'state');

[balances_m.balances(:,:,1), stocks_m.stocks(:,:,1), state_m.state(:,:,1), threshold_m.threshold(:,:,1)] = init_first_step(params, signal_m.signal(:,:,1));
neighbours = symetricalize_influence(params.grid_size, neighbours);

end

function [m_file] = create_mfile(params,variable_name)

    fprintf(['Saving ',variable_name,' matrix\n']);
    eval([variable_name,' = zeros([params.grid_size, params.simulation_length]);'])
    save([params.full_name,'_',variable_name,'.mat'],variable_name,'-v7.3');
    m_file = matfile([params.full_name,'_',variable_name,'.mat'],'Writable',true);
    clear(variable_name);
end