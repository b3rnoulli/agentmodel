function tests = test_init_market_maker
tests = functiontests(localfunctions);
end


function test_initialize(testCase)
params = initialize_params();

market_maker = init_market_maker(params);

verifyEqual(testCase,length(market_maker.price), params.simulation_length);
verifyEqual(testCase,market_maker.price(1), params.starting_price);
verifyEqual(testCase,market_maker.balance(1), params.m.*params.grid_size(1).*params.grid_size(2));

end


function params = initialize_params()
params.simulation_length = 10000; 
params.grid_size = [100 100];
params.starting_price = 1;

params.m = 100;
end