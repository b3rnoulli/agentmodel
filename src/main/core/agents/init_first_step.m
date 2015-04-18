function [balances, stocks, state, signal, threshold] = init_first_step(params, signal)
balances = ones(params.grid_size).*params.agent_start_balance;
stocks = ones(params.grid_size).*params.agent_start_stocks;
threshold = abs(normrnd(0,1,params.grid_size));
state = resolve_agents_states(signal, threshold);
end