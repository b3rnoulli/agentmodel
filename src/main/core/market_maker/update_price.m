function [ volumen, price] = update_price(market_maker, current_step, supply, demand, params)

volumen = demand + supply;
price = market_maker.price(current_step-1) * (demand/supply)^volume_depend_alpha_func(params.alpha_func_param,volumen, params.grid_size);

end


