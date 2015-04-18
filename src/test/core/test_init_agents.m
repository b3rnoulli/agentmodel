function tests = test_init_agents
tests = functiontests(localfunctions);
end


function test_fixed_influence(testCase)
params = initialize_params();

[balances_m, stocks_m, signal_m, threshold_m, state_m, neighbours] = init_agents(params);
check_basic_agent_params(testCase, balances_m.balances, stocks_m.stocks, threshold_m.threshold, state_m.state, params);
check_influence_parameters(testCase, neighbours);
clean_up(params);
end

function test_symetrical_influence(testCase)
params = initialize_params();
params.influence_probability = 0.3;
[balances_m, stocks_m, signal_m, threshold_m, state_m, neighbours] = init_agents(params);
check_basic_agent_params(testCase, balances_m.balances, stocks_m.stocks, threshold_m.threshold, state_m.state, params);
check_influence_parameters(testCase, neighbours);
sum = 0;
for i=1:1:params.grid_size(1)*params.grid_size(2)
    for j=1:1:4
        sum = sum + neighbours(i).elements(j).influence_parameter;
    end
end
verifyEqual(testCase, abs(sum-params.grid_size(1)*params.grid_size(2)*params.influence_probability*4) < 150, true);
clean_up(params);
end


function [params] = initialize_params()
%% simulation params
params.simulation_length = 10000;
params.grid_size = [50 50];
params.starting_price = 1;

%% agents params
params.agent_start_balance = 100;
params.agent_start_stocks = 100;
params.alpha_func_param = 1;
params.generator_name = 'uniform';
params.agent_signal_generator = @gauss_vector_generator; % handler do generatora sygna³u agenta
params.signal_generator_params = [];

params.signal_param = 1; % A
params.influence_parameter = 1; % J
params.influence_probability= 1; % p

%% market maker params
params.m = 100; % market maker multiplier param (balance (stocks) = m * agents_count)

params.full_name = ['abm_',params.generator_name,'_p',strrep(num2str(params.influence_probability),'.',''),...
    '_j',strrep(num2str(params.influence_parameter),'.',''),...
    '_a',strrep(num2str(params.signal_param),'.','')];
end


function check_basic_agent_params(testCase, balances, stocks, threshold, state, params)

verifyEqual(testCase,balances(:,:,1), ones(params.grid_size).*params.agent_start_balance);
verifyEqual(testCase,stocks(:,:,1), ones(params.grid_size).*params.agent_start_stocks);
verifyEqual(testCase, size(balances,3), params.simulation_length);
verifyEqual(testCase, size(stocks,3), params.simulation_length);
verifyEqual(testCase, size(threshold,3), params.simulation_length);
verifyEqual(testCase, size(state,3), params.simulation_length);

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

function clean_up(params)
delete([params.full_name,'_','signal.mat']);
delete([params.full_name,'_','threshold.mat']);
delete([params.full_name,'_','balances.mat']);
delete([params.full_name,'_','stocks.mat']);
delete([params.full_name,'_','state.mat']);
end