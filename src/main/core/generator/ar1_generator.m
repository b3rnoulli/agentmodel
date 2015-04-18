function [val] = ar1_generator(sim_length, generator_params)
    model = arima('Constant',0,'AR',{generator_params},'Variance',1);
    val = simulate(model,sim_length)
end