clear
clc

%% simulation params
params.simulation_length = 100000; 
params.grid_size = [50 50];
params.starting_price = 1;

%% agents params
params.agent_start_balance = 100;
params.agent_start_stocks = 100;
params.alpha_func_param = 1;
params.generator_name = 'uniform';
params.agent_signal_generator = @uniform_generator; % handler do generatora sygna³u agenta
params.signal_generator_params = [];

params.signal_param = 1; % A
params.influence_parameter = 1; % J
params.influence_probability= 1; % p

%% market maker params
params.m = 100; % market maker multiplier param (balance (stocks) = m * agents_count)

params.full_name = ['abm_',params.generator_name,'_p',strrep(num2str(params.influence_probability),'.',''),...
    '_j',strrep(num2str(params.influence_parameter),'.',''),...
    '_a',strrep(num2str(params.signal_param),'.','')];


%% system initialization
[balances, stocks, signal, threshold, state, neighbours] = init_agents_memory_preserve(params);
market_maker = init_market_maker(params);

[market_maker, balances(:,:,1), stocks(:,:,1), state(:,:,1), supply, demand] ...
    =  fill_orders(1,market_maker,balances(:,:,1), stocks(:,:,1), state(:,:,1));

[market_maker.volumen(2), market_maker.price(2)] = update_price(market_maker, 2, supply, demand, params);

try
    for i = 2:1:params.simulation_length
        % threshold and signal update
        threshold(:,:,2) = update_agent_threshold(threshold(:,:,1), [market_maker.price(i), market_maker.price(i-1)]);
        signal(:,:,2) = update_agent_signal(params);
        
        % place initial orders and consultate them
        state(:,:,1) = consultate_orders(place_orders(threshold(:,:,2), signal(:,:,2)),...
            neighbours, signal(:,:,2), threshold(:,:,2));
        
        % filling orders
        [market_maker, balances(:,:,1), stocks(:,:,1), state(:,:,1), supply, demand] ...
            =  fill_orders(i,market_maker,balances(:,:,1), stocks(:,:,1), state(:,:,1));
        
        threshold(:,:,1) = threshold(:,:,2);
        signal(:,:,1) = signal(:,:,2);
        [market_maker.volumen(i+1), market_maker.price(i+1)] = update_price(market_maker, i+1, supply, demand, params);
        fprintf('Step %d done. Supply = %d, demand = %d, Price = %d, market balance = %.2f, market stocks = %.2f \n',i,supply, demand, market_maker.price(i), market_maker.balance(i), market_maker.stocks(i));
    end
catch ME
    fprintf('ERROR! - saving files\n');
    display(ME);
end

save(params.full_name,'market_maker','-v7.3');
