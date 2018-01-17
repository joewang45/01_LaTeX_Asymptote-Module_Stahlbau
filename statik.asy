// Asymptote-Modul zum Zeichnen statischer Systeme
// (z.B. fuer Klausuren)
// -----------------------------------------------
// Ian Krukow, 11.09.2013
// -----------------------------------------------

// -----------------------------------------------
// Linienstaerken

pen pensystem = defaultpen + 1;
pen penlager = defaultpen;
pen penlast = defaultpen;
pen penbemassung = defaultpen;

// Verschiebungen für Angelenke

real e1 = 0.12;
pair links = (-e1,0);
pair rechts = (e1,0);
pair oben = (0,e1);
pair unten = (0,-e1);
real e2 = 0.08;
pair obenlinks = (-e2,e2);
pair obenrechts = (e2,e2);
pair untenlinks = (-e2,-e2);
pair untenrechts = (e2,-e2);

// ----------------------------------------------
// Beschriftung

void ustring(pair p0, string sa, real size=fontsize(currentpen)){
     picture beschr;
     frame fr1;
     pen p=fontsize(size);

     pair a=(0,0);

     Label La1=Label(sa,a,p);

     path weg1=box(fr1,La1);

     pair lu=min(fr1);
     pair ru=max(fr1);

     real y=ypart(ru)-ypart(lu);
     real x=xpart(ru)-xpart(lu);
     real r;

     if(x>=y){
         r=x/2;
     }else{
         r=y/2;
     }
     pair li=a+(-r,0);
     pair ob=a+(0,r);
     pair re=a+(r,0);
     pair un=a+(0,-r);
     
     path linie=li..ob..re..un..cycle;

     draw(beschr,linie);

     label(beschr,La1,a,p);

     add(currentpicture,beschr,p0);
}

void textfeld (pair a, string s, real b, real x=1.0){
   label(scale(x)*minipage(s,b*cm),a,SE);
}

// -----------------------------------------------
// System

void balken (path a, pen pen=pensystem) {
    draw(a, pen);
}

void balkengestrichelt (pair p1, pair p2, real abstand=0.1,
                        pen penbalken=pensystem, pen penstrichelung=dashed) {
    draw(p1--p2, penbalken);
    real richtung = degrees(p2-p1) - 90;
    draw(shift(abstand*dir(richtung)) * (p1--p2), penstrichelung);
}

void gelenk (pair center, pair seite=(0,0),
             real radius=0.1, pen pen=penlager) {
    filldraw(circle(center+seite, radius), gray(1), pen);
}

void biegesteifeecke (pair p, int winkel1, int winkel2, real laenge=0.18) {
    pair p1 = rotate(winkel1, (0,0)) * (laenge,0);
    pair p2 = rotate(winkel2, (0,0)) * (laenge,0);
    path ecke = (0,0)--p1--p2--cycle;
    fill(shift(p) * ecke, gray(0));
}

void normalkraftgelenk (pair p, int winkel=0, pen pen=penlager, real breite=0.8) {

    path gelenk = (-breite/2,0)--(breite/2,0);
    pair position1 = p + (-sin(winkel*3.1428/180)*0.1,cos(winkel*3.1428/180)*0.1);
    pair position2 = p - (-sin(winkel*3.1428/180)*0.1,cos(winkel*3.1428/180)*0.1);
    
    path luecke=(-breite/4,0.1)--(breite/4,0.1)--(breite/4,-0.1)--(-breite/4,-0.1)--cycle;
    fill(shift(p)*rotate(winkel, (0,0))*luecke,white);
    
    draw(shift(position1) * rotate(winkel, (0,0)) * gelenk, pen);
    draw(shift(position2) * rotate(winkel, (0,0)) * gelenk, pen);
}

////////////Hinzugefügt von Felix am 11.9.2014 ////////////////////////////////////

void querkraftgelenk (pair p, int winkel=0, pen pen=penlager, real breite=0.9) {

    path einspann = (-breite/2,0)--(breite/2,0);

    pair position1 = p + (-sin(winkel*3.1428/180)*0.1,cos(winkel*3.1428/180)*0.1);
    pair position2 = p - (-sin(winkel*3.1428/180)*0.1,cos(winkel*3.1428/180)*0.1);

    pair positionrolle1=p - (cos(winkel*3.1428/180)*0.2,+sin(winkel*3.1428/180)*0.2);
    pair positionrolle2=p + (cos(winkel*3.1428/180)*0.2,+sin(winkel*3.1428/180)*0.2);

    path luecke=(-breite/4,0.1)--(breite/4,0.1)--(breite/4,-0.1)--(-breite/4,-0.1)--cycle;
    fill(shift(p)*rotate(winkel, (0,0))*luecke,white);

    draw(shift(position1) * rotate(winkel, (0,0)) * einspann, pen);
    draw(shift(position2) * rotate(winkel, (0,0)) * einspann, pen);
    
    gelenk(positionrolle1);
    gelenk(positionrolle2);

  
}
////////////////////////////////////////////////////////////////////////////////////

// -----------------------------------------------
// Auflager

//// Gabellager ////

////Gelenk-Kugeln mit eigener Strichstärke belegt - Felix 28.1.14
void lagerfest (pair p, int winkel=0, bool gelenk=true, pair seite=(0,0),
				pen pen=penlager,pen pengelenk=penlager,
                real seitenlaenge=0.5, pair festhaltung=(-0.11,-0.14)) {
	p += seite;
    pair p2 = rotate(-60, (0,0)) * (seitenlaenge,0);
    pair p3 = rotate(-120, (0,0)) * (seitenlaenge,0);
    path dreieck = (0,0)--p2--p3--cycle;
    draw(shift(p) * rotate(winkel, (0,0)) * dreieck, pen);
    path fest = shift(p3) * ((0,0)--scale(seitenlaenge*2)*festhaltung);
    path fest = shift(p3) * ((0,0)--scale(seitenlaenge*2)*festhaltung);
    draw(shift(p) * rotate(winkel,(0,0)) * fest, pen);
    draw(shift(p) * rotate(winkel,(0,0)) * shift((seitenlaenge/2,0))*fest,pen);
    draw(shift(p) * rotate(winkel,(0,0)) * shift((seitenlaenge,0))*fest,pen);
    if (gelenk) { gelenk(p,pen=pengelenk); }
}

void lagerverschieblich (pair p, int winkel=0, bool gelenk=true, pair seite=(0,0),
                         pen pen=penlager,pen pengelenk=penlager, real seitenlaenge=0.5,
                         real abstandlinie=0.15) {
	p += seite;
    pair p2 = rotate(-60, (0,0)) * (seitenlaenge,0);
    pair p3 = rotate(-120, (0,0)) * (seitenlaenge,0);
    path dreieck = (0,0)--p2--p3--cycle;
    draw(shift(p) * rotate(winkel, (0,0)) * dreieck, pen);
    path verschieblich = shift((0,-abstandlinie)) * (p2--p3);
    draw(shift(p) * rotate(winkel, (0,0)) * verschieblich, pen);
    if (gelenk) {
        gelenk(p,pen=pengelenk);
    }
}

void einspannung (pair p, int winkel=0, pen pen=penlager,
                  real breite=0.9, pair festhaltung=(-0.18,-0.23)) {
    path einspann = (-breite/2,0)--(breite/2,0);
    draw(shift(p) * rotate(winkel, (0,0)) * einspann, pen);
    path fest = (0,0)--scale(breite*1.75)*festhaltung;
    for (real ii=-0.5; ii<=0.5; ii+=0.25) {
      draw(shift(p)*rotate(winkel,(0,0))*shift((ii*breite,0))*fest, pen);
    }
}

////Gabellager////

void glagerverschieblich (pair p, int winkel=0, pair seite=(0,0),
                         pen pen=penlager,pen pengelenk=penlager, real seitenlaenge=0.5,
                         real abstandlinie=0.15) {
	p += seite; //locate the new point p; 
    pair p2 = rotate(-60, (0,0)) * (seitenlaenge,0);  
    pair p3 = rotate(-120, (0,0)) * (seitenlaenge,0);
	path dreieck = (0,0)--p2--p3--cycle;
    draw(shift(p) * rotate(winkel, (0,0)) * dreieck, pen);
    path verschieblich = shift((0,-abstandlinie)) * (p2--p3);
    draw(shift(p) * rotate(winkel, (0,0)) * verschieblich, pen);
// need debug with p != (0,0)
	pair p4 = rotate (60, p) * (seitenlaenge,0);
	pair p5 = rotate (120, p) * (seitenlaenge,0);
	draw (p--p4);
	draw (p--p5);
}

void glagerfest (pair p, int winkel=0, bool gelenk=true, pair seite=(0,0),
				pen pen=penlager,pen pengelenk=penlager,
                real seitenlaenge=0.5, pair festhaltung=(-0.11,-0.14)) {
	p += seite;
    pair p2 = rotate(-60, (0,0)) * (seitenlaenge,0);
    pair p3 = rotate(-120, (0,0)) * (seitenlaenge,0);
    path dreieck = (0,0)--p2--p3--cycle;
    draw(shift(p) * rotate(winkel, (0,0)) * dreieck, pen);
    path fest = shift(p3) * ((0,0)--festhaltung);
    path fest = shift(p3) * ((0,0)--festhaltung);
    draw(shift(p) * rotate(winkel,(0,0)) * fest, pen);
    draw(shift(p) * rotate(winkel,(0,0)) * shift((seitenlaenge/2,0))*fest,pen);
    draw(shift(p) * rotate(winkel,(0,0)) * shift((seitenlaenge,0))*fest,pen);
    if (gelenk) { gelenk(p,pen=pengelenk); }
// need debug with p != (0,0)
	pair p4 = rotate (60, p) * (seitenlaenge,0);
	pair p5 = rotate (120, p) * (seitenlaenge,0);
	draw (p--p4);
	draw (p--p5);
}

void gabellagerung (pair p0, string typ = "verschieblich",  real seitenlaenge = 0.5, int winkel = 0){
	
	pair p1 = p0 + ( - seitenlaenge * sin (1/6 * pi), seitenlaenge * cos (1/6 * pi) );
	pair p2 = p0 + ( seitenlaenge * sin (1/6 * pi), - seitenlaenge * cos (1/6 * pi) );
	pair p3 = p0 + ( seitenlaenge * sin (1/6 * pi), seitenlaenge * cos (1/6 * pi) );
	pair p4 = p0 + ( - seitenlaenge * sin (1/6 * pi), - seitenlaenge * cos (1/6 * pi) );
	path p1p2 = p1--p2;
	path p3p4 = p3--p4;
	path p4p2 = p4--p2;
	draw ( rotate (winkel, p0) * p1p2);
	draw ( rotate (winkel, p0) * p3p4);
	draw ( rotate (winkel, p0) * p4p2);
	
	if (typ == "verschieblich") { 
		draw ( (p4 + (0, - seitenlaenge /3 )) -- (p2 + (0, - seitenlaenge /3)) );
	}
	
	else if (typ == "fest") {
		for (int i = 0; i <= 4; ++i){
			draw ( (p4 + ( i * seitenlaenge / 4 , 0)) -- (p4 + ( i * seitenlaenge / 4 - 0.6 * seitenlaenge/3, -seitenlaenge / 3)));
		}
	}
		
}

void gelenklager (pair p0, string typ = "verschieblich",  real seitenlaenge = 0.5, int winkel = 0){
	
	pair p1 = p0 + ( - seitenlaenge * sin (1/6 * pi), seitenlaenge * cos (1/6 * pi) );
	pair p2 = p0 + ( seitenlaenge * sin (1/6 * pi), - seitenlaenge * cos (1/6 * pi) );
	pair p3 = p0 + ( seitenlaenge * sin (1/6 * pi), seitenlaenge * cos (1/6 * pi) );
	pair p4 = p0 + ( - seitenlaenge * sin (1/6 * pi), - seitenlaenge * cos (1/6 * pi) );
	path p0p2 = p0--p2;
	path p0p4 = p0--p4;
	path p4p2 = p4--p2;
	draw ( rotate (winkel, p0) * p0p2);
	draw ( rotate (winkel, p0) * p0p4);
	draw ( rotate (winkel, p0) * p4p2);
	
	if (typ == "verschieblich") { 
		draw ( (p4 + (0, - seitenlaenge /3 )) -- (p2 + (0, - seitenlaenge /3)) );
	}
	
	else if (typ == "fest") {
		for (int i = 0; i <= 4; ++i){
			draw ( (p4 + ( i * seitenlaenge / 4 , 0)) -- (p4 + ( i * seitenlaenge / 4 - 0.6 * seitenlaenge/3, -seitenlaenge / 3)));
		}
	}
		
}

////////////Hinzugefügt von Felix am 27.1.2014 ////////////////////////////////////

void querkraftlager (pair p, int winkel=0, pen pen=penlager,
                  real breite=0.9, pair festhaltung=(-0.18,-0.23)) {
    path einspann = (-breite/2,0)--(breite/2,0);
    pair position = p - (-sin(winkel*3.1428/180)*0.2,cos(winkel*3.1428/180)*0.2);
    pair positionrolle1=p - (-sin((winkel-66)*3.1428/180)*0.25,cos((winkel-66)*3.1428/180)*0.25);
    pair positionrolle2=p - (-sin((winkel+66)*3.1428/180)*0.25,cos((winkel+66)*3.1428/180)*0.25);
    draw(shift(p) * rotate(winkel, (0,0)) * einspann, pen);
    draw(shift(position) * rotate(winkel, (0,0)) * einspann, pen);
    gelenk(positionrolle1);
    gelenk(positionrolle2);
    path fest = (0,0)--festhaltung;
    for (real ii=-0.5; ii<=0.5; ii+=0.25) {
      draw(shift(position)*rotate(winkel,(0,0))*shift((ii*breite,0))*fest, pen);

   }
}
////////////////////////////////////////////////////////////////////////////////////

////////////Hinzugefügt von Felix am 11.9.2014 ////////////////////////////////////

void normalkraftlager (pair p, int winkel=0, pen pen=penlager, real breite=0.8) {
		
    path gelenk = (-breite/2,0)--(breite/2,0);
    pair position1 = p + (-sin(winkel*3.1428/180)*0.1,cos(winkel*3.1428/180)*0.1);
    pair position2 = p - (-sin(winkel*3.1428/180)*0.1,cos(winkel*3.1428/180)*0.1);		
		
    draw(shift(position1) * rotate(winkel, (0,0)) * gelenk, pen);
    draw(shift(position2) * rotate(winkel, (0,0)) * gelenk, pen);
		
    pair festhaltung=(-0.18,-0.23);
    pair festhaltung2=(-0.18,0.23);
		
    path fest = (0,0)--festhaltung;
    for (real ii=-0.5; ii<=0.5; ii+=0.25) {
    	draw(shift(position2)*rotate(winkel,(0,0))*shift((ii*breite,0))*fest, pen);
    }
		
    path fest2 = (0,0)--festhaltung2;
    for (real ii=-0.5; ii<=0.5; ii+=0.25) {
        draw(shift(position1)*rotate(winkel,(0,0))*shift((ii*breite,0))*fest2, pen);
    }
}
////////////////////////////////////////////////////////////////////////////////////

// Horizontalverschiebliche Einspanunng Tobi 20.2.14////////////////////////////////

void horizeinspann (pair p, int winkel=0, pen pen=penlager,
                  real breite=0.9, real abstand=0.4, pair festhaltung1=(0.18,-0.23),pair festhaltung2=(0.18,0.23)) {
    path einspann = (-breite/2,0)--(breite/2,0);
    draw(shift(p) *shift(0,-abstand/2)* rotate(winkel, (0,0)) * einspann, pen);
    draw(shift(p)*shift(0,abstand/2) * rotate(winkel, (0,0)) * einspann, pen);
    path fest1 = (0,0)--festhaltung1;
    path fest2 = (0,0)--festhaltung2;
    for (real ii=-0.5; ii<=0.5; ii+=0.25) {
      draw(shift(0,-abstand/2)*shift(p)*rotate(winkel,(0,0))*shift((ii*breite,0))*fest1, pen);
      draw(shift(0,abstand/2)*shift(p)*rotate(winkel,(0,0))*shift((ii*breite,0))*fest2, pen);
    }
}
///////////////////////////////////////////////////////////////////////////////////
	
////////////////////////////////////////////////////////////////////////////////////

/// Bettung horizontaler Stab Tobi 20.2.14

void bettung (pair p, real l, int winkel=0, pen pen=penlager,
               real doben=0.3, real dunten=0.3, real dfeder=0.1,
               real breitefeder=0.5, int nfederpunkte=6,
               real breitelager=0.5, pair festhaltung=(-0.11,-0.14)) {

for (real jj=0.5; jj<=l; jj+=1) {
	pair q = (jj,0);

        real y = -doben;
    path feder = (0,0)--(0,y);
    real x = -breitefeder/2;
    for (int ii=1; ii<=nfederpunkte; ii+=1) {
        feder = feder--(x,y-=dfeder);
        x = -x;
    }
    y -= dfeder;
    feder = feder--(0,y)--(0,y-=dunten);
    draw(shift(q)*shift(p) * rotate(winkel, (0,0)) * feder, pen);
    path einspann = (-breitelager/2,y)--(breitelager/2,y);
    draw(shift(q)*shift(p) * rotate(winkel, (0,0)) * einspann, pen);
    path fest = (0,0)--festhaltung;
    for (real ii=-0.5; ii<=0.5; ii+=0.5) {
      draw(shift(q)*shift(p)*rotate(winkel,(0,0))*shift((ii*breitelager,y))*fest, pen);
    }
  }
}

//////////////////////////////////////////////////////////////////////

void wegfeder (pair p, int winkel=0, pen pen=penlager,
               real doben=0.3, real dunten=0.3, real dfeder=0.1,
               real breitefeder=0.5, int nfederpunkte=6,
               real breitelager=0.5, pair festhaltung=(-0.11,-0.14)) {
    real y = -doben;
    path feder = (0,0)--(0,y);
    real x = -breitefeder/2;
    for (int ii=1; ii<=nfederpunkte; ii+=1) {
        feder = feder--(x,y-=dfeder);
        x = -x;
    }
    y -= dfeder;
    feder = feder--(0,y)--(0,y-=dunten);
    draw(shift(p) * rotate(winkel, (0,0)) * feder, pen);
    path einspann = (-breitelager/2,y)--(breitelager/2,y);
    draw(shift(p) * rotate(winkel, (0,0)) * einspann, pen);
    path fest = (0,0)--festhaltung;
    for (real ii=-0.5; ii<=0.5; ii+=0.5) {
      draw(shift(p)*rotate(winkel,(0,0))*shift((ii*breitelager,y))*fest, pen);
    }
}

void drehfeder (pair p, int winkel=0, pen pen=penlager,
                pair plager=(1,0.4), int winkellager=40,
                real breitelager=0.5, pair festhaltung=(-0.11,-0.14)) {
    pair c = plager/2;
    path feder = arc(c, plager, (0,0));
    draw(shift(p) * rotate(winkel, (0,0)) * feder, pen);
    transform tfeder = shift(p) * rotate(winkel,(0,0));
    transform tlager = shift(plager) * rotate(winkellager,(0,0));
    transform tgesamt = tfeder * tlager;
    path einspann = (-breitelager/2,0)--(breitelager/2,0);
    draw(tgesamt * einspann, pen);
    path fest = (0,0)--festhaltung;
    for (real ii=-0.5; ii<=0.5; ii+=0.5) {
        draw(tgesamt * shift((ii*breitelager,0)) * fest, pen);
    }
}

// -----------------------------------------------
// Lasten

void einzellast (pair p, int winkel=0, bool zumstab=true, string s="$F$", real abstand=0, real laenge=100,
                 pen pen=penlast, real arrowsize=8, real x=1.0) {
    path last = (0,abstand+laenge)--(0,abstand);
    arrowbar pfeil;
    if (zumstab) {
        pfeil = Arrow(size=arrowsize);
    } else {
        pfeil = BeginArrow(size=arrowsize);
    }
    draw(s,shift(p) * scale(x) * rotate(winkel, (0,0)) * last, pen, pfeil);
}

void wanderlast (pair p, int winkel=0, real abstand=0.1, real laenge=1.2,
                 pen pen=penlast, real arrowsize=8,
                 real punktabstand=0.35, real ypunkt=0.7, real radius=0.07) {
    einzellast(p, winkel, true, " ", abstand, laenge, pen, arrowsize);
    int[] xx = {-2, -1, 1, 2};
    for (int x : xx) {
        pair punkt = shift(p) * rotate(winkel,(0,0)) * (x*punktabstand,ypunkt);
        fill(circle(punkt, radius), gray(0));
    }
}

void einzelmoment (pair p, int winkel1=0, int winkel2=270,
                   bool counterclockwise=true, string s="M", align pos=NoAlign, real radius=0.5,
                   pen pen=penlast, int winkelabstand=10, real arrowsize=5) {
    if (counterclockwise) {
        winkel1 += winkelabstand;
        winkel2 -= winkelabstand;
    } else {
        winkel1 -= winkelabstand;
        winkel2 += winkelabstand;
    }
    path moment = arc(p, radius, winkel1, winkel2, counterclockwise);
    draw(s, moment, pos, pen, ArcArrow(size=arrowsize));
}

void streckenlast (pair p1, pair p2, bool zumstab=true, string s="q",pen pen=penlast,
                   real abstand=0.5, real laenge=0.6, real raster=0.5,
                   real arrowsize=5) {
    pair pdiff = p2 - p1;
    real stablaenge = length(pdiff);
    real stabwinkel = degrees(pdiff);
    real normal = stabwinkel + 90;
    path stab = p1--p2;
    align pos=E;
    if(stabwinkel<315){
      if(stabwinkel<225){
        if(stabwinkel<135){
          if(stabwinkel<45){
            pos=N;
          }
          else{
          pos=W;
          }
        }
        else{
        pos=S;
        }
      }
      else{
      pos=E;
      }
    }
    else{
      pos=N;
    }
    draw(shift(dir(normal)*abstand) * stab, pen);
    draw(s,shift(dir(normal)*(abstand+laenge)) * stab, pos, pen);
    path pfeil = (0,abstand+laenge)--(0,abstand);
    path pfeil = shift(p1) * rotate(stabwinkel, (0,0)) * pfeil;
    arrowbar spitze;
    if (zumstab) {
        spitze = Arrow(size=arrowsize);
    } else {
        spitze = BeginArrow(size=arrowsize);
    }
    int anzahl = round(stablaenge/raster)+1;
    real raster = stablaenge/anzahl;
    for (real ii=0; ii<=stablaenge; ii+=raster) {
        draw(shift(dir(stabwinkel)*ii) * pfeil, pen, spitze);
    }
}

// Timo 11.02.14/////////////////////////////////////////////////////////////////
void streckenlastdehnstab (pair p1, pair p2, bool zumstab=true, string s="p", pen pen=penlast,
                   real abstand=0.5, real laenge=0.5, real raster=0.5,
                   real arrowsize=5) {
    pair pdiff = p2 - p1;
    real stablaenge = length(pdiff);
    real stabwinkel = degrees(pdiff);
    real normal = stabwinkel + 90;
    align pos=E;
    if(stabwinkel<315){
      if(stabwinkel<225){
        if(stabwinkel<135){
          if(stabwinkel<45){
            pos=N;
          }
          else{
          pos=W;
          }
        }
        else{
        pos=S;
        }
      }
      else{
      pos=E;
      }
    }
    else{
      pos=N;
    }
    path stab = p1--p2;
    draw(shift(dir(normal)*abstand) * stab, pen);
    draw(s,shift(dir(normal)*(abstand+laenge)) * stab, pos, pen);
    path rand1 = p1--p1+(0,laenge);
    path rand1 = rotate(stabwinkel, p1) * rand1;
    draw(shift(dir(normal)*abstand) * rand1, pen);
    path rand2 = p2--p2+(0,laenge);
    path rand2 = rotate(stabwinkel, p2) * rand2;
    draw(shift(dir(normal)*abstand) * rand2, pen);
    int anzahl = round(stablaenge/raster);
    real raster = stablaenge/anzahl;
    path pfeil = p1--p1+(raster,0);
    path pfeil = rotate(stabwinkel, p1) * pfeil;
    arrowbar spitze;
    if (zumstab) {
        spitze = Arrow(size=arrowsize);
    } else {
        spitze = BeginArrow(size=arrowsize);
    }
    for (real ii=0; ii<=stablaenge-raster; ii+=raster) {
        draw(shift(dir(normal)*(abstand+0.5*laenge)) * shift(dir(stabwinkel)*ii) * pfeil, pen, spitze);
    }
}
//////////////////////////////////////////////////////////////////////////////////

// -----------------------------------------------
// Bemassung
// Ergaenzung: Komma statt Punkt (SH 19.03.2014)

void bemassunghorizontal (real[] laengen, real x0=0, real y=-1.5,
                          pen pen=penbemassung, arrowbar bar=Bars(size=8), arrowbar bar2=Arrows(size=6)) {
    for (real l : laengen) {
        real x1 = x0 + l;
	string s = (string) l;
	s = replace(s, ".", ",");
        draw(s, (x1,y)--(x0,y), N, pen, bar, bar2);
        x0 = x1;
    }
}

// Timo 11.02.14
void bemassunghorizontalwert (real[] laengen, real x0=0, real y=-1.5, string s="",
                          pen pen=penbemassung, arrowbar bar=Bars(size=8), arrowbar bar2=Arrows(size=6)) {
    for (real l : laengen) {
        real x1 = x0 + l;
        draw(s, (x1,y)--(x0,y), pen, bar, bar2);
        x0 = x1;
    }
}

// Ergaenzung: Komma statt Punkt (SH 19.03.2014)
void bemassungvertikal (real[] laengen, real y0=0, real x=-1.5,
                        pen pen=penbemassung, arrowbar bar=Bars(size=8), arrowbar bar2=Arrows(size=6)) {
    for (real l : laengen) {
        real y1 = y0 + l;
        string s = (string) l;
        s = replace(s, ".", ",");
        draw((x,y1)--(x,y0), pen, bar, bar2);
        real ylabel = y0 + l/2;
        Label s = rotate(90) * Label(s);
        label(s, (x,ylabel), W);
        y0 = y1;
    }
}

void bemassungvertikalwert (real[] laengen, real y0=0, real x=-1.5, string s="",
                        pen pen=penbemassung, arrowbar bar=Bars(size=8), arrowbar bar2=Arrows(size=6)) {
    for (real l : laengen) {
        real y1 = y0 + l;
        draw((x,y1)--(x,y0), pen, bar, bar2);
        real ylabel = y0 + l/2;
        Label s = rotate(90) * Label(s);
        label(s, (x,ylabel), W);
        y0 = y1;
    }
}

void einheit (pair position, string einheit="m") {
    label("[" + einheit + "]", position);
}

void knoten (string name, pair p, align richtung) {
    label(name, p, richtung);
}
//////////////////////////////////////////////////////////////////////////////////

// -----------------------------------------------
// Momentenlinie voreingestellte Fälle für ql^2/8 und PL/4 (Hendrik Jahns 22.01.14)

void verlauf (pair a, pair e, real ma=1, real mp=0, real me=ma, bool parabe=true, bool werte=true, 
              real lges=15, real mmax=ma, align pos=NoAlign, pen pen1=penlager){
	if(mmax!=ma){
	}else{
	    if(abs(ma)<=abs(me)){
	       mmax=abs(me);}
	    else{
	       mmax=abs(ma);}
	}
	pen pen2=pen1+MoveQuiet;
	real x1=xpart(a);
	real x2=xpart(e);
	real y1=ypart(a);
	real y2=ypart(e);
	real xges=x2-x1;
	real yges=y2-y1;
	real l2=sqrt(xges^2+yges^2);
	real de;
	if(xges!=0){
		de=atan(yges/xges);
	}
	else{
		if(yges>0){
			de=pi/2;
		}
		else if(yges<0){
			de=-pi/2;
		}
		else{
			de=0;
		}
	}
	real q=mp*8/(l2^2);
	pair m=a+(l2/2*cos(de),l2/2*sin(de));
	path p=a--e;
	draw(p,defaultpen+2);
	real massstab=lges/(5*abs(mmax));
	real mass=l2/30;
	real parabel(real x) {return massstab*((q*l2*x)/2-(q*x^2)/2);}
	real dreieck(real x) {return massstab*(((-ma+me)/l2*x)+ma);}
	if(parabe==true){
		guide mlinie;
		for(int i=0; i <= l2/mass; ++i) {
			real t=i*mass;
			pair z=a+(t*cos(de)+(parabel(t)+dreieck(t))*sin(de),t*sin(de)-(parabel(t)+dreieck(t))*cos(de));
			mlinie=mlinie..z;
		}
		draw(mlinie,pen1);
	}
	else{
		pair za=a+(dreieck(0)*sin(de),-(dreieck(0))*cos(de));
		pair zp=m+((massstab*mp+dreieck(l2/2))*sin(de),-(massstab*mp+dreieck(l2/2))*cos(de));
		pair ze=e+((dreieck(l2))*sin(de),-(dreieck(l2))*cos(de));
		path mlinie=za--zp--ze;
		draw(mlinie,pen1);
	}
	if(mp!=0){
		guide slinie;
		for(int i=0; i <= l2/mass; ++i) {
			real t=i*mass;
			pair z=a+(t*cos(de)+dreieck(t)*sin(de),t*sin(de)-dreieck(t)*cos(de));
			slinie=slinie..z;
		}
		draw(slinie,pen1+dashed);
	}
	pair aa;
	if(ma!=0){
		if(werte==true){
			string s1 = (string) ma;
			s1 = replace(s1, ".", ",");
			aa=(a+(dreieck(0)*sin(de),-dreieck(0)*cos(de)));
			draw(a--aa,pen1);
			if(dreieck(0)>0){
				draw(Label(s1,pen2,Fill(white)),aa--a,pen1);
			}
			else{
				draw(Label(s1,pen2,Fill(white)),a--aa,pen1);
			}
		}
		
	}
	if(mp!=0){
		if(werte==true){
			string s2 = (string) mp;
			s2 = replace(s2, ".", ",");
			pair mma=(m+((dreieck(l2/2))*sin(de),-(dreieck(l2/2))*cos(de)));
			pair mme=(m+((dreieck(l2/2)+parabel(l2/2))*sin(de),-(dreieck(l2/2)+parabel(l2/2))*cos(de)));
			draw(Label(s2,pen2,Fill(white)),mma--mme,pos,pen1);
		}
		pair mma=(m+((dreieck(l2/2))*sin(de),-(dreieck(l2/2))*cos(de)));
		pair mme=(m+((dreieck(l2/2)+parabel(l2/2))*sin(de),-(dreieck(l2/2)+parabel(l2/2))*cos(de)));
		draw(mma--mme,pen1);
	}
	if(me!=0){
		if(werte==true){
			string s3 = (string) me;
			s3 = replace(s3, ".", ",");
			pair ee=(e+(dreieck(l2)*sin(de),-dreieck(l2)*cos(de)));
			if(dreieck(l2)<0){
				draw(Label(s3,pen2,Fill(white)) ,ee--e,pen1);
			}
			else{
				draw(Label(s3,pen2,Fill(white)) ,e--ee,pen1);
			}
		}
		pair ee=(e+(dreieck(l2)*sin(de),-dreieck(l2)*cos(de)));
		draw(e--ee,pen1);
	}
}

// -----------------------------------------------
// Profile

void profil (pair a, string s="IPE", real alpha=0, string s2=" ", real mass=0.5, bool el=false,
              string s3="p2", int winkel=0, pen p=pensystem+1){
  real b=100;
  real h=100;
  
  if(s=="IPE"){
      b=0.5*mass;
      h=1.0*mass;
  }
  else{
      b=0.75*mass;
      h=0.75*mass;
  }
  
  pair p1=a+(-b/2,h/2);
  pair p2=a+(0,h/2);
  pair p3=a+(b/2,h/2);
  pair p4=a+(0,-h/2);
  pair p5=a+(-b/2,-h/2);
  pair p6=a+(b/2,-h/2);
  
  draw(rotate(alpha, a) * (p1--p3--p2--p4--p5--p6),p);

  if(alpha==90){
      label(s2,rotate(alpha, a)*p6,SE);
  }
  else{
      label(s2,p6,E);
  }

  if(el==true){
      if(s3=="p1"){
          einzellast (p1, winkel, true, "", 0.1 , 1.2, penlast, 8, 0.5);
      	}else{
      if(s3=="p2"){
          einzellast (p2, winkel, true, "", 0.1 , 1.2, penlast, 8, 0.5);
      	}else{
      if(s3=="p3"){
          einzellast (p3, winkel, true, "", 0.1 , 1.2, penlast, 8, 0.5);
      	}else{
      if(s3=="p4"){
          einzellast (p4, winkel, true, "", 0.1 , 1.2, penlast, 8, 0.5);
      	}else{
      if(s3=="p5"){
          einzellast (p5, winkel, true, "", 0.1 , 1.2, penlast, 8, 0.5);
     	 }else{
      if(s3=="p6"){
          einzellast (p6, winkel, true, "", 0.1 , 1.2, penlast, 8, 0.5);
      	}}}}}}}
}

