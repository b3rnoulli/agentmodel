function simple_plotter(data_name)
    x_label = 'time';
    y_label = 'price';
    load(data_name);
    fig = subplot(2,1,1);
    set(gcf,'Visible','off');
    plot(market_maker.price);
    rep_name = strrep(strrep(data_name,'.mat',''),'_','-');
    title(['Price - ',rep_name]);
    xlabel(x_label);
    ylabel(y_label);
    subplot(2,1,2);
    plot(diff(log(market_maker.price)));
    title(['Log returns - ',rep_name]);
    xlabel(x_label);
    ylabel(y_label);
    saveas(fig,['price_rr - ',rep_name],'png');
end

