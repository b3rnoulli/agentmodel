clear
clc
sim_length = 50000; % dlugosc symulacji
starting_price = 1; % cena poczatkowa
agent_start_balance = 500; % poczatkowy balance agenta
agent_start_stocks = 500; % poczatkowe akcje agenta
agent_signal_params = 0.2; % parametr A sygnalu losowego agenta
generator_params = 0.3;
agent_signal_generator = @ar1_generator; % handler do generatora sygna³u agenta

alpha_func_param = 1;
alpha_function = @(param,volumen,grid_size) volume_depend_alpha_func(param, volumen, grid_size);

influence_parameter = 1;
influence_probability= 1;
symetrical_influence = 1;
preserve_memory = 1;
grid_size = [50, 50]; % rozmiar siatki

%inicjalizacja siatki
[balances, stocks, signal, signal_param, signal_generator, threshold, state, neighbours]...
    = initialize_agents(grid_size, sim_length, agent_start_balance,...
    agent_start_stocks, agent_signal_params, agent_signal_generator,generator_params, ...
    influence_parameter, influence_probability, symetrical_influence, 1);
market_maker = initialize_market_maker(sim_length, grid_size, preserve_memory);

[market_maker, balances(:,:,1), stocks(:,:,1), state(:,:,1), supply, demand] ...
    =  fill_orders(1,market_maker,balances(:,:,1), stocks(:,:,1), state(:,:,1));

[market_maker.volumen(2), market_maker.price(2)] = update_price(market_maker, 2, supply, demand, alpha_function, alpha_func_param, grid_size);

for i = 2:1:sim_length
    threshold(:,:,2) = update_agent_threshold(threshold(:,:,1), [market_maker.price(i), market_maker.price(i-1)]);
    signal(:,:,2) = update_agent_signal(agent_signal_params, agent_signal_generator, generator_params, signal(:,:,1), grid_size);
    
    [state(:,:,1) ] = place_orders(threshold(:,:,2),  signal(:,:,2));
    
    [state(:,:,1)] = consultate_orders(place_orders(threshold(:,:,2), signal(:,:,2)),...
        neighbours, signal(:,:,2), threshold(:,:,2));
    
    [market_maker, balances(:,:,1), stocks(:,:,1), state(:,:,1), supply, demand] ...
    =  fill_orders(i,market_maker,balances(:,:,1), stocks(:,:,1), state(:,:,1));
    
    threshold(:,:,1) = threshold(:,:,2);
    signal(:,:,1) = signal(:,:,2);
    [market_maker.volumen(i+1), market_maker.price(i+1)] = update_price(market_maker, i+1, supply, demand, alpha_function, alpha_func_param, grid_size);
    fprintf('Step %d done. Supply = %d, demand = %d, Price = %d, market balance = %.2f, market stocks = %.2f \n',i,supply, demand, market_maker.price(i), market_maker.balance(i), market_maker.stocks(i));
end

save('test','market_maker', '-v7.3');
