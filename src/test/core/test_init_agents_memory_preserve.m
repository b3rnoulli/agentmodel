function tests = test_init_agents_memory_preserve
tests = functiontests(localfunctions);
end

function test_fixed_influence(testCase)
params = initialize_params();

expected_length = 1;
[balances, stocks, signal, threshold, state, neighbours] = init_agents_memory_preserve(params);

verifyEqual(testCase, size(signal,3), 2);
verifyEqual(testCase, size(threshold,3), 2);

check_basic_agent_params(testCase, balances, stocks, state, params, expected_length);
check_influence_parameters(testCase, neighbours);
end

function test_symetrical_influence(testCase)
params = initialize_params();
params.influence_probability = 0.3;

[balances, stocks, signal, threshold, state, neighbours] = init_agents_memory_preserve(params);

sum = 0;
for i=1:1:params.grid_size(1)*params.grid_size(2)
    for j=1:1:4
         sum = sum + neighbours(i).elements(j).influence_parameter;
    end
end
verifyEqual(testCase, abs(sum-params.grid_size(1)*params.grid_size(2)*params.influence_probability*4) < 20, true);
end


function check_basic_agent_params(testCase, balances, stocks, state, params, expected_length)
verifyEqual(testCase,balances,ones(params.grid_size).*params.agent_start_balance);
verifyEqual(testCase,stocks,ones(params.grid_size).*params.agent_start_stocks);
verifyEqual(testCase, size(balances,3), expected_length);
verifyEqual(testCase, size(stocks,3), expected_length);
verifyEqual(testCase, size(state,3), expected_length);
end

function check_influence_parameters(testCase, neighbours)
for i=1:1:size(neighbours,2)*size(neighbours,1)
    verifyEqual(testCase, ...
        neighbours(neighbours(i).elements(1).index).elements(2).influence_parameter, ...
        neighbours(i).elements(1).influence_parameter);
    
    verifyEqual(testCase, ...
        neighbours(neighbours(i).elements(2).index).elements(1).influence_parameter, ...
        neighbours(i).elements(2).influence_parameter);
    
    verifyEqual(testCase, ...
        neighbours(neighbours(i).elements(3).index).elements(4).influence_parameter, ...
        neighbours(i).elements(3).influence_parameter);
    
    verifyEqual(testCase, ...
        neighbours(neighbours(i).elements(4).index).elements(3).influence_parameter, ...
        neighbours(i).elements(4).influence_parameter);
end
end

function [params] = initialize_params()

params.simulation_length = 1000;
params.grid_size = [10 10];
params.starting_price = 1;

params.agent_start_balance = 10;
params.agent_start_stocks = 10;
params.alpha_func_param = 1;
params.generator_name = 'uniform';
params.agent_signal_generator = @uniform_generator;
params.signal_generator_params = [];

params.signal_param = 1; % A
params.influence_parameter = 1; % J
params.influence_probability= 1; % p

params.m = 100;

end

