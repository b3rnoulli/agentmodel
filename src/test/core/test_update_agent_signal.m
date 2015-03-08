function tests = test_update_agent_signal
tests = functiontests(localfunctions);
end


function test_correct_update_agent_signal(testCase)
size = [10 10];
signal = update_agent_signal(1,@() uniform_generator, size)

end