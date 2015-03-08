clear
clc
sim_length = 10000; % dlugosc symulacji
starting_price = 1; % cena poczatkowa
agent_start_balance = 100; % poczatkowy balance agenta
agent_start_stocks = 100; % poczatkowe akcje agenta
agent_signal_param = 0.2; % parametr A sygnalu losowego agenta
agent_signal_generator = @() uniform_generator; % handler do generatora sygna³u agenta

alpha_func_param = 1;
alpha_function = @(param,volumen,grid_size) volume_depend_alpha_func(param, volumen, grid_size);

influence_parameter = 1;
influence_probability= 1;
symetrical_influence = 1;
grid.size = [100, 100]; % rozmiar siatki

%inicjalizacja siatki
grid.agents = initialize_agents(grid.size, sim_length, agent_start_balance,...
    agent_start_stocks, agent_signal_param, agent_signal_generator, ...
    influence_parameter, influence_probability, symetrical_influence);
market_maker = initialize_market_maker(sim_length, grid.size, starting_price);

[market_maker, grid.agents.balances(:,:,1), grid.agents.stocks(:,:,1), grid.agents.state(:,:,1), supply, demand] ...
    =  fill_orders(1,market_maker,grid.agents.balances(:,:,1), grid.agents.stocks(:,:,1), grid.agents.state(:,:,1));

[market_maker.volumen(2), market_maker.price(2)] = update_price(market_maker, 2, supply, demand, alpha_function, alpha_func_param, grid.size);

 grid.agents.balances(:,:,2)= grid.agents.balances(:,:,1);
 grid.agents.stocks(:,:,2)= grid.agents.stocks(:,:,1);

for i = 2:1:sim_length
    grid.agents.threshold(:,:,i) = update_agent_threshold(grid.agents.threshold(:,:,i-1), [market_maker.price(i), market_maker.price(i-1)]);
    grid.agents.signal(:,:,i) = update_agent_signal(agent_signal_param, agent_signal_generator, grid.size);
    
    [grid.agents.state(:,:,i) ] = place_orders(grid.agents.threshold(:,:,i),  grid.agents.signal(:,:,i));
    
    [grid.agents.state(:,:,i)] = consultate_orders(place_orders(grid.agents.threshold(:,:,i), grid.agents.signal(:,:,i)),...
        grid.agents.neighbours, grid.agents.signal(:,:,i), grid.agents.threshold(:,:,i));
    
    [market_maker, grid.agents.balances(:,:,i), grid.agents.stocks(:,:,i), grid.agents.state(:,:,i), supply, demand] ...
    =  fill_orders(i,market_maker,grid.agents.balances(:,:,i), grid.agents.stocks(:,:,i), grid.agents.state(:,:,i));
    
    grid.agents.balances(:,:,i+1)= grid.agents.balances(:,:,i);
    grid.agents.stocks(:,:,i+1)= grid.agents.stocks(:,:,i);
    
    [market_maker.volumen(i+1), market_maker.price(i+1)] = update_price(market_maker, i+1, supply, demand, alpha_function, alpha_func_param, grid.size);
    fprintf('Step %d done. Price = %d, market balance = %.2f, market stocks = %.2f \n',i,market_maker.price(i), market_maker.balance(i), market_maker.stocks(i));
end
