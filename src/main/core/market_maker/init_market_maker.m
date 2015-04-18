function [ market_maker ] = init_market_maker(params)
    
    starting_balance = params.m * params.grid_size(1)*params.grid_size(2);

    market_maker.balance = initialize_array_field(params.simulation_length, starting_balance*params.starting_price);
    market_maker.stocks = initialize_array_field(params.simulation_length, starting_balance);
    market_maker.price = initialize_array_field(params.simulation_length, params.starting_price);
    market_maker.volumen = initialize_array_field(params.simulation_length, 0);

end

