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

eps = 1e-12

fx(x,z,sgn) = sgn*Bx(x,0,z)/(Ba(x,0,z) + eps)
fz(x,z,sgn) = sgn*Bz(x,0,z)/(Ba(x,0,z) + eps)

# Plotgrenzen (Abbruchkriterium)
xmin=-3; xmax=3
zmin=-3; zmax=3

NBUF = 20001
array Xneg[NBUF]
array Zneg[NBUF]
array STEP[2]

# --- ein RK4-Schritt: schreibt Ergebnis nach STEP[] ---
function $rk4_step(x, z, ds, sgn) << EOF
   local k1x = ds*fx(x, z, sgn);
   local k1z = ds*fz(x, z, sgn);

   local k2x = ds*fx(x+0.5*k1x, z+0.5*k1z, sgn);
   local k2z = ds*fz(x+0.5*k1x, z+0.5*k1z, sgn);

   local k3x = ds*fx(x+0.5*k2x, z+0.5*k2z, sgn);
   local k3z = ds*fz(x+0.5*k2x, z+0.5*k2z, sgn);

   local k4x = ds*fx(x+k3x, z+k3z, sgn);
   local k4z = ds*fz(x+k3x, z+k3z, sgn);

   STEP[1] = x + (k1x + 2*k2x + 2*k3x + k4x)/6.0;
   STEP[2] = z + (k1z + 2*k2z + 2*k3z + k4z)/6.0;

   return 0
EOF

function $fieldline_rk4_poly(fname, x0, z0, ds, nmax, append) << EOF
   if (nmax+1 > NBUF) { print "ERROR: nmax+1 > NBUF"; exit; }

   local tol  = 2.0*ds;
   local tol2 = tol*tol;
   local left2 = (5.0*tol)*(5.0*tol);   # "weit genug weg" vom Seed
   local closed = 0;

   # 1) sgn=-1 integrieren und puffern
   local x = x0;
   local z = z0;
   local n = 0;
   local left = 0;
   do for [i=1:nmax] {
     Xneg[i] = x;  Zneg[i] = z;  n = i;

     tmp = $rk4_step(x, z, ds, -1);
     x = STEP[1];  z = STEP[2];

     # Abbruch: Box / Feld zu klein
     if (x<xmin || x>xmax || z<zmin || z>zmax) { break };
     if (Ba(x,0,z) < 1e-10) { break };

     # Rückkehrtest (erst wenn man vorher "weg" war)
     local d2 = (x-x0)**2 + (z-z0)**2;
     if (!left && d2 > left2) { left = 1; };

     if (left && d2 < tol2) {
        # explizit schließen (Seed als letzten Punkt ablegen)
        Xneg[i+1] = x0;  Zneg[i+1] = z0;  n = i+1;
        closed = 1;
        break;
     };
   }

   # 2) Ausgabe
   if (append) { set print fname append; } else { set print fname; };

   # neg. Ast rückwärts (liefert bei offenen Linien eine durchgehende Polylinie)
   do for [j=n:1:-1] { print Xneg[j], Zneg[j]; }

   # 3) nur wenn NICHT geschlossen: sgn=+1 integrieren und anhängen
   if (!closed) {
     x = x0; z = z0; left = 0;
     do for [i=1:nmax] {
       tmp = $rk4_step(x, z, ds, +1);
       x = STEP[1];  z = STEP[2];

       if (x<xmin || x>xmax || z<zmin || z>zmax) { break };
       if (Ba(x,0,z) < 1e-10) { break };

       print x, z;

       local d2 = (x-x0)**2 + (z-z0)**2;
       if (!left && d2 > left2) { left = 1; };

       if (left && d2 < tol2) {
         print x0, z0;   # sauber schließen
         break;
       };
     }
   }

   print ""   # Trenner zur nächsten Feldlinie
   set print
EOF

outfile0 = "fieldlines_00.dat"
outfile = "fieldlines_xz.dat"
Nx = 10
dx = 1.0/(Nx + 2)
xseed_min = 0.0 + dx
xseed_max = 1.0 - dx
first = 1 # is first line

tmp = $fieldline_rk4_poly(outfile0, 0, 0, 0.02, 20000, 0)

do for [ix=0:Nx] {
  x0 = xseed_min + (xseed_max - xseed_min)*ix/Nx
  tmp = $fieldline_rk4_poly(outfile, x0, 0, 0.02, 20000, (first?0:1))
  first = 0 # next lines are not the first line
}

set style line 1 lc rgb 'blue' lt 1 lw 0.5

# Feldlinien rechts + Spiegelung nach links
plot \
  outfile0 w l ls 1, \
  outfile w l ls 1, \
  outfile using (-$1):2 w l ls 1

set arrow 1 from  1,(-h/2.) to  1,(h/2.) nohead lw 2 lc rgb "black"
set arrow 2 from -1,(-h/2.) to -1,(h/2.) nohead lw 2 lc rgb "black"
replot
