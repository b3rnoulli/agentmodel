function tests = test_fill_orders
tests = functiontests(localfunctions);
end


% tests fill orders without agents state modification
function test_fill_orders1(testCase)
[market_maker, balances, stocks, states] = initialize();
[market_maker_result, balances_result, stocks_result, states_result] = fill_orders(1,market_maker, balances, stocks, states);
[supply_count, demand_count] = check_agents(testCase, market_maker, 1, balances, stocks, states,balances_result, stocks_result, states_result);
check_market_maker(testCase, market_maker, market_maker_result, supply_count, demand_count);
end

% tests fill orders with agents state modification
function test_fill_orders2(testCase)
[market_maker, balances, stocks, states] = initialize();
balances(1) = 0;
stocks(2) = 0;
states(1) = 1;
states(2) = -1;
[market_maker_result, balances_result, stocks_result, states_result] = fill_orders(1,market_maker, balances, stocks, states);
[supply_count, demand_count] = check_agents(testCase, market_maker, 1, balances, stocks, states,balances_result, stocks_result, states_result);
check_market_maker(testCase, market_maker, market_maker_result, supply_count, demand_count);
end


function [supply_count, demand_count] = check_agents(testCase, market_maker, current_step, balances, stocks, states,...
    balances_result, stocks_result, states_result)

demand_count = 0;
supply_count = 0;
for i=1:1:size(states,1)*size(states,2)
    if states_result(i) == 1
        demand_count = demand_count + 1;
        verifyEqual(testCase, balances_result(i), balances(i) - market_maker.price(current_step));
        verifyEqual(testCase, stocks_result(i), stocks(i) + 1);
    elseif states_result(i) == -1
        supply_count = supply_count + 1;
        verifyEqual(testCase, balances_result(i), balances(i) + market_maker.price(current_step));
        verifyEqual(testCase, stocks_result(i), stocks(i) - 1);
    elseif states_result(i) ==0
        verifyEqual(testCase, balances_result(i), balances(i));
        verifyEqual(testCase, stocks_result(i), stocks(i));
    else
        error(['Agent ', num2str(i), ' does not have state!']);
    end
end

end

function check_market_maker(testCase, market_maker, market_maker_result, supply, demand)

verifyEqual(testCase, market_maker_result.balance(1), market_maker.balance(1) + (demand-supply)*market_maker.price(1));
verifyEqual(testCase, market_maker_result.stocks(1), market_maker.stocks(1) + supply-demand);

end


function [market_maker, balances, stocks, states] = initialize()
sim_length = 1000;
starting_price = 1;
grid.size = [10 10];
market_maker = initialize_market_maker(sim_length, grid.size, starting_price);
balances = ones(grid.size)*100;
stocks = ones(grid.size)*100;
states = randi([-1, 1], grid.size);
end