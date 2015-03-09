function [ volumen, price] = update_price(market_maker, current_step, supply, demand, alpha_function, alpha_func_param, grid_size)

volumen = demand + supply;

price = market_maker.price(current_step-1) * (demand/supply)^alpha_function(alpha_func_param,volumen, grid_size);

end


