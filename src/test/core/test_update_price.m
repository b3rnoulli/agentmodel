function tests = test_update_price
tests = functiontests(localfunctions);
end



function test_correct_update_price(testCase)
params = initialize_params();

market_maker = init_market_maker(params);
supply = 100;
demand = 100;
[market_maker.volumen, market_maker.price(2)] = update_price(market_maker, 2, supply, demand, params);

verifyEqual(testCase,market_maker.price(1),market_maker.price(2));

end


function params = initialize_params()
params.simulation_length = 10000; 
params.grid_size = [100 100];
params.starting_price = 1;
params.alpha_func_param = 1;

params.m = 100;
end