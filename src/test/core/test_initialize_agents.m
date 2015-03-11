function tests = test_initialize_agents
tests = functiontests(localfunctions);
end


function test_fixed_influence(testCase)
params = initialize_params();

[balances, stocks, signal, signal_param, signal_generator, threshold, state, neighbours] = initialize_agents(params.size, params.sim_length,params.agent_start_balance, ...
    params.agent_start_stocks, params.agent_signal_param, params.agent_signal_generator,...
    params.signal_generator_params,...
    params.influence_parameter, params.influence_probability, params.symetrical_influence, 0);

check_basic_agent_params(testCase, balances, stocks, signal_param, params);

verifyEqual(testCase, size(balances,3), params.sim_length);
verifyEqual(testCase, size(stocks,3), params.sim_length);
verifyEqual(testCase, size(threshold,3), params.sim_length);
verifyEqual(testCase, size(state,3), params.sim_length);
end

function test_symetrical_influence(testCase)
params = initialize_params();
params.influence_probability = .3;

[balances, stocks, signal, signal_param, signal_generator, threshold, state, neighbours] = initialize_agents(params.size, params.sim_length,params.agent_start_balance, ...
    params.agent_start_stocks, params.agent_signal_param, params.agent_signal_generator,...
    params.signal_generator_params,...
    params.influence_parameter, params.influence_probability, 1, 0);

check_basic_agent_params(testCase, balances, stocks, signal_param, params);
check_influence_parameters(testCase, neighbours);

end

function [params] = initialize_params()
params.sim_length = 1000;
params.size = [10, 10];
params.agent_start_balance = 100;
params.agent_start_stocks = 10;
params.agent_signal_param = 2;
params.agent_signal_generator = @uniform_generator;
params.signal_generator_params = 0;
params.influence_parameter = 1;
params.influence_probability = 1;
params.symetrical_influence = 0;
end


function check_basic_agent_params(testCase, balances, stocks, signal_param, params)
for i=1:1:size(balances,1)*size(balances,2)
    verifyEqual(testCase,balances(i),params.agent_start_balance);
    verifyEqual(testCase,stocks(i),params.agent_start_stocks);
    verifyEqual(testCase,signal_param(i),params.agent_signal_param);
end
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