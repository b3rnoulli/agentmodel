function simple_plotter(data_name, load_data)
     if load_data == 1
        load(data_name);
    end
    do_simple_plot(market_maker, data_name);
end

