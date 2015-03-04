function [ market_maker ] = initialize_marker_maker(sim_length, size, starting_price)
    
    m = 10;
    starting_balance = 10 * size(1)*size(2);

    market_maker.balance = initialize_array_field(sim_length, starting_balance*starting_price);
    market_maker.current_balance = starting_balance;
    market_maker.stocks = initialize_array_field(sim_length, starting_balance);
    market_maker.current_stocks = starting_balance;
    market_maker.price = initialize_array_field(sim_length, starting_price);
    market_maker.trading_volume = initialize_array_field(sim_length, 0);

end

