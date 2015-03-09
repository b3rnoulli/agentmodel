function tests = test_resolve_agents_states
tests = functiontests(localfunctions);
end


function test_resolve_all_agents_state(testCase)
grid_size = [10 10];
signal = rand(grid_size);
threshold = abs(normrnd(0,1, grid_size));
states = resolve_agents_states(signal,threshold);

for i=1:1:size(states,1)*size(states,2)
    if signal(i) >= threshold(i)
        verifyEqual(testCase, states(i), 1);
    elseif signal <= -threshold(i)
        verifyEqual(testCase, states(i), -1);
    elseif -threshold(i)<signal(i) && signal(i)<threshold(i)
        verifyEqual(testCase, states(i), 0);
    else
       error('Unresolved state!'); 
    end
end

end
