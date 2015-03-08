function [ market_maker ] = initialize_market_maker(sim_length, size, starting_price)
    
    m = 10;
    starting_balance = m * size(1)*size(2);

    market_maker.balance = initialize_array_field(sim_length, starting_balance*starting_price);
    market_maker.stocks = initialize_array_field(sim_length, starting_balance);
    market_maker.price = initialize_array_field(sim_length, starting_price);
    market_maker.volumen = initialize_array_field(sim_length, 0);

end

