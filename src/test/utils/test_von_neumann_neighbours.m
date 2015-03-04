function tests = test_von_neumann_neighbours
    tests = functiontests(localfunctions);
end

function test_right_bounduary_position(testCase)
    size = [50, 50];
    influence_param = 1;
    result = von_neumann_neighbours(1 , size , influence_param, 1);
    expected = prepare_expected_position([50,1], [2,1], [1,50], [1,2], size, influence_param);
   
    verifyEqual(testCase,result,expected);
end

function test_left_bounduary_position(testCase)
    size = [50, 50];
    influence_param = 1;
    result = von_neumann_neighbours(2451 , size , influence_param, 1);
    expected = prepare_expected_position([50,50], [2,50], [1,49], [1,1], size, influence_param);
   
    verifyEqual(testCase,result,expected);
end

function test_middle_position(testCase)
    size = [50, 50];
    influence_param = 1;
    result = von_neumann_neighbours(52 , size , influence_param, 1);
    expected = prepare_expected_position([1,2], [3,2], [2,1], [2,3], size, influence_param);

    verifyEqual(testCase,result,expected);
end


function [expected] = prepare_expected_position(up, down, left, right,size, influence_param)
    expected(1).position = up;
    expected(2).position = down;
    expected(3).position = left;
    expected(4).position = right;
    for i=1:1:4
        expected(i).index = sub2ind(size, expected(i).position(1), expected(i).position(2));
        expected(i).influence_parameter = influence_param;
    end

    
end