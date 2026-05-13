# Plots vector field of a finite solenoid of length h using the
# expressions from Martín-Luna et.al., "On the Magnetic Field of a
# Finite Solenoid", IEEE TRANSACTIONS ON MAGNETICS, VOL. 59, NO. 4,
# APRIL 2023

unset key
set size square
set grid
set xlabel "x/r_0"
set ylabel "z/r_0"
set samples 101
set isosamples 101
set xrange [-3:3]
set yrange [-3:3]
set urange [-3:3]
set vrange [-3:3]
set view map
set pm3d map
set pm3d interpolate 4,4
set palette defined (0 "white", 1 "black")
set colorbox
set cblabel "|B|"

B0 = 4*pi
h = 2 # h/r_0

# k_{\pm}, Eq.(11)
k(r,z,s) = sqrt(4.*r/((1. + r)**2 + (z + 0.5*s*h)**2))
kp(r,z) = k(r,z,1.) # k_+
km(r,z) = k(r,z,-1.) # k_-

# \sigma, Eq.(12)
sigma(r) = 4.*r/(1. + r)**2

# I_{\pm}, Eq.(9)
Ipm(r,z,k) = -4./sqrt(r)*(EllipticE(k)/k - (1. - 0.5*k**2)*EllipticK(k)/k)

# I'_{\pm}, Eq.(10), note missing +- sign in Eq.(10)
Jpm(r,z,k,s) = k/sqrt(r)*(z + 0.5*s*h)*((1. - r)/(1. + r)*EllipticPi(sigma(r),k) + EllipticK(k))

Ip(r,z) = Ipm(r,z,kp(r,z)) # I_+
Im(r,z) = Ipm(r,z,km(r,z)) # I_-
Jp(r,z) = Jpm(r,z,kp(r,z),1) # I'_+
Jm(r,z) = Jpm(r,z,km(r,z),-1) # I'_-

# limit r->0, Eq.(16)
Bz0(r,z) = 0.5*B0*((z + 0.5*h)/sqrt(1 + (z + 0.5*h)**2) - (z - 0.5*h)/sqrt(1 + (z - 0.5*h)**2))

# B_r(r,z), Eq.(5)
Br(r,z) = r == 0 ? 0 : B0/(4*pi)*(Im(r,z) - Ip(r,z))

# B_z(r,z), Eq.(6)
Brz(r,z) = r == 0 ? Bz0(r,z) : B0/(4*pi)*(Jp(r,z) - Jm(r,z))

# convert to cartesian coordinates
r(x,y,z) = sqrt(x**2 + y**2)
Bx(x,y,z) = r(x,y,z) == 0 ? 0 : Br(r(x,y,z),z)*cos(atan2(y,x))
By(x,y,z) = r(x,y,z) == 0 ? 0 : Br(r(x,y,z),z)*sin(atan2(y,x))
Bz(x,y,z) = Brz(r(x,y,z),z)
Ba(x,y,z) = sqrt(Br(r(x,y,z),z)**2 + Bz(x,y,z)**2)

##################################################

scale = 0.1

splot \
  "++" using 1:2:(Ba($1,0,$2)) with pm3d notitle, \
  "++" using 1:2:(0):(scale*Bx($1,0,$2)/Ba($1,0,$2)):(scale*Bz($1,0,$2)/Ba($1,0,$2)):(0) \
       every 2:2 with vectors head filled lc rgb "red" notitle

set arrow 1 from  1,(-h/2.) to  1,(h/2.) nohead lw 2 lc rgb "black"
set arrow 2 from -1,(-h/2.) to -1,(h/2.) nohead lw 2 lc rgb "black"
replot
