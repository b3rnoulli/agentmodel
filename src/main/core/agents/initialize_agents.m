function [balances, stocks, signal, signal_param, signal_generator, threshold, state, neighbours] = initialize_agents(size, sim_length, agent_start_balance, ...
    agent_start_stocks, agent_signal_param, agent_signal_generator, ...
    influence_parameter, influence_probability, symetrical_influence)

isposint = @(x)( ~isnumeric(x) | isinteger(x) ...
                 | ~all(isfinite(x(:))) ...
                 | ~isreal(x) ...
                 | ~(any(x(:) <= 0)));

if length(size) ~= 2 || ~isposint(size(1)) || ~isposint(size(2))
   error('Size should have two positive intiger values!') 
end

    balances = zeros(size(1),size(2), sim_length);
    stocks = zeros(size(1),size(2), sim_length);
    signal = zeros(size(1),size(2),sim_length);
    signal_param = ones(size(1),size(2)) * agent_signal_param;
    threshold = zeros(size(1),size(2), sim_length);
    state = zeros(size(1),size(2), sim_length);
    signal_generator = agent_signal_generator;

    for i=1:1:size(1)*size(2)
        balances(i) = agent_start_balance;
        stocks(i) = agent_start_stocks;
        signal(i) = agent_signal_generator()*signal_param(i);
        threshold(i) = abs(normrnd(0,1));
        state(i) = resolve_single_agent_state(signal(i), threshold(i));
        [x, y] = ind2sub([size(1) size(2)],i);
        neighbours(x,y).elements =  von_neumann_neighbours(i, size, influence_parameter, influence_probability);
    end
    

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


