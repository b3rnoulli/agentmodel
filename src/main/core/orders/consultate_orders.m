function [states] = consultate_orders(current_states, neighbours, signal, threshold)
states = current_states;
has_changed = 1;
round_counter = 0;
while has_changed > 0
    has_changed=0;
    round_counter = round_counter + 1;
    for i=1:1:size(current_states,1)*size(current_states,2)
        
        aggregated_signal = signal(i) + current_states(neighbours(i).elements(1).index).*neighbours(i).elements(1).influence_parameter ...
            + current_states(neighbours(i).elements(2).index).*neighbours(i).elements(2).influence_parameter ...
            + current_states(neighbours(i).elements(3).index).*neighbours(i).elements(3).influence_parameter ...
            + current_states(neighbours(i).elements(4).index).*neighbours(i).elements(4).influence_parameter;
        current_states(i) = resolve_single_agent_state(aggregated_signal, threshold(i));
        
        if(current_states(i) ~= states(i))
            has_changed = has_changed + 1;
            states(i) = current_states(i);
        end
    end
end
fprintf('Covergence after %d steps\n', round_counter);
end

