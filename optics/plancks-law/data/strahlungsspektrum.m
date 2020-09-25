h = 6.62607015*^-34 J s;
c = 299792458 m/s;
k = 1.380649*^-23 J/K;

xscale = 10^-6;
um = xscale m; (* micro m *)

(* energy density per wave length interval,
   Eq.(3.17) from Demtroeder Bd.3 *)
w[l_,T_] := 8 Pi h c / l^5 * 1/(Exp[h c/(l k T)] - 1);

(* intensity = c times energy density *)
S[args__] := c w[args];

wien[l_] := S[l, 2.8977721*^-3 m K/l];

LogRange[start_, stop_, steps_] :=
    Exp /@ Range[Log[start], Log[stop], (Log[stop] - Log[start])/steps];

npoints = 100;
range = LogRange[0.1, 100, npoints] um;

GenerateData[T_] :=
    Module[{data},
           data = N[{#/um, S[#,T K] / (J/(m^2 s um))}]& /@ range;
           Export["T" <> ToString[T] <> "K.dat", data];
    ];

GenerateWien[] :=
    Module[{data},
           data = N[{#/um, wien[#] / (J/(m^2 s um))}]& /@ range;
           Export["wien.dat", data];
    ];

GenerateData[300];
GenerateData[500];
GenerateData[1000];
GenerateData[3000];
GenerateData[5777];
GenerateData[10000];

GenerateWien[];
