function [signal] = update_agent_signal(agent_signal_param, agent_signal_generator, generator_params, previous_value, size)

signal = agent_signal_generator(previous_value, ones(size).*generator_params).*agent_signal_param;

end

