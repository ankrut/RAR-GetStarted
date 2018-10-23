function m = mantissa(x,prec)
d = floor(log10(x));
m = floor(10^(prec - d)*x)*10^(-prec);