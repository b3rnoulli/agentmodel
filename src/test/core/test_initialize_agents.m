function tests = test_initialize_agents
tests = functiontests(localfunctions);
end


function test_fixed_influence(testCase)
params = initialize_params();

agents = initialize_agents(params.size, params.sim_length,params.agent_start_balance, ...
    params.agent_start_stocks, params.agent_signal_param, params.agent_signal_generator, ...
    params.influence_parameter, params.influence_probability, params.symetrical_influence);
    
    check_basic_agent_params(testCase, agents, params);
    
    verifyEqual(testCase, size(agents.balances,3), params.sim_length);
    verifyEqual(testCase, size(agents.stocks,3), params.sim_length);
    verifyEqual(testCase, size(agents.threshold,3), params.sim_length);
    verifyEqual(testCase, size(agents.state,3), params.sim_length);
end

function test_symetrical_influence(testCase)
params = initialize_params();
params.influence_probability = .3;

agents = initialize_agents(params.size, params.sim_length,params.agent_start_balance, ...
    params.agent_start_stocks, params.agent_signal_param, params.agent_signal_generator, ...
    params.influence_parameter, params.influence_probability, 1);

check_basic_agent_params(testCase, agents, params);
check_influence_parameters(testCase, agents);

end

function [params] = initialize_params()
params.sim_length = 1000;
params.size = [10, 10];
params.agent_start_balance = 100;
params.agent_start_stocks = 10;
params.agent_signal_param = 2;
params.agent_signal_generator = @() uniform_generator;
params.influence_parameter = 1;
params.influence_probability = 1;
params.symetrical_influence = 0;
end


function check_basic_agent_params(testCase, agents, params)
for i=1:1:size(agents,1)
    verifyEqual(testCase,agents.balances(i),params.agent_start_balance);
    verifyEqual(testCase,agents.stocks(i),params.agent_start_stocks);
    verifyEqual(testCase,agents.signal_param(i),params.agent_signal_param);  
end
end

function check_influence_parameters(testCase, agents)
for i=1:1:size(agents,2)    
    verifyEqual(testCase, ...
    agents.neighbours(agents.neighbours(i).elements(1).index).elements(2).influence_parameter, ...
    agents.neighbours(i).elements(1).influence_parameter);

    verifyEqual(testCase, ...
    agents.neighbours(agents.neighbours(i).elements(2).index).elements(1).influence_parameter, ...
    agents.neighbours(i).elements(2).influence_parameter);
        
    verifyEqual(testCase, ...
    agents.neighbours(agents.neighbours(i).elements(3).index).elements(4).influence_parameter, ...
    agents.neighbours(i).elements(3).influence_parameter);

    verifyEqual(testCase, ...
    agents.neighbours(agents.neighbours(i).elements(4).index).elements(3).influence_parameter, ...
    agents.neighbours(i).elements(4).influence_parameter);  
end

end