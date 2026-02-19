reset;

a = -0.15 + 0.23*I
b = 0.23*sqrt(26.0)
k = -imag((1 - a)/b) # Kutta condition

zs(w,s) = (w - a)/b + s*sqrt(w**2 - 1)*abs(b)/b**2;
z(w) = (abs(zs(w,1)) > 1.0 ? zs(w,1) : (abs(zs(w,-1)) > 1.0 ? zs(w,-1) : 0.0/0.0))
J(z) = (z + 1/z)/2;
F(z) = J(z) + I*k*log(z)

set xrange [-3:3]
set yrange [-3:3]

# save streamlines
unset key;
unset surface;
set view map;
set samples 250,2;
set isosamples 2,250;
set contour base;
set cntrparam levels incremental -3,0.1,3;
set table "streamlines.dat"
splot imag(F(z(x + I*y)))
unset table
unset contour

# Joukowski profile
set surface;
set parametric;
set samples 400;
t(z) = a + b*z;
circle(t) = cos(t) + I*sin(t);
profile(t) = J(t(circle(t)));

plot \
  "streamlines.dat" with lines lc rgb "red", \
  real(profile(t)),imag(profile(t)) with lines lw 3 lc rgb "black"

pause mouse close
