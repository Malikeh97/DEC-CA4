******** Digital Electronics, clocked SR latch Design*******


************ Library *************
.prot
.inc '32nm_bulk.pm'
.unprot

********* Params*******
.param			Lmin=32n
+Vdd=1V
.global  Vdd


****** Sources ******
Vinc				clk		0		pulse	  0	Vdd	2n	50p	50p	2n 4n
VSupply			Vs		0		DC		  Vdd
Vins				s		  0		pulse   0 Vdd  3n 50ps 50p 2n 1000ns
Vinr				r		  0		pulse   0 Vdd  5n 50ps 50p 2n 1000ns

****** SUBCKT and ******
.subckt andGate x y GND  SUPPLY out
Mp2				k		  x	 SUPPLY 	 SUPPLY		  pmos		l='Lmin'		w='Lmin*2'
Mp1				k		  y	 SUPPLY		 SUPPLY		  pmos		l='Lmin'		w='Lmin*2'
Mn1       s     x  GND       GND        nmos    l='Lmin'    w='Lmin*2'
Mn2       k     y  s         s          nmos    l='Lmin'    w='Lmin*2'
c1        k     GND   10f

Mp3				out		  k	 SUPPLY 	 SUPPLY		 pmos		 l='Lmin'		w='Lmin*2'
Mn3       out     k   GND     GND     nmos   l='Lmin'    w='Lmin'
c2        out     GND   5f

.ends andGate

****** SUBCKT nor ******
.subckt norGate x y GND  SUPPLY out
Mp1				d		  x	  SUPPLY 	 SUPPLY		  pmos		l='Lmin'		w='Lmin*4'
Mp2				out		  y	  d		     d		    pmos		l='Lmin'		w='Lmin*4'
Mn1       out     x   GND     GND       nmos    l='Lmin'    w='Lmin'
Mn2       out     y   GND     GND       nmos    l='Lmin'    w='Lmin'
c3        out     GND   10f
.ends norGate

****** Main Circuit *****
Xand1  s  clk  0 Vs y1 andGate
Xand2  clk  r  0 Vs y2 andGate
Xnor1  y1 q  0 Vs qb norGate
Xnor2  qb y2 0 Vs q  norGate


*********Type of Analysis***
.measure tran t_rise
+ trig V(q) val = '0.1*Vdd'  rise = 1
+ targ V(q) val = '0.9*Vdd'  rise = 1

.measure tran t_fall
+ trig V(q) val = '0.9*Vdd'  fall = 1
+ targ V(q) val = '0.1*Vdd'  fall = 1

.measure tran t_setup
+trig v(s)   val = 'v(Vdd)/2' fall = 1
+targ v(clk) val = 'v(Vdd)/2' rise = 1


.tran  0.1ns  20ns
.op
.end
