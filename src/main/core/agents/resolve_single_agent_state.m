function state = resolve_single_agent_state(signal, threshold)  
    
    if (-threshold<signal && signal<threshold) 
        state = 0;
    elseif signal > threshold
        state = 1;
    elseif signal < - threshold
        state = -1;
    else
       error('Unresolved agent state') 
    end
end

