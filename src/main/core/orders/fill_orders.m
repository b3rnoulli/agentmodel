function [market_maker, balances, stocks, states, supply, demand] = fill_orders(current_step, market_maker, ...
    balances, stocks, states)

%Function fills orders and changes agents state if necessary. Typically
%amount of active agents is less than 0.1*grid.size, so for better
%performance find active agents and double loop is used.

demand_agents_index = find(states > 0);
supply_agents_index = find(states < 0);
demand = 0;
supply = 0;
for i=1:1:size(demand_agents_index)
    if balances(demand_agents_index(i)) > market_maker.price(current_step) && market_maker.stocks(current_step) > 0
        market_maker.balance(current_step) = market_maker.balance(current_step) + market_maker.price(current_step);
        market_maker.stocks(current_step) = market_maker.stocks(current_step) - 1;
        balances(demand_agents_index(i)) = balances(demand_agents_index(i)) - market_maker.price(current_step);
        stocks(demand_agents_index(i)) = stocks(demand_agents_index(i)) + 1;
        demand = demand + 1;
    else
        states(demand_agents_index(i)) = 0;
    end
end

for i=1:1:size(supply_agents_index)
    if stocks(supply_agents_index(i)) > 0 && market_maker.balance(current_step) > market_maker.price(current_step) > 0
        market_maker.balance(current_step) = market_maker.balance(current_step) - market_maker.price(current_step);
        market_maker.stocks(current_step) = market_maker.stocks(current_step) + 1;
        balances(supply_agents_index(i)) = balances(supply_agents_index(i)) + market_maker.price(current_step);
        stocks(supply_agents_index(i)) = stocks(supply_agents_index(i)) - 1;
        supply = supply+1;
    else
        states(supply_agents_index(i)) = 0;
    end
end


market_maker.balance(current_step+1) = market_maker.balance(current_step);
market_maker.stocks(current_step+1) = market_maker.stocks(current_step);
end

