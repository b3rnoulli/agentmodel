function [ threshold ] = update_agent_threshold(last_threshold, price)

threshold =  last_threshold.*price(1)./price(2);

end

