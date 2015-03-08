function tests = test_place_orders
tests = functiontests(localfunctions);
end

function test_correct_place_orders(testCase)

[threshold, signal] = initialize();
states = place_orders(threshold, signal);

for i=1:1:size(states,1)*size(states,2)
    if signal(i) > threshold(i) 
           verifyEqual(testCase, states(i), 1)
       elseif -threshold(i) < signal(i) && signal(i) < threshold(i) 
           verifyEqual(testCase, states(i), 0)
       elseif signal(i) < -threshold(i) 
           verifyEqual(testCase, states(i), -1)
       else
           error('Agent does not have state!');
    end 
end

end


function [threshold, signal] = initialize()
size = [10 10];
threshold =  abs(normrnd(0,1,[size]));
signal = 2.*rand(size)-1;

end