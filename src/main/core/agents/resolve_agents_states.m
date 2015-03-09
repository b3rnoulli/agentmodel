function [ states ] = resolve_agents_states(signal, threshold)

states = zeros(size(signal,1), size(signal,2));

states(signal>threshold) = 1;
states(signal<-threshold) = -1;

end

