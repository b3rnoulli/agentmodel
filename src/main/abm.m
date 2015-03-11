clear
clc
tic
sim_length = 10000; % dlugosc symulacji
starting_price = 1; % cena poczatkowa
agent_start_balance = 100; % poczatkowy balance agenta
agent_start_stocks = 100; % poczatkowe akcje agenta
agent_signal_param = 0.2; % parametr A sygnalu losowego agenta
generator_params = 0;
agent_signal_generator = @uniform_generator; % handler do generatora sygna³u agenta

alpha_func_param = 1;
alpha_function = @(param,volumen,grid_size) volume_depend_alpha_func(param, volumen, grid_size);

influence_parameter = 1;
influence_probability= 1;
symetrical_influence = 1;
preserve_memory = 0;
grid_size = [100, 100]; % rozmiar siatki

%inicjalizacja siatki
[balances, stocks, signal, signal_param, signal_generator, threshold, state, neighbours] = initialize_agents(grid_size, sim_length, agent_start_balance,...
    agent_start_stocks, agent_signal_param, agent_signal_generator, generator_params, ...
    influence_parameter, influence_probability, symetrical_influence, preserve_memory);
market_maker = initialize_market_maker(sim_length, grid_size, starting_price);

[market_maker, balances(:,:,1), stocks(:,:,1), state(:,:,1), supply, demand] ...
    =  fill_orders(1,market_maker,balances(:,:,1), stocks(:,:,1), state(:,:,1));

[market_maker.volumen(2), market_maker.price(2)] = update_price(market_maker, 2, supply, demand, alpha_function, alpha_func_param, grid_size);

 balances(:,:,2)= balances(:,:,1);
 stocks(:,:,2)= stocks(:,:,1);

for i = 2:1:sim_length
    threshold(:,:,i) = update_agent_threshold(threshold(:,:,i-1), [market_maker.price(i), market_maker.price(i-1)]);
    signal(:,:,i) = update_agent_signal(agent_signal_param, agent_signal_generator,generator_params, signal(:,:,i-1), grid_size);

    [state(:,:,i) ] = place_orders(threshold(:,:,i),  signal(:,:,i));
    
    [state(:,:,i)] = consultate_orders(place_orders(threshold(:,:,i), signal(:,:,i)),...
        neighbours, signal(:,:,i), threshold(:,:,i));
    
    [market_maker, balances(:,:,i), stocks(:,:,i), state(:,:,i), supply, demand] ...
    =  fill_orders(i,market_maker,balances(:,:,i), stocks(:,:,i), state(:,:,i));
    
    balances(:,:,i+1)= balances(:,:,i);
    stocks(:,:,i+1)= stocks(:,:,i);
    
    [market_maker.volumen(i+1), market_maker.price(i+1)] = update_price(market_maker, i+1, supply, demand, alpha_function, alpha_func_param, grid_size);
    fprintf('Step %d done. Supply = %d, demand = %d, Price = %d, market balance = %.2f, market stocks = %.2f \n',i,supply, demand, market_maker.price(i), market_maker.balance(i), market_maker.stocks(i));
end


save('test','market_maker', '-v7.3');
toc