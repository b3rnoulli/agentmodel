function [signal] = update_agent_signal(agent_signal_param, agent_signal_generator, size)

signal = ones(size);
signal = arrayfun(@(signal) uniform_generator(), signal).*agent_signal_param;

end

