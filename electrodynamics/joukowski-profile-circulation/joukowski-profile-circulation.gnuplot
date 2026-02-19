a = -0.2 + 0.5*I
b = 1.3
k = (imag(a)*real(b) + (1 - real(a))*imag(b))/(real(b)**2 + imag(b)*imag(b))
zs(w,s) = (w - a)/b + s*sqrt(w**2 - 1)*abs(b)/b**2;
z(w) = (abs(zs(w,1)) > 1.0 ? zs(w,1) : (abs(zs(w,-1)) > 1.0 ? zs(w,-1) : 0.0/0.0))
F(z) = (z + 1/z)/2 + I*k*log(z)

unset key;
unset surface;
set view map;
set size square;
set samples 250,2;
set isosamples 2,250;
set contour base;
set cntrparam levels incremental -4,0.15,4;
set cntrlabel onecolor;
splot [-4:4] [-4:4] imag(F(z(x + I*y))) lc 'red'
pause mouse close
