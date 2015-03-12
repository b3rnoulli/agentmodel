function cdf_plotter(price, offset, data_name)

lrr = zscore(diff(log(price)));

[y,x] = ecdf(abs(lrr));
loglog(x,1-y);
hold on;

x_cutted = x(offset:end);
y_cutted = y(offset:end);
[xData, yData] = prepareCurveData( x_cutted, 1-y_cutted );

ft = fittype( 'a*(1./(x.^b))', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [0.707090443876139 0.0325859147932374];
try
[fitresult, gof] = fit( xData, yData, ft, opts );
 coeffs = coeffvalues(fitresult);

x_fit = 0.1:0.1:100;
y_fit = coeffs(1)*(1./((x_fit).^(coeffs(2))));
plot(x_fit,y_fit);
legend('Data', ['y ={',coeffs(1),'}/{x^{',coeffs(2),'}}']);
catch
end

xlim([0.2,100]);
ylim([10^-5,1]);



title(['1-CDF ',data_name])
saveas(gcf,['1-CDF ',data_name],'png');
end

