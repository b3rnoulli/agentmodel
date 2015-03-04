clear
clc
sim_length = 1000; % dlugosc symulacji
starting_price = 1; % cena poczatkowa
agent_start_balance = 100; % poczatkowy balance agenta
agent_start_stocks = 100; % poczatkowe akcje agenta
agent_signal_param = 1; % parametr A sygnalu losowego agenta
agent_signal_generator = @() uniform_generator; % handler do generatora sygna³u agenta

influence_parameter = 1;
influence_probability= .5;
symetrical_influence = 1;
grid.size = [100, 100]; % rozmiar siatki

marker_maker = initialize_marker_maker(sim_length,grid.size, starting_price);

%inicjalizacja siatki
grid.agents = initialize_agents(grid.size, sim_length, agent_start_balance,...
    agent_start_stocks, agent_signal_param, agent_signal_generator, ...
    influence_parameter, influence_probability, symetrical_influence);


