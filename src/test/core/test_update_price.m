function tests = test_update_price
tests = functiontests(localfunctions);
end



function test_correct_update_price(testCase)
grid_size = [100 100];
market_maker = initialize_market_maker(1000, grid_size, 1);
supply = 100;
demand = 100;
alpha_func_param = 1;
alpha_function = @(param,volumen,grid_size) volume_depend_alpha_func(param, volumen, grid_size);
[market_maker.volumen, market_maker.price(2)] = update_price(market_maker, 2, supply, demand, alpha_function, alpha_func_param, grid_size);
%     TODO -
end

