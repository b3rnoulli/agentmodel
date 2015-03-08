function [ agents ] = initialize_agents(size, sim_length, agent_start_balance, ...
    agent_start_stocks, agent_signal_param, agent_signal_generator, ...
    influence_parameter, influence_probability, symetrical_influence)

isposint = @(x)( ~isnumeric(x) | isinteger(x) ...
                 | ~all(isfinite(x(:))) ...
                 | ~isreal(x) ...
                 | ~(any(x(:) <= 0)));

if length(size) ~= 2 || ~isposint(size(1)) || ~isposint(size(2))
   error('Size should have two positive intiger values!') 
end

    agents.balances = zeros(size(1),size(2), sim_length);
    agents.stocks = zeros(size(1),size(2), sim_length);
    agents.signal = zeros(size(1),size(2),sim_length);
    agents.signal_param = ones(size(1),size(2)) * agent_signal_param;
    agents.threshold = zeros(size(1),size(2), sim_length);
    agents.state = zeros(size(1),size(2), sim_length);
    agents.current_state = zeros(size(1),size(2));
    agents.signal_generator = agent_signal_generator;

    for i=1:1:size(1)*size(2)
        agents.balances(i) = agent_start_balance;
        agents.stocks(i) = agent_start_stocks;
        agents.signal(i) = agent_signal_generator()*agents.signal_param(i);
        agents.threshold(i) = abs(normrnd(0,1));
        agents.state(i) = resolve_single_agent_state(agents.signal(i), agents.threshold(i));
        agents.current_state(i) = agents.state(i);
        [x, y] = ind2sub([size(1) size(2)],i);
        agents.neighbours(x,y).elements =  von_neumann_neighbours(i, size, influence_parameter, influence_probability);
    end
    

% TODO - jak powinien byc przypisywany parametr oddzialywania w przypadku
% symetrycznym ? tzn jesli a na b = 1 ale b na a = 0 to ktora strone
% powinna byc symetryzacja?
if symetrical_influence == 1
   for i=1:1:(size(1)*size(2))
       agents.neighbours(i).elements(1).influence_parameter = agents.neighbours(agents.neighbours(i).elements(1).index).elements(2).influence_parameter;
       agents.neighbours(i).elements(2).influence_parameter = agents.neighbours(agents.neighbours(i).elements(2).index).elements(1).influence_parameter;
       agents.neighbours(i).elements(3).influence_parameter = agents.neighbours(agents.neighbours(i).elements(3).index).elements(4).influence_parameter;
       agents.neighbours(i).elements(4).influence_parameter = agents.neighbours(agents.neighbours(i).elements(4).index).elements(3).influence_parameter;
   end
end

end


