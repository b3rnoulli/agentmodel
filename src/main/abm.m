clear
clc

agent_params.influence_parameter = 1;
agent_params.influence_probability= 1;
agent_params.signal_param = 0.2;

agent_params.simulation_name = ['abm_uniform_p',strrep(num2str(agent_params.influence_probability),'.',''),...
    '_j',strrep(num2str(agent_params.influence_parameter),'.',''),...
    '_a',strrep(num2str(agent_params.signal_param),'.','')]; % nazwa symulacji
agent_params.sim_length = 100000; % dlugosc symulacji
agent_params.size = [100, 100];
agent_params.memory_preserve = 1; % parametr okreslajacy sposób przechowywania danych
agent_params.starting_price = 1; % cena poczatkowa
agent_params.agent_start_balance = 100; % poczatkowy balance agenta
agent_params.agent_start_stocks = 100; % poczatkowe akcje agenta
agent_params.signal_param = ones(agent_params.size).*agent_params.signal_param; % parametr A sygnalu losowego agenta
agent_params.signal_generator_params = 0;
agent_params.agent_signal_generator = @uniform_generator; % handler do generatora sygna³u agenta
agent_params.correlated_signal = 0;
agent_params.signal_matfile = 0;
agent_params.alpha_func_param = 1;

alpha_function = @(param,volumen,grid_size) volume_depend_alpha_func(param, volumen, agent_params.size);

%inicjalizacja siatki
[balances, stocks, signal_m, threshold, state, neighbours] = initialize_agents(agent_params);
market_maker = initialize_market_maker(agent_params.sim_length, agent_params.size, agent_params.starting_price);

[market_maker, balances(:,:,1), stocks(:,:,1), state(:,:,1), supply, demand] ...
    =  fill_orders(1,market_maker,balances(:,:,1), stocks(:,:,1), state(:,:,1));

[market_maker.volumen(2), market_maker.price(2)] = update_price(market_maker, 2, supply, demand, alpha_function, agent_params.alpha_func_param, agent_params.size);

 balances(:,:,2)= balances(:,:,1);
 stocks(:,:,2)= stocks(:,:,1);

for i = 2:1:agent_params.sim_length
    threshold(:,:,i) = update_agent_threshold(threshold(:,:,i-1), [market_maker.price(i), market_maker.price(i-1)]);    
    state(:,:,i) = consultate_orders(place_orders(threshold(:,:,i), signal_m.signal(:,:,i)),...
        neighbours, signal_m.signal(:,:,i), threshold(:,:,i));
    
    [market_maker, balances(:,:,i), stocks(:,:,i), state(:,:,i), supply, demand] ...
    =  fill_orders(i,market_maker,balances(:,:,i), stocks(:,:,i), state(:,:,i));
    
    balances(:,:,i+1)= balances(:,:,i);
    stocks(:,:,i+1)= stocks(:,:,i);
    
    [market_maker.volumen(i+1), market_maker.price(i+1)] = update_price(market_maker, i+1, supply, demand, alpha_function, agent_params.alpha_func_param, agent_params.size);
    fprintf('Step %d done. Supply = %d, demand = %d, Price = %d, market balance = %.2f, market stocks = %.2f \n',i,supply, demand, market_maker.price(i), market_maker.balance(i), market_maker.stocks(i));
end

save(agent_params.simulation_name,'market_maker','balances','stocks','threshold','state', '-v7.3');
