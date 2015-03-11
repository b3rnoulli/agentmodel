function [balances, stocks, signal, signal_param, signal_generator, threshold, state, neighbours] = initialize_agents(size, sim_length, agent_start_balance, ...
    agent_start_stocks, agent_signal_param, agent_signal_generator, signal_generator_params, ...
    influence_parameter, influence_probability, symetrical_influence, preserve_memory_mode)

isposint = @(x)( ~isnumeric(x) | isinteger(x) ...
                 | ~all(isfinite(x(:))) ...
                 | ~isreal(x) ...
                 | ~(any(x(:) <= 0)));

if length(size) ~= 2 || ~isposint(size(1)) || ~isposint(size(2))
   error('Size should have two positive intiger values!') 
end

signal_generator = agent_signal_generator;
signal_param = ones(size(1),size(2)) * agent_signal_param;

if preserve_memory_mode == 1
    signal = zeros(size(1),size(2),2);
    threshold = zeros(size(1),size(2),2);
else
    balances = zeros(size(1),size(2), sim_length);
    stocks = zeros(size(1),size(2), sim_length);
    signal = zeros(size(1),size(2),sim_length);
    threshold = zeros(size(1),size(2), sim_length);
    state = zeros(size(1),size(2), sim_length);
end
for i=1:1:size(1)*size(2)
    signal(i) = (agent_signal_generator(0,signal_generator_params))*signal_param(i);
    [x, y] = ind2sub([size(1) size(2)],i);
    neighbours(x,y).elements =  von_neumann_neighbours(i, size, influence_parameter, influence_probability);
end
[balances(:,:,1), stocks(:,:,1), state(:,:,1), threshold(:,:,1)] = initialize_first_step(size, agent_start_balance, agent_start_stocks, signal(:,:,1));

% TODO - jak powinien byc przypisywany parametr oddzialywania w przypadku
% symetrycznym ? tzn jesli a na b = 1 ale b na a = 0 to ktora strone
% powinna byc symetryzacja?
if symetrical_influence == 1
   for i=1:1:(size(1)*size(2))
       neighbours(i).elements(1).influence_parameter = neighbours(neighbours(i).elements(1).index).elements(2).influence_parameter;
       neighbours(i).elements(2).influence_parameter = neighbours(neighbours(i).elements(2).index).elements(1).influence_parameter;
       neighbours(i).elements(3).influence_parameter = neighbours(neighbours(i).elements(3).index).elements(4).influence_parameter;
       neighbours(i).elements(4).influence_parameter = neighbours(neighbours(i).elements(4).index).elements(3).influence_parameter;
   end
end

end


    function [balances, stocks, state, threshold] = initialize_first_step(size, agent_start_balance, agent_start_stocks, signal)
        balances = ones(size(1), size(2)).*agent_start_balance;
        stocks = ones(size(1),size(2)).*agent_start_stocks;
        threshold = abs(normrnd(0,1,size));
        state = resolve_agents_states(signal, threshold);
        
    end

