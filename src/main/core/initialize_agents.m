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

for i=1:1:(size(1)*size(2))
    agents(i).balance = initialize_array_field(sim_length, agent_start_balance);    
    agents(i).stocks = initialize_array_field(sim_length, agent_start_stocks);    
    agents(i).signal_param = agent_signal_param;
    agents(i).signal_generator = agent_signal_generator;
    agents(i).signal = agents(i).signal_generator()*agents(i).signal_param;
   
    agents(i).threshold = initialize_array_field(sim_length, normrnd(0,1));
    agents(i).state = initialize_array_field(sim_length,resolve_initial_state(agents(i).signal, agents(i).threshold(1)));
    agents(i).neighbours = von_neumann_neighbours(i, size, influence_parameter, influence_probability);
end

% TODO - jak powinien byc przypisywany parametr oddzialywania w przypadku
% symetrycznym ? tzn jesli a na b = 1 ale b na a = 0 to ktora strone
% powinna byc symetryzacja?
if symetrical_influence == 1
   for i=1:1:(size(1)*size(2))
       agents(i).neighbours(1).influence_parameter = agents(agents(i).neighbours(1).index).neighbours(2).influence_parameter;
       agents(i).neighbours(2).influence_parameter = agents(agents(i).neighbours(2).index).neighbours(1).influence_parameter;
       agents(i).neighbours(3).influence_parameter = agents(agents(i).neighbours(3).index).neighbours(4).influence_parameter;
       agents(i).neighbours(4).influence_parameter = agents(agents(i).neighbours(4).index).neighbours(3).influence_parameter;
   end
end

end

function state = resolve_initial_state(signal, threshold)
   
    if signal > threshold
        state = 1;
    elseif (-threshold<signal && signal<threshold)
        state = 0;
    elseif signal < - threshold
        state = -1;
    else
       error('Unresolved agent sate') 
    end

end

