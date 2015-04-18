function tests = test_init_first_step
tests = functiontests(localfunctions);
end


function first_step_test(testCase)
params = initialize_params();

signal(:,:,1) = params.agent_signal_generator(params.grid_size, params.signal_generator_params);
[balances, stocks, state, threshold] = init_first_step(params, signal);

verifyEqual(testCase,balances, ones(params.grid_size).*100);
verifyEqual(testCase,stocks, ones(params.grid_size).*100);

verifyEqual(testCase, ~any(any(signal == 0)),true);
verifyEqual(testCase, ~any(any(threshold == 0)),true);
end


function params = initialize_params()
params.grid_size = [100 100];
params.signal_generator_params = [];
params.agent_signal_generator = @uniform_generator;
params.agent_start_stocks = 100;
params.agent_start_balance = 100;
end