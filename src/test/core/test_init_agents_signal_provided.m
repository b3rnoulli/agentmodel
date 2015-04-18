function tests = test_init_agents_signal_provided
tests = functiontests(localfunctions);
end

function test_signal_initialization(testCase)
params = initialize_params();

expected_length = 1;
[balances, stocks, signal_m, threshold, state, neighbours] = init_agents_signal_provided(params);
verifyEqual(testCase, size(signal_m.signal,3), params.simulation_length);
delete([params.full_name,'_','signal.mat']);
end

function [params] = initialize_params()

params.simulation_length = 1000;
params.grid_size = [10 10];
params.starting_price = 1;

params.agent_start_balance = 10;
params.agent_start_stocks = 10;
params.alpha_func_param = 1;
params.generator_name = 'uniform';
params.agent_signal_generator = @wfbm_generator;
params.signal_generator_params = 0.3;

params.signal_param = 1; % A
params.influence_parameter = 1; % J
params.influence_probability= 1; % p

params.m = 100;
params.full_name = ['abm_',params.generator_name,'_p',strrep(num2str(params.influence_probability),'.',''),...
    '_j',strrep(num2str(params.influence_parameter),'.',''),...
    '_a',strrep(num2str(params.signal_param),'.','')];


end