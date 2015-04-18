function [ signal ] = update_agent_signal(params)

signal(:,:,1) = params.agent_signal_generator(params.grid_size, params.signal_generator_params);


end

