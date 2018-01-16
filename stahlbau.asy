// Asymptote-Modul zum Zeichnen konstruktiver Skizzen------------------------------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------------------------
// Hendrik Jahns 27.01.2015--------------------------------------------------------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------------------------
// 30.08.2017 "stahlbau.asy" renamed - Anzhi 
// ------------------------------------------------
      
	  import graph;
      import patterns;
      add("stahl",hatch(3));
      add("beton",beton());
      add("white",color(white));
      add("black",color(black));
	  add("estrich",estrich());
// --------------------------------------------------------------------------------------------------------------------------------
// Grundlegende Getter-Methoden----------------------------------------------------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------------------------

/// get profil parameter
 real profil_parameter (string n = "HEA300", string m = "b")
 {
	include profile;
	
	real p;
	int pos;
	
	string profil_typ=substr(n,0,3); // get the following 3 letters from position 0 inside string n
	string profil_nr=substr(n,3,-1); // get all the rest letters from position 3 inside string n 
	
	if (m == "b") { pos = 1;}
	else if (m == "h") { pos = 0;}
	else if (m == "tw") { pos = 2;}
	else if (m == "tf") { pos = 3;}
	else if (m == "r") { pos = 4;}
	
	if(profil_typ=="IPE")
		{
	    for(int i=0;i<=(IPEn.length-1);++i)
			{
	    	if(profil_nr==IPEn[i])
				{
	    		p=IPEw[i][pos];
	    		break;
				}
	    	else{}
			}
		}
	else if (profil_typ=="HEA")
		{
		for(int i=0;i<=(HEAn.length-1);++i)
			{
			if(profil_nr==HEAn[i])
				{
				p=HEAw[i][pos];
				break;
				}
			else{}
			}
		}
	else if(profil_typ=="HEB")
		{
		for(int i=0;i<=(HEBn.length-1);++i)
			{
			if(profil_nr==HEBn[i])
				{
				p=HEBw[i][pos];
				break;
				}
			else{}
			}
		}
	else if(profil_typ=="HEM")
		{
		for(int i=0;i<=(HEMn.length-1);++i)
			{
			if(profil_nr==HEMn[i])
				{
				p=HEMw[i][pos];
				break;
				}
			else{}
			}
		}
	return p;
 }

	real getStringLength(string s){
		frame fr1;
		Label La1=Label(s,(0,0));
		path weg1=box(fr1,La1);
		pair lu=min(fr1);
		pair ru=max(fr1);
		real c=(xpart(ru)-xpart(lu));
		return c;
	}
	
	real getPictureSizeUser(picture pic){
		pair lu = min(pic,true);
		pair ru = max(pic,true);
		real c=ru.x-lu.x;
		return c;
	}
	
	real getPictureSizePS(picture pic){
		pair lu = min(pic,false);
		pair ru = max(pic,false);
		real c=ru.x-lu.x;
		return c;
	}
	
	real calculateLineLength(pair p, picture pic=currentpicture){
		real temp1=sqrt(abs(p.x)^2+abs(p.y)^2);
		real temp2=getPictureSizeUser(pic);
		real temp3=temp1/temp2;
		real temp4=getPictureSizePS(pic);
		real c=temp3*temp4;
		return c;
	}
	
	real getLineAngleDeg(pair p){
		real l=sqrt(abs(p.x)^2+abs(p.y)^2);
		real angle;
		if(p.x>=0&&p.y>=0){
			if(p.x==0){
				angle = 90;
			}else{
				angle = atan(abs(p.y)/abs(p.x))/(3.141592)*180;
			}
		}else if(p.x<0&&p.y>=0){
			if(p.y==0){
				angle = 180;
			}else{
				angle = 180-atan(abs(p.y)/abs(p.x))/(3.141592)*180;
			}
		}else if(p.x<=0&&p.y<0){
			if(p.x==0){
				angle = 270;
			}else{
				angle = 180+atan(abs(p.y)/abs(p.x))/(3.141592)*180;
			}
		}else{
			if(p.y==0){
				angle = 360;
			}else{
				angle = 360-atan(abs(p.y)/abs(p.x))/(3.141592)*180;
			}
		}
		return angle;
	}
	
	real getLineAngleRad(pair p){
		real angle = getLineAngleDeg(p)/180*3.141592;
		return angle;
	}

// --------------------------------------------------------------------------------------------------------------------------------
// Bemassung-----------------------------------------------------------------------------------------------------------------------
// neu ab 07072017
// --------------------------------------------------------------------------------------------------------------------------------

void vbemassung(real[] laengen, pair a, real x=20, pen pen=defaultpen, arrowbar bar=Bars(size=8), arrowbar bar2=Arrows(size=6)) {
     pair a=a+(x,0);
     for(real l : laengen) {
         pair b=a+(0,l);
         string s=string(abs(l));
         s=replace(s,".",",");
         draw(a--b,pen,bar,bar2);
         pair c=a+(0,l/2);
         Label s=rotate(90)*Label(s);
         label(s,c,W);
         a=b;
         }
     }

void hbemassung(real[] laengen, pair a, real x=20,
                        pen pen=defaultpen, arrowbar bar=Bars(size=8), arrowbar bar2=Arrows(size=6)) {
     pair a=a+(0,x);
     for(real l : laengen) {
         pair b=a+(l,0);
         string s=string(abs(l));
         s=replace(s,".",",");
         draw(a--b,pen,bar,bar2);
         pair c=a+(l/2,0);
         label(s,c,N);
         a=b;
         }
     }

///////////////////////////////////////////////////
/// pair a : Anfangspunkt						///
/// pair b : Endpunkt							///
/// real x : Abstand zum Punkt					///
/// bool laenge: show true length				///
/// real AnzahlStellen: ...						///
/// string s: if true lenght no show			///
/// bool ausrichten: manuell ausrichten on/off	///
/// string ausr: "L"-links, "R"-rechts, "O"-oben///
/// pair f: reference point						///
///////////////////////////////////////////////////
// Func Bemassung
void bemassung(pair a, pair b, real x=20, bool laenge = true, real AnzahlStellen = 2, string s="l", bool ausrichten = false, string ausr="L", bool append=false, pair f = (2,20), pen pen=defaultpen, arrowbar bar=Bars(size=8), arrowbar bar2=Arrows(size=6)){
	
	pair ab=b-a;
	
		void drawFLine(pair p0, pair f=f, int diry=1, real yoffset=0, int dirx=1, real xoffset=0){
		picture beschr;
		pair f1 = (0,0);
		pair f2 = (dirx*f.x,diry*f.y+yoffset);
		pair f3 = (dirx*(f.x+getStringLength(s)),diry*f.y+yoffset);
		pair f4 = (f2.x*cos(getLineAngleRad(ab))-f2.y*sin(getLineAngleRad(ab)),f2.x*sin(getLineAngleRad(ab))+f2.y*cos(getLineAngleRad(ab)));
		pair f5 = (f3.x*cos(getLineAngleRad(ab))-f3.y*sin(getLineAngleRad(ab)),f3.x*sin(getLineAngleRad(ab))+f3.y*cos(getLineAngleRad(ab)));
		draw(beschr,rotate(getLineAngleDeg(ab),f1)*(f1--f2--f3));
		
		if(dirx==1){
			label(beschr,rotate(getLineAngleDeg(ab),f1)*Label(s,Relative(0),Relative(N+W)),f4--f5);
		}else{
			label(beschr,rotate(getLineAngleDeg(ab),f1)*Label(s,Relative(0),Relative(N+W)),f5--f4);
		}
		add(currentpicture,beschr,p0);
		}
	
	void alignLabel(pair a, pair b){
		if(ausr=="R"){
			drawFLine(b,(f.x,0),1,0,1,0);
		}else if(ausr=="O"){
			drawFLine((a+b)/2,f,1,0);
		}else if(ausr=="L"){
			drawFLine(a,(f.x,0),1,0,-1,0);
		}else{
			drawFLine((a+b)/2,f,-1,-15);
		}
	}
	
	pair a=a+(-x*sin(getLineAngleRad(ab)),x*cos(getLineAngleRad(ab)));
	pair b=b+(-x*sin(getLineAngleRad(ab)),x*cos(getLineAngleRad(ab)));
	pair ab=b-a;
	
	draw(a--b, bar, bar2);

	
	if(laenge==true){
		real l=sqrt(abs(ab.x)^2+abs(ab.y)^2);
		if(append==false){
			s="$"+string(round(l*10^AnzahlStellen)/10^AnzahlStellen)+"$";
		}else{
			s="$"+s+string(round(l*10^AnzahlStellen)/10^AnzahlStellen)+"$";
		}
	}
	if(getStringLength(s)<=0.8*calculateLineLength(ab)){
		if(ausrichten==true){
			alignLabel(a,b);
		}else{
			label(rotate(getLineAngleDeg(ab),(0,0))*Label(s,Relative(0.5),Relative(1.5*W)),a--b);
		}
	}else{
		alignLabel(a,b);
	}
}
		
void rbemassung(pair p1, pair p2, real winkel, real mu=0.5, bool laenge=true, int AnzahlStellen=2, string s="R", bool append=false, pen pen1=defaultpen, pair f=(15,15), real arrowsize=8){
	pair ab=p2-p1;
	real ss=sqrt((ab.x)^2+(ab.y)^2);
	real rr=ss/(2*sin(winkel/2/180*3.141592));
	real hh=ss/2*tan(winkel/4/180*3.141592);
	pair pc=(p1+p2)/2+(rr-hh)*(cos((getLineAngleDeg(ab)+270)/180*3.141592),sin((getLineAngleDeg(ab)+270)/180*3.141592));
	real winkeld=getLineAngleDeg(ab)+90+winkel/2-mu*winkel;
	pair pd=pc+rr*(cos((winkeld)/180*3.141592),sin((winkeld)/180*3.141592));
	if(laenge==true){
		if(append==false){
			s="$R="+string(round(rr*10^AnzahlStellen)/10^AnzahlStellen)+"$";
		}else{
			s="$"+s+string(round(rr*10^AnzahlStellen)/10^AnzahlStellen)+"$";
	}
}
	
void drawFLine(pair p0, pair f=f, int diry=1, real yoffset=0, int dirx=1, real xoffset=0){
	picture beschr;
	pair f1 = (0,0);
	pair f2 = (dirx*f.x,diry*f.y+yoffset);
	pair f3 = (dirx*(f.x+getStringLength(s)),diry*f.y+yoffset);
	draw(beschr,(f1--f2--f3),pen1,BeginArrow(size=arrowsize));
	if(dirx==1){
		label(beschr,Label(s,Relative(0),Relative(N+W)),f2--f3);
	}else{
		label(beschr,Label(s,Relative(0),Relative(N+W)),f3--f2);
	}
	add(currentpicture,beschr,p0);
}
	
void alignLabel(pair pd, real winkeld){
	if(winkeld>=0&&winkeld<90){
		drawFLine(pd,f,-1,0,-1,0);
	}else if(winkeld>=90&&winkeld<180){
		drawFLine(pd,f,-1,0,1,0);
	}else if(winkeld>=180&&winkeld<270){
		drawFLine(pd,f,1,0,1,0);
	}else{
		drawFLine(pd,f,1,0,-1,0);
	}
}
alignLabel(pd,winkeld);
}

void nahtbeschr(pair p0, string sa, string naht, bool umlauf=false, bool ausru=true, bool turn=false){
	picture beschr;
	
	// hier gab es ein Parameter string sl für Schweißnahtlänge, hinter string naht
	
	int f=15;
	int ddd=1;
	int dd;
	
	if(ausru==true){
		dd=-ddd;
	}else{
		dd=0;
	}

	frame fr1;
	frame fr2;
	
	pair a=(0,0);
	pair b=a+(f,f);
	
	Label La1=Label(sa,b);
	
	path weg1=box(fr1,La1);
	
	pair lu=min(fr1);
	pair ru=max(fr1);
	
	pair links1=(xpart(lu),0);
	pair rechts1=(xpart(ru)*1.1,0);
	
	pair c=b+(rechts1-links1);
	
	if(umlauf==true){
		draw(beschr,shift(b)*scale(2)*unitcircle);
	}else{}
	
	transform t;
	if(turn==true){
		t=shift(0,-2*f)*reflect(b,c);
	}else{
		t=scale(1,1);
	}
	
	pair p1,p2,p3,p4,p5,p6,p7;
	
	if(naht=="Doppelkehl"){
		p1=c+(0,ypart(ru)/4);
		p2=c+(0,-ypart(ru)/4);
		p3=c+(ypart(ru)/4,0);
		draw(beschr,t*(p1--p2--p3--cycle));
	}else{
	if(naht=="Kehl"){
		p1=c+(0,ypart(ru)/2);
		p2=c+(0,0);
		p3=c+(ypart(ru)/2,0);
		draw(beschr,t*(p1--p2--p3--cycle));
	}else{
	if(naht=="V"){
		p1=c+(ypart(ru)/4,0);
		p2=c+(0,ypart(ru)/2);
		p4=c+(ypart(ru)/2,ypart(ru)/2);
		p3=c+(ypart(ru)/2,0);
		draw(beschr,t*(p2--p1--p4));
	}else{
	if(naht=="DV"){
		p1=c+(0,-ypart(ru)/2);
		p2=c+(0,ypart(ru)/2);
		p4=c+(ypart(ru)/2,ypart(ru)/2);
		p5=c+(ypart(ru)/2,-ypart(ru)/2);
		p3=c+(ypart(ru)/2,0);
		draw(beschr,p2--p5);
		draw(beschr,p1--p4);
	}else{
	if(naht=="HV"){
		p1=c+(0,0);
		p2=c+(0,ypart(ru)/2);
		p4=c+(ypart(ru)/2,ypart(ru)/2);
		p3=c+(ypart(ru)/2,0);
		draw(beschr,t*(p2--p1--p4));
	}else{
	if(naht=="DHV"){
		p1=c+(0,0);
		p2=c+(0,ypart(ru)/2);
		p4=c+(0,-ypart(ru)/2);
		p5=c+(ypart(ru)/2,ypart(ru)/2);
		p6=c+(ypart(ru)/2,-ypart(ru)/2);
		p3=c+(ypart(ru)/2,0);
		draw(beschr,p2--p4);
		draw(beschr,p5--p1--p6);
	}else{
	if(naht=="Y"){
		p1=c+(ypart(ru)/4,0);
		p2=c+(0,ypart(ru)/2);
		p4=c+(ypart(ru)/2,ypart(ru)/2);
		p5=c+(ypart(ru)/4,-ypart(ru)/2);
		p3=c+(ypart(ru)/2,0);
		draw(beschr,t*(p2--p1--p5--p1--p4));
	}else{
	if(naht=="DY"){
		p1=c+(0,-ypart(ru)/2);
		p2=c+(0,ypart(ru)/2);
		p4=c+(ypart(ru)/2,ypart(ru)/2);
		p5=c+(ypart(ru)/2,-ypart(ru)/2);
		p6=c+(ypart(ru)/4,ypart(ru)/8);
		p7=c+(ypart(ru)/4,-ypart(ru)/8);
		p3=c+(ypart(ru)/2,0);
		draw(beschr,p2--p6--p7--p5);
		draw(beschr,p1--p7--p6--p4);
	}else{
	if(naht=="HY"){
		p1=c+(0,0);
		p2=c+(0,ypart(ru)/2);
		p4=c+(ypart(ru)/2,ypart(ru)/2);
		p5=c+(0,-ypart(ru)/2);
		p3=c+(ypart(ru)/2,0);
		draw(beschr,t*(p2--p1--p5--p1--p4));
	}else{
	if(naht=="DHY"){
		p1=c+(0,-ypart(ru)/2);
		p2=c+(0,ypart(ru)/2);
		p4=c+(ypart(ru)/2,ypart(ru)/2);
		p5=c+(ypart(ru)/2,-ypart(ru)/2);
		p6=c+(0,ypart(ru)/8);
		p7=c+(0,-ypart(ru)/8);
		p3=c+(ypart(ru)/2,0);
		draw(beschr,p2--p6--p7--p5);
		draw(beschr,p1--p7--p6--p4);
	}else{p3=c+(ypart(ru)/2,0);}}}}}}}}}}

	// Label La2=Label(sl,p3);
	
	// path weg2=box(fr2,La2);
	
	pair lu=min(fr2);
	pair ru=max(fr2);
		
	pair links2=(xpart(lu),0);
	pair rechts2=(xpart(ru),0);
	
	pair d=p3+(rechts2-links2);
	
	path linie=a--b--d;
	path dlinie=b--d;
	
	draw (beschr,t*linie,BeginArrow(size=4));
	draw (beschr,t*shift(0,dd)*dlinie,dashed);
	
	label(beschr,La1,t*b,NE);
	// label(beschr,La2,p3,NE);
	
	add(currentpicture,beschr,p0);
}

// Funktion Koordinatenachsen 07072017
// pair p: Ursprungpunkt der Koordinatenachsen, 
// real mass: Vergrößerungsfaktor
// real alpha: Verdrehungswinkel
// real a1: Abstand von Label und O-Punkt
// align align1: Position der Label
// real arrowsize: ...
void CSYS(pair p, real mass=1, real alpha=0, string s1="x", string s2="y", real a1=0.5, real a2=0.5, pen pen1=defaultpen, align align1=S, align align2=W, real arrowsize=6){
	path xax = p--(p+cos(alpha/180*3.141592)*mass*E+sin(alpha/180*3.141592)*mass*N);
	path yax = p--(p+sin(alpha/180*3.141592)*mass*E+cos(alpha/180*3.141592)*mass*S);
	
	draw(xax,pen1,EndArrow(size=arrowsize));
	Label La1 = Label(s1,Relative(a1));
	label(La1,p+cos(alpha/180*3.141592)*mass*E+sin(alpha/180*3.141592)*mass*N,align1);
	draw(yax,pen1,EndArrow(size=arrowsize));
	Label La2 = Label(s2,Relative(a2));
	label(La2,p+sin(alpha/180*3.141592)*mass*E+cos(alpha/180*3.141592)*mass*S,align2);
}

void flinie(pair p0, string sa, pair f=(15,15)){
	picture beschr;
	frame fr1;
	
	pair a=(0,0);
	pair b=a+f;
	
	Label La1=Label(sa,b);
	
	path weg1=box(fr1,La1);
	
	pair lu=min(fr1);
	pair ru=max(fr1);
	
	pair links1=(xpart(lu),0);
	pair rechts1=(xpart(ru)*1.1,0);
	
	pair c=b+(rechts1-links1);
	
	path linie=a--b--c;
	
	draw(beschr,linie,BeginArrow(size=5));

	label(beschr,La1,b,NE);

	add(currentpicture,beschr,p0);
}

//

/* // Simplified CSYS
void simpcsys (pair p0 = (0,0), pair px = (1,0), pair py = (0,1) , string x = "x", string y = "y"){
	draw (p0--px, EndArrow); 
	label (x, px, S);
	draw (p0--py, EndArrow); 
	label (y, py, W);
}  */

// Grundformen--------------------------------------------------------------------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------------------------
   
 void rechteck(pair a, real b, real h, string s="white", string ausr="M", pen pen1=defaultpen){
      
      if(ausr=="NE"){
	a=a+(b/2,h/2);
      }else{
      if(ausr=="E"){
      	a=a+(b/2,0);
      }else{
      if(ausr=="SE"){
      	a=a+(b/2,-h/2);
      }else{
      if(ausr=="S"){
      	a=a+(0,-h/2);
      }else{
      if(ausr=="SW"){
      	a=a+(-b/2,-h/2);
      }else{
      if(ausr=="W"){
      	a=a+(-b/2,0);
      }else{
      if(ausr=="NW"){
      	a=a+(-b/2,h/2);
      }else{
      if(ausr=="N"){
      	a=a+(0,h/2);
      }else{}}}}}}}}

      pair p1=a+(-b/2,h/2);
      pair p2=a+(b/2,h/2);
      pair p3=a+(b/2,-h/2);
      pair p4=a+(-b/2,-h/2);
      filldraw(p1--p2--p3--p4--p1--cycle,white,pen1);
      filldraw(p1--p2--p3--p4--p1--cycle,pattern(s),pen1);
      }

 void kreis(pair a, real r, string s="white", string ausr="M", pen pen1=defaultpen, transform t=scale(1,1)){
      
      if(ausr=="E"){
      	a=a+(r,0);
      }else{
      if(ausr=="S"){
      	a=a+(0,-r);
      }else{
      if(ausr=="W"){
      	a=a+(-r,0);
      }else{
      if(ausr=="N"){
      	a=a+(0,r);
      }else{}}}}

      pair p1=a+(0,r);
      pair p2=a+(r,0);
      pair p3=a+(0,-r);
      pair p4=a+(-r,0);
      filldraw(t*(p1..p2..p3..p4..p1..cycle),white,pen1);
      filldraw(t*(p1..p2..p3..p4..p1..cycle),pattern(s),pen1);
      }

 void rohr(pair a, real d, real t, string s1="stahl", string ausr="M", pen pen1=defaultpen, string s2="white"){
      real r=d/2;
      
      if(ausr=="E"){
      	a=a+(r,0);
      }else{
      if(ausr=="S"){
      	a=a+(0,-r);
      }else{
      if(ausr=="W"){
      	a=a+(-r,0);
      }else{
      if(ausr=="N"){
      	a=a+(0,r);
      }else{}}}}

      pair p1=a+(0,r);
      pair p2=a+(r,0);
      pair p3=a+(0,-r);
      pair p4=a+(-r,0);
      filldraw(p1..p2..p3..p4..p1..cycle,white,pen1);
      filldraw(p1..p2..p3..p4..p1..cycle,pattern(s1),pen1);
      pair p1=a+(0,(r-t));
      pair p2=a+((r-t),0);
      pair p3=a+(0,-(r-t));
      pair p4=a+(-(r-t),0);
      filldraw(p1..p2..p3..p4..p1..cycle,white,pen1);
      filldraw(p1..p2..p3..p4..p1..cycle,pattern(s2),pen1);
      }

void trapez(pair a, real b1, real b2, real h, real w, string s="white", pen pen1=defaultpen){

      pair p1= a+(-b1/2,h/2);
      pair p2=a+(b1/2,h/2);
      pair p3=a+(b2/2,-h/2);
      pair p4=a+(-b2/2,-h/2);
	  filldraw(rotate(w,a)*(p1--p2--p3--p4--p1--cycle),white,pen1);
      filldraw(rotate(w,a)*(p1--p2--p3--p4--p1--cycle),pattern(s),pen1);
      }
	  
	  
// --------------------------------------------------------------------------------------------------------------------------------
// Profile-------------------------------------------------------------------------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------------------------


// Doppel-T-Profile----------------------------------------------------------------------------------------------------------------
void walz_profil (pair a = (0,0), string p = "IPE300", real angle =0, string ausr = "M", string m="stahl", pen pen1=defaultpen){
		real h = profil_parameter (p, "h");
		real b = profil_parameter (p, "b");
		real tf = profil_parameter (p, "tf");
		real tw = profil_parameter (p, "tw");
		real r = profil_parameter (p, "r");
		
		if(ausr=="NE"){
			a=a+(b/2,h/2);
		}
			else{if(ausr=="E"){
				a=a+(b/2,0);
			}
			else{if(ausr=="SE"){
				a=a+(b/2,-h/2);
			}
			else{if(ausr=="S"){
				a=a+(0,-h/2);
			}
			else{if(ausr=="SW"){
				a=a+(-b/2,-h/2);
			}
			else{if(ausr=="W"){
				a=a+(-b/2,0);
			}
			else{if(ausr=="NW"){
				a=a+(-b/2,h/2);
			}
			else{if(ausr=="N"){
				a=a+(0,h/2);
		}else{}}}}}}}};
		
	    pair p1=a+(-b/2,h/2);
		pair p2=a+(b/2,h/2);
		pair p3=a+(b/2,h/2-tf);
		pair p4=a+(tw/2+r,h/2-tf);
		pair p5=a+(tw/2,h/2-tf-r);
		pair p6=a+(tw/2,-h/2+tf+r);
		pair p7=a+(tw/2+r,-h/2+tf);
		pair p8=a+(b/2,-h/2+tf);
		pair p9=a+(b/2,-h/2);
		pair p10=a+(-b/2,-h/2);
		pair p11=a+(-b/2,-h/2+tf);
		pair p12=a+(-tw/2-r,-h/2+tf);
		pair p13=a+(-tw/2,-h/2+tf+r);
		pair p14=a+(-tw/2,h/2-tf-r);
		pair p15=a+(-tw/2-r,h/2-tf);
		pair p16=a+(-b/2,h/2-tf);
        
		path ipath=p1--p2--p3--p4{left}..{down}p5--p6{down}..{right}p7--p8--p9--p10
                 --p11--p12{right}..{up}p13--p14{up}..{left}p15--p16--cycle;

      filldraw(rotate(angle,a)*ipath,white,pen1);
      filldraw(rotate(angle,a)*ipath,pattern(m),pen1);	
}


 void IPE(pair a, string t, pen pen1=defaultpen, real angle=0, string ausr="M", string m="stahl"){
      include profile;

      //string t=string(hh);

    //Höhe
      real h=0;
      for(int i=0;i<=(IPEn.length-1);++i){
          if(t==IPEn[i]){
              h=IPEw[i][0];
              break;}
          else{}}
    //Breite
      real b=0;
      for(int i=0;i<=(IPEn.length-1);++i){
          if(t==IPEn[i]){
              b=IPEw[i][1];
              break;}
          else{}}
    //Stegdicke
      real tw=0;
      for(int i=0;i<=(IPEn.length-1);++i){
          if(t==IPEn[i]){
              tw=IPEw[i][2];
              break;}
          else{}}
    //Flanschdicke
      real tf=0;
      for(int i=0;i<=(IPEn.length-1);++i){
          if(t==IPEn[i]){
              tf=IPEw[i][3];
              break;}
          else{}}
    //Radius
      real r=0;
      for(int i=0;i<=(IPEn.length-1);++i){
          if(t==IPEn[i]){
              r=IPEw[i][4];
              break;}
          else{}}

      if(ausr=="NE"){
	a=a+(b/2,h/2);
      }else{
      if(ausr=="E"){
      	a=a+(b/2,0);
      }else{
      if(ausr=="SE"){
      	a=a+(b/2,-h/2);
      }else{
      if(ausr=="S"){
      	a=a+(0,-h/2);
      }else{
      if(ausr=="SW"){
      	a=a+(-b/2,-h/2);
      }else{
      if(ausr=="W"){
      	a=a+(-b/2,0);
      }else{
      if(ausr=="NW"){
      	a=a+(-b/2,h/2);
      }else{
      if(ausr=="N"){
      	a=a+(0,h/2);
      }else{}}}}}}}}

      pair p1=a+(-b/2,h/2);
      pair p2=a+(b/2,h/2);
      pair p3=a+(b/2,h/2-tf);
      pair p4=a+(tw/2+r,h/2-tf);
      pair p5=a+(tw/2,h/2-tf-r);
      pair p6=a+(tw/2,-h/2+tf+r);
      pair p7=a+(tw/2+r,-h/2+tf);
      pair p8=a+(b/2,-h/2+tf);
      pair p9=a+(b/2,-h/2);
      pair p10=a+(-b/2,-h/2);
      pair p11=a+(-b/2,-h/2+tf);
      pair p12=a+(-tw/2-r,-h/2+tf);
      pair p13=a+(-tw/2,-h/2+tf+r);
      pair p14=a+(-tw/2,h/2-tf-r);
      pair p15=a+(-tw/2-r,h/2-tf);
      pair p16=a+(-b/2,h/2-tf);
        
      path ipath=p1--p2--p3--p4{left}..{down}p5--p6{down}..{right}p7--p8--p9--p10
                 --p11--p12{right}..{up}p13--p14{up}..{left}p15--p16--cycle;

      filldraw(rotate(angle,a)*ipath,white,pen1);
      filldraw(rotate(angle,a)*ipath,pattern(m),pen1);
      }

 void HEA(pair a, string t, pen pen1=defaultpen,  real angle=0, string ausr="M", string m="stahl"){
      include profile;

    //Höhe
      real h=0;
      for(int i=0;i<=(HEAn.length-1);++i){
          if(t==HEAn[i]){
              h=HEAw[i][0];
              break;}
          else{}}
    //Breite
      real b=0;
      for(int i=0;i<=(HEAn.length-1);++i){
          if(t==HEAn[i]){
              b=HEAw[i][1];
              break;}
          else{}}
    //Stegdicke
      real tw=0;
      for(int i=0;i<=(HEAn.length-1);++i){
          if(t==HEAn[i]){
              tw=HEAw[i][2];
              break;}
          else{}}
    //Flanschdicke
      real tf=0;
      for(int i=0;i<=(HEAn.length-1);++i){
          if(t==HEAn[i]){
              tf=HEAw[i][3];
              break;}
          else{}}
    //Radius
      real r=0;
      for(int i=0;i<=(HEAn.length-1);++i){
          if(t==HEAn[i]){
              r=HEAw[i][4];
              break;}
          else{}}

      if(ausr=="NE"){
	a=a+(b/2,h/2);
      }else{
      if(ausr=="E"){
      	a=a+(b/2,0);
      }else{
      if(ausr=="SE"){
      	a=a+(b/2,-h/2);
      }else{
      if(ausr=="S"){
      	a=a+(0,-h/2);
      }else{
      if(ausr=="SW"){
      	a=a+(-b/2,-h/2);
      }else{
      if(ausr=="W"){
      	a=a+(-b/2,0);
      }else{
      if(ausr=="NW"){
      	a=a+(-b/2,h/2);
      }else{
      if(ausr=="N"){
      	a=a+(0,h/2);
      }else{}}}}}}}}

      pair p1=a+(-b/2,h/2);
      pair p2=a+(b/2,h/2);
      pair p3=a+(b/2,h/2-tf);
      pair p4=a+(tw/2+r,h/2-tf);
      pair p5=a+(tw/2,h/2-tf-r);
      pair p6=a+(tw/2,-h/2+tf+r);
      pair p7=a+(tw/2+r,-h/2+tf);
      pair p8=a+(b/2,-h/2+tf);
      pair p9=a+(b/2,-h/2);
      pair p10=a+(-b/2,-h/2);
      pair p11=a+(-b/2,-h/2+tf);
      pair p12=a+(-tw/2-r,-h/2+tf);
      pair p13=a+(-tw/2,-h/2+tf+r);
      pair p14=a+(-tw/2,h/2-tf-r);
      pair p15=a+(-tw/2-r,h/2-tf);
      pair p16=a+(-b/2,h/2-tf);
        
      path ipath=p1--p2--p3--p4{left}..{down}p5--p6{down}..{right}p7--p8--p9--p10
                 --p11--p12{right}..{up}p13--p14{up}..{left}p15--p16--cycle;

      filldraw(rotate(angle,a)*ipath,white,pen1);
      filldraw(rotate(angle,a)*ipath,pattern(m),pen1);
      }

 void HEB(pair a, string t, pen pen1=defaultpen,  real angle=0, string ausr="M", string m="stahl"){
      include profile;

    //Höhe
      real h=0;
      for(int i=0;i<=(HEBn.length-1);++i){
          if(t==HEBn[i]){
              h=HEBw[i][0];
              break;}
          else{}}
    //Breite
      real b=0;
      for(int i=0;i<=(HEBn.length-1);++i){
          if(t==HEBn[i]){
              b=HEBw[i][1];
              break;}
          else{}}
    //Stegdicke
      real tw=0;
      for(int i=0;i<=(HEBn.length-1);++i){
          if(t==HEBn[i]){
              tw=HEBw[i][2];
              break;}
          else{}}
    //Flanschdicke
      real tf=0;
      for(int i=0;i<=(HEBn.length-1);++i){
          if(t==HEBn[i]){
              tf=HEBw[i][3];
              break;}
          else{}}
    //Radius
      real r=0;
      for(int i=0;i<=(HEBn.length-1);++i){
          if(t==HEBn[i]){
              r=HEBw[i][4];
              break;}
          else{}}

      if(ausr=="NE"){
	a=a+(b/2,h/2);
      }else{
      if(ausr=="E"){
      	a=a+(b/2,0);
      }else{
      if(ausr=="SE"){
      	a=a+(b/2,-h/2);
      }else{
      if(ausr=="S"){
      	a=a+(0,-h/2);
      }else{
      if(ausr=="SW"){
      	a=a+(-b/2,-h/2);
      }else{
      if(ausr=="W"){
      	a=a+(-b/2,0);
      }else{
      if(ausr=="NW"){
      	a=a+(-b/2,h/2);
      }else{
      if(ausr=="N"){
      	a=a+(0,h/2);
      }else{}}}}}}}}

      pair p1=a+(-b/2,h/2);
      pair p2=a+(b/2,h/2);
      pair p3=a+(b/2,h/2-tf);
      pair p4=a+(tw/2+r,h/2-tf);
      pair p5=a+(tw/2,h/2-tf-r);
      pair p6=a+(tw/2,-h/2+tf+r);
      pair p7=a+(tw/2+r,-h/2+tf);
      pair p8=a+(b/2,-h/2+tf);
      pair p9=a+(b/2,-h/2);
      pair p10=a+(-b/2,-h/2);
      pair p11=a+(-b/2,-h/2+tf);
      pair p12=a+(-tw/2-r,-h/2+tf);
      pair p13=a+(-tw/2,-h/2+tf+r);
      pair p14=a+(-tw/2,h/2-tf-r);
      pair p15=a+(-tw/2-r,h/2-tf);
      pair p16=a+(-b/2,h/2-tf);
        
      path ipath=p1--p2--p3--p4{left}..{down}p5--p6{down}..{right}p7--p8--p9--p10
                 --p11--p12{right}..{up}p13--p14{up}..{left}p15--p16--cycle;

      filldraw(rotate(angle,a)*ipath,white,pen1);
      filldraw(rotate(angle,a)*ipath,pattern(m),pen1);
      }

 void HEM(pair a, string t, pen pen1=defaultpen,  real angle=0, string ausr="M", string m="stahl"){
      include profile;

    //Höhe
      real h=0;
      for(int i=0;i<=(HEMn.length-1);++i){
          if(t==HEMn[i]){
              h=HEMw[i][0];
              break;}
          else{}}
    //Breite
      real b=0;
      for(int i=0;i<=(HEMn.length-1);++i){
          if(t==HEMn[i]){
              b=HEMw[i][1];
              break;}
          else{}}
    //Stegdicke
      real tw=0;
      for(int i=0;i<=(HEMn.length-1);++i){
          if(t==HEMn[i]){
              tw=HEMw[i][2];
              break;}
          else{}}
    //Flanschdicke
      real tf=0;
      for(int i=0;i<=(HEMn.length-1);++i){
          if(t==HEMn[i]){
              tf=HEMw[i][3];
              break;}
          else{}}
    //Radius
      real r=0;
      for(int i=0;i<=(HEMn.length-1);++i){
          if(t==HEMn[i]){
              r=HEMw[i][4];
              break;}
          else{}}

      if(ausr=="NE"){
	a=a+(b/2,h/2);
      }else{
      if(ausr=="E"){
      	a=a+(b/2,0);
      }else{
      if(ausr=="SE"){
      	a=a+(b/2,-h/2);
      }else{
      if(ausr=="S"){
      	a=a+(0,-h/2);
      }else{
      if(ausr=="SW"){
      	a=a+(-b/2,-h/2);
      }else{
      if(ausr=="W"){
      	a=a+(-b/2,0);
      }else{
      if(ausr=="NW"){
      	a=a+(-b/2,h/2);
      }else{
      if(ausr=="N"){
      	a=a+(0,h/2);
      }else{}}}}}}}}

      pair p1=a+(-b/2,h/2);
      pair p2=a+(b/2,h/2);
      pair p3=a+(b/2,h/2-tf);
      pair p4=a+(tw/2+r,h/2-tf);
      pair p5=a+(tw/2,h/2-tf-r);
      pair p6=a+(tw/2,-h/2+tf+r);
      pair p7=a+(tw/2+r,-h/2+tf);
      pair p8=a+(b/2,-h/2+tf);
      pair p9=a+(b/2,-h/2);
      pair p10=a+(-b/2,-h/2);
      pair p11=a+(-b/2,-h/2+tf);
      pair p12=a+(-tw/2-r,-h/2+tf);
      pair p13=a+(-tw/2,-h/2+tf+r);
      pair p14=a+(-tw/2,h/2-tf-r);
      pair p15=a+(-tw/2-r,h/2-tf);
      pair p16=a+(-b/2,h/2-tf);
        
      path ipath=p1--p2--p3--p4{left}..{down}p5--p6{down}..{right}p7--p8--p9--p10
                 --p11--p12{right}..{up}p13--p14{up}..{left}p15--p16--cycle;

      filldraw(rotate(angle,a)*ipath,white,pen1);
      filldraw(rotate(angle,a)*ipath,pattern(m),pen1);
      }

// geschweißter Profil
 void Iprofil(pair a, real b, real h, real tw, real tf,
              real r, pen pen1=defaultpen, real angle=0, string ausr="M", real b2=b, real tf2=tf, string s="stahl"){

      if(ausr=="NE"){
	a=a+(b/2,h/2);
      }else{
      if(ausr=="E"){
      	a=a+(b/2,0);
      }else{
      if(ausr=="SE"){
      	a=a+(b/2,-h/2);
      }else{
      if(ausr=="S"){
      	a=a+(0,-h/2);
      }else{
      if(ausr=="SW"){
      	a=a+(-b/2,-h/2);
      }else{
      if(ausr=="W"){
      	a=a+(-b/2,0);
      }else{
      if(ausr=="NW"){
      	a=a+(-b/2,h/2);
      }else{
      if(ausr=="N"){
      	a=a+(0,h/2);
      }else{}}}}}}}}

      pair p1=a+(-b/2,h/2);
      pair p2=a+(b/2,h/2);
      pair p3=a+(b/2,h/2-tf);
      pair p8=a+(b2/2,-h/2+tf2);
      pair p9=a+(b2/2,-h/2);
      pair p10=a+(-b2/2,-h/2);
      pair p11=a+(-b2/2,-h/2+tf2);
      pair p16=a+(-b/2,h/2-tf);

      real r2=r*sqrt(2);
      pair p4=a+(tw/2+r2,h/2-tf);
      pair p5=a+(tw/2,h/2-tf-r2);
      pair p6=a+(tw/2,-h/2+tf2+r2);
      pair p7=a+(tw/2+r2,-h/2+tf2);
      pair p12=a+(-tw/2-r2,-h/2+tf2);
      pair p13=a+(-tw/2,-h/2+tf2+r2);
      pair p14=a+(-tw/2,h/2-tf-r2);
      pair p15=a+(-tw/2-r2,h/2-tf);

      pair p17=a+(-tw/2,h/2-tf);
      pair p18=a+(-tw/2,-h/2+tf2);
      pair p19=a+(tw/2,-h/2+tf2);
      pair p20=a+(tw/2,h/2-tf);

    //Flansch oben
      path pfo=p1--p2--p3--p16--cycle;
      filldraw(rotate(angle,a)*pfo,white,pen1);
      filldraw(rotate(angle,a)*pfo,pattern(s),pen1);
    //Flansch unten
      path pfu=p8--p9--p10--p11--cycle;
      filldraw(rotate(angle,a)*pfu,white,pen1);
      filldraw(rotate(angle,a)*pfu,pattern(s),pen1);
    //Steg
      path pw=p17--p18--p19--p20--cycle;
      filldraw(rotate(angle,a)*pw,white,pen1);
      filldraw(rotate(angle,a)*pw,pattern(s),pen1);
    //Schweißnähte
      filldraw(rotate(angle,a)*(p14--p15--p17--cycle),black,pen1);
      filldraw(rotate(angle,a)*(p4--p5--p20--cycle),black,pen1);
      filldraw(rotate(angle,a)*(p6--p7--p19--cycle),black,pen1);
      filldraw(rotate(angle,a)*(p12--p13--p18--cycle),black,pen1);
      }

// geschweißter Profil
 void weld_profil(pair a, real b, real h, real tw, real tf,
              real r, pen pen1=defaultpen, real angle=0, string ausr="M", real b2=b, real tf2=tf, string s="stahl"){

      if(ausr=="NE"){
	a=a+(b/2,h/2);
      }else{
      if(ausr=="E"){
      	a=a+(b/2,0);
      }else{
      if(ausr=="SE"){
      	a=a+(b/2,-h/2);
      }else{
      if(ausr=="S"){
      	a=a+(0,-h/2);
      }else{
      if(ausr=="SW"){
      	a=a+(-b/2,-h/2);
      }else{
      if(ausr=="W"){
      	a=a+(-b/2,0);
      }else{
      if(ausr=="NW"){
      	a=a+(-b/2,h/2);
      }else{
      if(ausr=="N"){
      	a=a+(0,h/2);
      }else{}}}}}}}}

      pair p1=a+(-b/2,h/2);
      pair p2=a+(b/2,h/2);
      pair p3=a+(b/2,h/2-tf);
      pair p8=a+(b2/2,-h/2+tf2);
      pair p9=a+(b2/2,-h/2);
      pair p10=a+(-b2/2,-h/2);
      pair p11=a+(-b2/2,-h/2+tf2);
      pair p16=a+(-b/2,h/2-tf);

      real r2=r*sqrt(2);
      pair p4=a+(tw/2+r2,h/2-tf);
      pair p5=a+(tw/2,h/2-tf-r2);
      pair p6=a+(tw/2,-h/2+tf2+r2);
      pair p7=a+(tw/2+r2,-h/2+tf2);
      pair p12=a+(-tw/2-r2,-h/2+tf2);
      pair p13=a+(-tw/2,-h/2+tf2+r2);
      pair p14=a+(-tw/2,h/2-tf-r2);
      pair p15=a+(-tw/2-r2,h/2-tf);

      pair p17=a+(-tw/2,h/2-tf);
      pair p18=a+(-tw/2,-h/2+tf2);
      pair p19=a+(tw/2,-h/2+tf2);
      pair p20=a+(tw/2,h/2-tf);

    //Flansch oben
      path pfo=p1--p2--p3--p16--cycle;
      filldraw(rotate(angle,a)*pfo,white,pen1);
      filldraw(rotate(angle,a)*pfo,pattern(s),pen1);
    //Flansch unten
      path pfu=p8--p9--p10--p11--cycle;
      filldraw(rotate(angle,a)*pfu,white,pen1);
      filldraw(rotate(angle,a)*pfu,pattern(s),pen1);
    //Steg
      path pw=p17--p18--p19--p20--cycle;
      filldraw(rotate(angle,a)*pw,white,pen1);
      filldraw(rotate(angle,a)*pw,pattern(s),pen1);
    //Schweißnähte
      filldraw(rotate(angle,a)*(p14--p15--p17--cycle),black,pen1);
      filldraw(rotate(angle,a)*(p4--p5--p20--cycle),black,pen1);
      filldraw(rotate(angle,a)*(p6--p7--p19--cycle),black,pen1);
      filldraw(rotate(angle,a)*(p12--p13--p18--cycle),black,pen1);
      }
	  
// U-, T-querschnitte--------------------------------------------------------------------------------------------------------------

 void Tprofil(pair a, real b, real h, real tw, real tf, real r,
              bool rundung=true, string s="stahl", pen pen1=defaultpen, real angle=0, string ausr="M"){

      if(ausr=="NE"){
	a=a+(b/2,h/2);
      }else{
      if(ausr=="E"){
      	a=a+(b/2,0);
      }else{
      if(ausr=="SE"){
      	a=a+(b/2,-h/2);
      }else{
      if(ausr=="S"){
      	a=a+(0,-h/2);
      }else{
      if(ausr=="SW"){
      	a=a+(-b/2,-h/2);
      }else{
      if(ausr=="W"){
      	a=a+(-b/2,0);
      }else{
      if(ausr=="NW"){
      	a=a+(-b/2,h/2);
      }else{
      if(ausr=="N"){
      	a=a+(0,h/2);
      }else{}}}}}}}}

      pair p1=a+(-b/2,h/2);
      pair p2=a+(b/2,h/2);
      pair p3=a+(b/2,h/2-tf);
      pair p6=a+(tw/2,-h/2);
      pair p7=a+(-tw/2,-h/2);
      pair p10=a+(-b/2,h/2-tf);

      if(rundung==true){
        pair p4=a+(tw/2+r,h/2-tf);
        pair p5=a+(tw/2,h/2-tf-r);
        pair p8=a+(-tw/2,h/2-tf-r);
        pair p9=a+(-tw/2-r,h/2-tf);
        path pa=p1--p2--p3--p4{left}..{down}p5--p6--p7--p8{up}..{left}p9--p10--cycle;
        filldraw(rotate(angle,a)*pa,white,pen1);
        filldraw(rotate(angle,a)*pa,pattern(s),pen1);
        }
      else{
        real r2=r*sqrt(2);
        pair p4=a+(tw/2+r2,h/2-tf);
        pair p5=a+(tw/2,h/2-tf-r2);
        pair p8=a+(-tw/2,h/2-tf-r2);
        pair p9=a+(-tw/2-r2,h/2-tf);

        pair p11=a+(-tw/2,h/2-tf);
        pair p12=a+(tw/2,h/2-tf);

        //Flansch oben
          filldraw(rotate(angle,a)*(p1--p2--p3--p10--p1--cycle),white,pen1);
          filldraw(rotate(angle,a)*(p1--p2--p3--p10--p1--cycle),pattern(s),pen1);
        //Steg
          filldraw(rotate(angle,a)*(p6--p7--p11--p12--cycle),white,pen1);
          filldraw(rotate(angle,a)*(p6--p7--p11--p12--cycle),pattern(s),pen1);
        //Schweißnähte
          filldraw(rotate(angle,a)*(p4--p5--p12--p4--cycle),black,pen1);
          filldraw(rotate(angle,a)*(p8--p9--p11--p8--cycle),black,pen1);
        }
        }

 void U(pair a, string t, pen pen1=defaultpen, real angle=0, string ausr="M", string m="stahl"){
      include profile;

    //Höhe
      real h=0;
      for(int i=0;i<=(Un.length-1);++i){
          if(t==Un[i]){
              h=Uw[i][0];
              break;}
          else{}}
    //Breite
      real b=0;
      for(int i=0;i<=(Un.length-1);++i){
          if(t==Un[i]){
              b=Uw[i][1];
              break;}
          else{}}
    //Stegdicke
      real s=0;
      for(int i=0;i<=(Un.length-1);++i){
          if(t==Un[i]){
              s=Uw[i][2];
              break;}
          else{}}
    //Radius1/Flanschdicke
      real r1=0;
      for(int i=0;i<=(Un.length-1);++i){
          if(t==Un[i]){
              r1=Uw[i][3];
              break;}
          else{}}
    //Radius2
      real r2=0;
      for(int i=0;i<=(Un.length-1);++i){
          if(t==Un[i]){
              r2=Uw[i][4];
              break;}
          else{}}
    //Kammerhöhe
      real h1=0;
      for(int i=0;i<=(Un.length-1);++i){
          if(t==Un[i]){
              h1=Uw[i][5];
              break;}
          else{}}
    //Winkelberechnung
      real alpha=0;
      if(h<=300){
          alpha=atan(8/100);}
      else{
          alpha=atan(5/100);} 

      if(ausr=="NE"){
	a=a+(b/2,h/2);
      }else{
      if(ausr=="E"){
      	a=a+(b/2,0);
      }else{
      if(ausr=="SE"){
      	a=a+(b/2,-h/2);
      }else{
      if(ausr=="S"){
      	a=a+(0,-h/2);
      }else{
      if(ausr=="SW"){
      	a=a+(-b/2,-h/2);
      }else{
      if(ausr=="W"){
      	a=a+(-b/2,0);
      }else{
      if(ausr=="NW"){
      	a=a+(-b/2,h/2);
      }else{
      if(ausr=="N"){
      	a=a+(0,h/2);
      }else{}}}}}}}}
     
      pair p1=a+(0,h/2);
      pair p2=a+(b,h/2);
      pair p3=a+(b-r2+sin(alpha)*r2,h/2-cos(alpha)*r2);
      pair p4=a+(s+r1-sin(alpha)*r1,h1/2+cos(alpha)*r1);
      pair p5=a+(s,h1/2);
      pair p6=a+(s,-h1/2);
      pair p7=a+(s+r1-sin(alpha)*r1,-h1/2-cos(alpha)*r1);
      pair p8=a+(b-r2+sin(alpha)*r2,-h/2+cos(alpha)*r2);
      pair p9=a+(b,-h/2);
      pair p10=a+(0,-h/2);

      path upath=p1--p2{down}..p3--p4..{down}p5--p6{down}..p7--p8..{down}p9--p10--cycle;

      filldraw(rotate(angle,a)*upath,white,pen1);
      filldraw(rotate(angle,a)*upath,pattern(m),pen1);
      }

// Trapezprofile-------------------------------------------------------------------------------------------------------------------

 void Trapezblech(pair a, string t, real lges=1000, pen pen1=defaultpen+2){
      include profile;

    //Höhe
        real h=0;
        for(int i=0;i<=(Trapezn.length-1);++i){
            if(t==Trapezn[i]){
                h=Trapezw[i][0];
                break;}
            else{}}
    //Länge
        real l=0;
        for(int i=0;i<=(Trapezn.length-1);++i){
            if(t==Trapezn[i]){
                l=Trapezw[i][1];
                break;}
            else{}}
    //Breite oben
        real bo=0;
        for(int i=0;i<=(Trapezn.length-1);++i){
            if(t==Trapezn[i]){
                bo=Trapezw[i][2];
                break;}
            else{}}
    //Breite unten
        real bu=0;
        for(int i=0;i<=(Trapezn.length-1);++i){
            if(t==Trapezn[i]){
                bu=Trapezw[i][3];
                break;}
            else{}}

    pair p1=a+(0,0);
    pair p2=a+(bu/2,0);
    pair p3=a+(l/2-bo/2,h);
    pair p4=a+(l/2+bo/2,h);
    pair p5=a+(l-bu/2,0);
    pair p6=a+(l,0);
    path trpath=p1--p2--p3--p4--p5--p6;

    int x=0;
    for(int i=0;i<=(lges/2)/l;++i){
        draw(shift(((i-1)*l,0))*trpath,pen1);
        draw(shift((-(i)*l,0))*trpath,pen1);
        x=i;
        path rpath;
    }
    real r=lges/2-x*l;
    if(r>=l-bu){
        pair p7=a+(r,0);
        path rpath=p1--p2--p3--p4--p5--p7;
        draw(shift((x*l,0))*rpath,pen1);
        draw(shift((-x*l,0))*reflect((0,0),(0,h))*rpath,pen1);
      }
      else if(r>=l/2+bo/2){
          real hr=h/(l/2-bo/2-bu/2)*(l-bu/2-r);
          pair p7=a+(r,hr);
          path rpath=p1--p2--p3--p4--p7;
          draw(shift((x*l,0))*rpath,pen1);
          draw(shift((-x*l,0))*reflect((0,0),(0,h))*rpath,pen1);
        }
        else if(r>=l/2-bo/2){
          pair p7=a+(r,h);
          path rpath=p1--p2--p3--p7;
          draw(shift((x*l,0))*rpath,pen1);
          draw(shift((-x*l,0))*reflect((0,0),(0,h))*rpath,pen1);
        }
        else if(r>=bu/2){
            real hr=h/(l/2-bo/2-bu/2)*(r-bu/2);
            pair p7=a+(r,hr);
            path rpath=p1--p2--p7;
            draw(shift((x*l,0))*rpath,pen1);
            draw(shift((-x*l,0))*reflect((0,0),(0,h))*rpath,pen1);
          }
          else{
              pair p7=a+(r,0);
              path rpath=p1--p7;
              draw(shift((x*l,0))*rpath,pen1);
              draw(shift((-x*l,0))*reflect((0,0),(0,h))*rpath,pen1);
            }
       }

// Traegeransicht-------------------------------------------------------------------------------------------------------------------

 void Iansicht(pair p0, string n, real lges=1000, real w=0, bool ra=true, bool lschnitt=true, bool rschnitt=true, string ausr="M", pen p=defaultpen){
	include profile;
	
	pen pen1=p;
	pen pen2=p+dashed;
	pen pen3=p+dashed;
	
	string profil=substr(n,0,3);
	string t=substr(n,3,-1);
	
	real h,tf,r;
	
	if(profil=="IPE"){
	    //Höhe
	    for(int i=0;i<=(IPEn.length-1);++i){
	    	if(t==IPEn[i]){
	    		h=IPEw[i][0];
	    		break;}
	    	else{}}
	    //Flanschdicke
	    for(int i=0;i<=(IPEn.length-1);++i){
	    	if(t==IPEn[i]){
	    		tf=IPEw[i][3];
	    		break;}
	    	else{}}
	    //Radius
	    for(int i=0;i<=(IPEn.length-1);++i){
	    	if(t==IPEn[i]){
	    		r=IPEw[i][4];
	    		break;}
	    	else{}}}
	else{if(profil=="HEA"){
		//Höhe
		for(int i=0;i<=(HEAn.length-1);++i){
			if(t==HEAn[i]){
				h=HEAw[i][0];
				break;}
			else{}}
		//Flanschdicke
		for(int i=0;i<=(HEAn.length-1);++i){
			if(t==HEAn[i]){
				tf=HEAw[i][3];
				break;}
			else{}}
		//Radius
		for(int i=0;i<=(HEAn.length-1);++i){
			if(t==HEAn[i]){
				r=HEAw[i][4];
				break;}
			else{}}}
	else{if(profil=="HEB"){
		//Höhe
		for(int i=0;i<=(HEBn.length-1);++i){
			if(t==HEBn[i]){
				h=HEBw[i][0];
				break;}
			else{}}
		//Flanschdicke
		for(int i=0;i<=(HEBn.length-1);++i){
			if(t==HEBn[i]){
				tf=HEBw[i][3];
				break;}
			else{}}
		//Radius
		for(int i=0;i<=(HEBn.length-1);++i){
			if(t==HEBn[i]){
				r=HEBw[i][4];
				break;}
			else{}}}
	else{if(profil=="HEM"){
		//Höhe
		for(int i=0;i<=(HEMn.length-1);++i){
			if(t==HEMn[i]){
				h=HEMw[i][0];
				break;}
			else{}}
		//Flanschdicke
		for(int i=0;i<=(HEMn.length-1);++i){
			if(t==HEMn[i]){
				tf=HEMw[i][3];
				break;}
			else{}}
		//Radius
		for(int i=0;i<=(HEMn.length-1);++i){
			if(t==HEMn[i]){
				r=HEMw[i][4];
				break;}
			else{}}}
	else{}}}}	
    
    pair a=p0;
    real b=lges;

    if(ausr=="NE"){
      	a=a+(b/2,h/2);
    }else{
    if(ausr=="E"){
      	a=a+(b/2,0);
    }else{
    if(ausr=="SE"){
      	a=a+(b/2,-h/2);
    }else{
    if(ausr=="S"){
      	a=a+(0,-h/2);
    }else{
    if(ausr=="SW"){
      	a=a+(-b/2,-h/2);
    }else{
    if(ausr=="W"){
      	a=a+(-b/2,0);
    }else{
    if(ausr=="NW"){
      	a=a+(-b/2,h/2);
    }else{
    if(ausr=="N"){
      	a=a+(0,h/2);
    }else{}}}}}}}}
    
    pair p1=a+(-lges/2,h/2);
    pair p2=a+(lges/2,h/2);
    
    pair p3=a+(-lges/2,h/2-tf);
    pair p4=a+(lges/2,h/2-tf);
    
    pair p9=a+(-lges/2,h/2-tf-r);
    pair p10=a+(lges/2,h/2-tf-r);
    
    draw(rotate(w,a)*(p1--p2),pen1);
    draw(rotate(w,a)*(p3--p4),pen1);
    draw(rotate(w+180,a)*(p1--p2),pen1);
    draw(rotate(w+180,a)*(p3--p4),pen1);
    
    if(ra==true){
	    draw(rotate(w,a)*(p9--p10),pen3);
	    draw(rotate(w+180,a)*(p9--p10),pen3);
	}
    
    pair p5,p6,p7,p8;
    
    if(lschnitt==true){
	    p5=p1+(0,h/10);
	    p6=p1+(0,-11*h/10);
	    draw(rotate(w,a)*(p5--p6),pen2);
	}else{
		p6=p1+(0,-h);
		draw(rotate(w,a)*(p1--p6),pen1);
	}
    if(rschnitt==true){
	    p7=p2+(0,h/10);
	    p8=p2+(0,-11*h/10);
	    draw(rotate(w,a)*(p7--p8),pen2);
    }else{
	    p8=p2+(0,-h);
	    draw(rotate(w,a)*(p2--p8),pen1);
    }
 }

// --------------------------------------------------------------------------------------------------------------------------------
// Verbundbau----------------------------------------------------------------------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------------------------

 void Vtrager(string tp, real dt, real dp, real l=1000, bool bemassung=true, real x=80, bool bewehrung=false, real ds=20,
              real e=80, real cnom=40){

      include profile;

      string profil=substr(tp,0,3);
      string pzahl=substr(tp,3,-1);

      real h=0;
      real br=0;
      pair b=(0,0);

      if(profil=="HEA"){
          for(int i=0;i<=(HEAn.length-1);++i){
              if(pzahl==HEAn[i]){
                  h=HEAw[i][0];
                  break;}
              else{}}
          for(int i=0;i<=(HEAn.length-1);++i){
              if(pzahl==HEAn[i]){
                  br=HEAw[i][1];
                  break;}
              else{}}
          b=(0,-dt-dp-h/2);
          HEA(b,pzahl,defaultpen+1);
          }
      else if(profil=="IPE"){
          for(int i=0;i<=(IPEn.length-1);++i){
              if(pzahl==IPEn[i]){
                  h=IPEw[i][0];
                  break;}
              else{}}
          for(int i=0;i<=(IPEn.length-1);++i){
              if(pzahl==IPEn[i]){
                  br=IPEw[i][1];
                  break;}
              else{}}
          b=(0,-dt-dp-h/2);
          IPE(b,pzahl,defaultpen+1);
          }
      else if(profil=="Iprofil"){
          h=200;
          br=100;
          b=(0,-dt-dp-h/2);
          Iprofil(b,100,200,10,15,8,defaultpen+1,0,100,15,"stahl");
          }
      
      rechteck((0,-dp/2),l,dp,"beton",defaultpen+white);
      draw((-l/2,0)--(l/2,0),defaultpen+1);
      draw((-l/2,-dp)--(l/2,-dp),defaultpen+1);
      draw((-l/2,-dp-dt)--(l/2,-dp-dt),defaultpen+1);

      real[] y1={dp,dt,h};
      real[] x1={br};
      if(bewehrung==true){
          for(real i=0;i<=l/2/e;++i){
              pair d=-(0,cnom+ds/2);
              pair dl=d+(-i*e,0);
              pair dr=d+(i*e,0);
              kreis(dl,ds/2,"black",invisible);
              kreis(dr,ds/2,"black",invisible);
              }
          rechteck((-(l/2+ds/2),-(cnom+ds/2)),ds,ds,"white",invisible);
          rechteck(((l/2+ds/2),-(cnom+ds/2)),ds,ds,"white",invisible);
          if(bemassung==true){
              real[] y2={(cnom+ds/2)};
              real[] x2={e};
              hbemassung(x2,(0,0),x/2);
              vbemassung(-y2,(-l/2,0),-x/2);
              }
          }
      if(bemassung==true){
          vbemassung(-y1,(l/2,0),x);
          hbemassung(x1,(-br/2,-(dp+dt+h)),-x);
          }
      draw((-l/2,0.1*(dp+dt))--(-l/2,-(dp+dt)*1.1),defaultpen+1.5+dashed);
      draw((l/2,0.1*(dp+dt))--(l/2,-(dp+dt)*1.1),defaultpen+1.5+dashed);
      }
	  
// new composite beam 

void verbund_traeger (pair p0 = (0,0), string p="IPE300", real trapez_height = 51, real beton_dicke = 109, real beton_breite =1000, bool bewehrung = true, real ds = 20, real as = 80, real cnom = 20, string bew = "\o $10/20cm$",bool bemassung = false, real anno_dist = 80, bool ansicht = false) {
	
	//include profile;
	
	real h = profil_parameter (p, "h");
	real b = profil_parameter (p, "b"); 
	real tw = profil_parameter (p, "tw"); 
	
	walz_profil (p0, p, 0, "M", "stahl");
	
	rechteck( p0 + (0, h/2 + trapez_height/2 + beton_dicke/2), beton_breite, trapez_height + beton_dicke, "beton",defaultpen+white);
	
	real[] y1 = {beton_dicke, trapez_height, h};
    real[] x1 = {b};
    
	if(bewehrung==true)
	{
		for(real i=0; i<=beton_breite /2 /as; ++i)
		{
		pair d=p0 + (0, h/2 + trapez_height + beton_dicke) -(0,cnom+ds/2);
        pair dl=d + (-i*as,0);
        pair dr=d + (i*as,0);
        kreis(dl,ds/2,"black",invisible);
        kreis(dr,ds/2,"black",invisible);
        }
    }
	
	rechteck(p0 + (0, h/2 + trapez_height/2), beton_breite, trapez_height, "white",invisible); 
	
	draw (
	( p0 + (beton_breite/2, h/2) ) -- ( p0 + (-beton_breite/2, h/2) ) ^^
	( p0 + (beton_breite/2, h/2 + trapez_height) ) -- ( p0 + (-beton_breite/2, h/2+ trapez_height) ) ^^
	( p0 + (beton_breite/2, h/2 + trapez_height + beton_dicke) ) -- ( p0 + (-beton_breite/2, h/2+ trapez_height + beton_dicke) ),
	black+1
	);
	
	rechteck ( p0 + (0, h/2 + trapez_height * 1.2 / 2), tw*1.5, trapez_height * 1.2, "black"); 
	rechteck ( p0 + (0, h/2 + trapez_height * 1.2 + 20 / 2), tw*1.5 *1.5, tw*2, "black"); 
	
    draw(
	(p0 + (beton_breite/2, h/2 + (trapez_height + beton_dicke)*1.1 )) -- (p0 + (beton_breite/2, h/2 - (trapez_height + beton_dicke)*0.1 )) ^^
	(p0 + (- beton_breite/2, h/2 + (trapez_height + beton_dicke)*1.1 )) -- (p0 + (- beton_breite/2, h/2 - (trapez_height + beton_dicke)*0.1 )),
	defaultpen+1.5+dashed
	);
	
	if (bemassung == true)
	{

		bemassung ( p0 + (beton_breite/2, h/2) , p0 + (beton_breite/2, h/2 + trapez_height), - anno_dist, true, true, "L");
		bemassung ( p0 + (beton_breite/2, h/2 + trapez_height) , p0 + (beton_breite/2, h/2 + trapez_height + beton_dicke - cnom -ds/2), - anno_dist);
		bemassung ( p0 + (beton_breite/2, h/2 + trapez_height + beton_dicke - cnom - ds/2) , p0 + (beton_breite/2, h/2 + trapez_height + beton_dicke), - anno_dist, true, true, "R");
		
		draw ( 
		(p0 + (0, h/2 + trapez_height + beton_dicke - cnom - ds/2)) -- (p0 + (0, h/2 + trapez_height + beton_dicke - cnom - ds/2) + (anno_dist, anno_dist)) -- (p0 + (0, h/2 + trapez_height + beton_dicke - cnom - ds/2) + (anno_dist, anno_dist) + (anno_dist, 0)), 
		defaultpen+1
		);
		label (bew, p0 + (0, h/2 + trapez_height + beton_dicke - cnom - ds/2) + (anno_dist, anno_dist) + (anno_dist, 0), E);
		//label (p , p0 , E);
	}
	
	if (ansicht == true)
	{
		
		pair p1 = p0 + (beton_breite/2 + 3 * anno_dist + beton_breite/2, 0); // new location point
		
		Iansicht (p1, p, beton_breite, 0, false, false, false); // make ansicht 
		
		rechteck( p1 + (0, h/2 + trapez_height/2 + beton_dicke/2), beton_breite, trapez_height + beton_dicke, "beton",defaultpen+white); // make beton schicht
		
		// rechteck(p1 + (0, h/2 + trapez_height/2), beton_breite, trapez_height, "white",invisible); 
		
		draw 
		(
		( p1 + (beton_breite/2, h/2) ) -- ( p1 + (-beton_breite/2, h/2) ) ^^
		//( p1 + (beton_breite/2, h/2 + trapez_height) ) -- ( p1 + (-beton_breite/2, h/2+ trapez_height) ) ^^
		( p1 + (beton_breite/2, h/2 + trapez_height + beton_dicke) ) -- ( p1 + (-beton_breite/2, h/2+ trapez_height + beton_dicke) ),
		black+1
		);
		
		draw(
		(p1 + (beton_breite/2, h/2 + (trapez_height + beton_dicke)*1.1 )) -- (p1 + (beton_breite/2, - h/2 - (trapez_height + beton_dicke)*0.1 )) ^^
		(p1 + (- beton_breite/2, h/2 + (trapez_height + beton_dicke)*1.1 )) -- (p1 + (- beton_breite/2, - h/2 - (trapez_height + beton_dicke)*0.1 )),
		white+1
		);
		
		draw(
		(p1 + (beton_breite/2, h/2 + (trapez_height + beton_dicke)*1.1 )) -- (p1 + (beton_breite/2, - h/2 - (trapez_height + beton_dicke)*0.1 )) ^^
		(p1 + (- beton_breite/2, h/2 + (trapez_height + beton_dicke)*1.1 )) -- (p1 + (- beton_breite/2, - h/2 - (trapez_height + beton_dicke)*0.1 )),
		defaultpen+1.5+dashed
		);
		
		rechteck (p1 + (0, h/2 + trapez_height + beton_dicke - cnom - ds/2) , beton_breite, ds/1.25, "black");
		
		for(real i=0; i<= beton_breite / as /2/ 1.05; ++i)
		{
			rechteck ( p1 + (0 - beton_breite/2 + 2/3 * as + i * 2 * as, h/2 + trapez_height * 1.2 / 2), tw*1.5, trapez_height * 1.2, "black"); 
			rechteck ( p1 + (0 - beton_breite/2 + 2/3 * as + i * 2 * as, h/2 + trapez_height * 1.2 + 20 / 2), tw*1.5 *1.5, tw*2, "black"); 
			
			pair t1 = p1 + ( - beton_breite/2 -1/3 *as + (i+1) * 2 * as - as * 1/6  , h/2); 
			pair t2 = t1 + (- as * 1/3, trapez_height);
			pair t3 = t2 + (as * (1/6 *2 + 1/3 *2) ,0 );
			pair t4 = t3 + ( - as * 1/3, -trapez_height);
			path pez = t1 -- t2 -- t3 -- t4 --cycle;
			
			filldraw 
			(
				pez, white, black+1
			);
        }
	}	
	
}
      
// --------------------------------------------------------------------------------------------------------------------------------
// Bewehrung-----------------------------------------------------------------------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------------------------

 void rbewehrung(pair p0, real x, real y, real d, string s="stahl", pen p=defaultpen){
	pair p1=p0+(x,y);
	pair p2=p0-(x,y);
	pair sx=p0+(100,0);
	pair sy=p0+(0,100);
	
	kreis(p1,d,s,"M",p);
	kreis(p1,d,s,"M",p,reflect(p0,sx));
	kreis(p1,d,s,"M",p,reflect(p0,sy));
	kreis(p2,d,s,"M",p);
 }

 void kbewehrung(pair p0, real r, real d, int n, string s="stahl", pen p=defaultpen){
	real w=360/n;
	pair pr=p0+(r,0);
	for(int i=0; w*i<=360; ++i){
		kreis(pr,d,s,"M",p,rotate(w*i,p0));
	}
 }

// --------------------------------------------------------------------------------------------------------------------------------
// Balkenansichten-----------------------------------------------------------------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------------------------

 void spann(real l, real h0, real d, pair p=(0,0), pen pen1=defaultpen){
      import graph;
      real a=(h0-d)*4/l^2;
      real b=l/2;
      real f(real x){return a*(x-b)^2+d;}
      draw(shift(p)*graph(f,0,l),pen1+dashed);
      }

// --------------------------------------------------------------------------------------------------------------------------------
// Verbindungsmittel---------------------------------------------------------------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------------------------

 void schraubenkopf (pair c, string t, real w=0,pen p=defaultpen+0.5){
	include profile;
	
    //Schraubenkopfradius
      real s=0;
      for(int i=0;i<=(Schraubn.length-1);++i){
          if(t==Schraubn[i]){
              s=Schraubw[i][0];
              break;}
          else{}}
    //Schraubenkopfdicke
      real ts=0;
      for(int i=0;i<=(Schraubn.length-1);++i){
          if(t==Schraubn[i]){
              ts=Schraubw[i][1];
              break;}
          else{}}
    //Unterlegscheibenradius
      real su=0;
      for(int i=0;i<=(Schraubn.length-1);++i){
          if(t==Schraubn[i]){
              su=Schraubw[i][2];
              break;}
          else{}}
    //Unterlegscheibendicke
      real tu=0;
      for(int i=0;i<=(Schraubn.length-1);++i){
          if(t==Schraubn[i]){
              tu=Schraubw[i][3];
              break;}
          else{}}
    //Abfasung
      real f=0;
      for(int i=0;i<=(Schraubn.length-1);++i){
          if(t==Schraubn[i]){
              f=Schraubw[i][4];
              break;}
          else{}}
    
	pair p1=(0.5*s,0);
	pair p2=(0.25*s,0);
	pair p3=(-0.25*s,0);
	pair p4=(-0.5*s,0);
	pair p5=p1+(0,0.875*ts);
	pair p6=p2+(0,0.875*ts);
	pair p7=p3+(0,0.875*ts);
	pair p8=p4+(0,0.875*ts);
	pair p9=(0.44*s,ts);
	pair p10=(0.37*s,ts);
	pair p11=(0,ts);
	pair p12=(-0.37*s,ts);
	pair p13=(-0.44*s,ts);
	
	pair d=c+(tu*-sin(w/180*3.14159),tu*cos(w/180*3.14159));
	//path kopf=p1--p5--p9--p10--p12--p13--p8--p4--p1--p5..p10..p6--p2--p6..p11..p7--p3--p7..p12..p8;
	path kopf1=p1--p5--p9--p10--p12--p13--p8--p4--p1--cycle;
	path kopf2=p5..p10..p6--p2--p6..p11..p7--p3--p7..p12..p8;
	//draw(shift(d)*rotate(w)*kopf,p);
	filldraw (shift(d)*rotate(w)*kopf1,white,p);
	draw (shift(d)*rotate(w)*kopf2,p);
	
	pair q1=(0.5*su,0);
	pair q2=(0.5*su,tu-f/sqrt(2));
	pair q3=(0.5*su-f/sqrt(2),tu);
	pair q4=(-0.5*su+f/sqrt(2),tu);
	pair q5=(-0.5*su,tu-f/sqrt(2));
	pair q6=(-0.5*su,0);
	
	path uscheibe=q1--q2--q3--q4--q5--q6--cycle;
	//draw(shift(c)*rotate(w)*uscheibe,p);
	filldraw(shift(c)*rotate(w)*uscheibe,white,p);
}

 void schraubenmutter (pair c, string t, real w=0, pen p=defaultpen+0.5){
		include profile;
		
    //Mutterradius
      real s=0;
      for(int i=0;i<=(Schraubn.length-1);++i){
          if(t==Schraubn[i]){
              s=Schraubw[i][0];
              break;}
          else{}}
    //Mutterdicke
      real m=0;
      for(int i=0;i<=(Schraubn.length-1);++i){
          if(t==Schraubn[i]){
              m=Schraubw[i][5];
              break;}
          else{}}
    //Unterlegscheibenradius
      real su=0;
      for(int i=0;i<=(Schraubn.length-1);++i){
          if(t==Schraubn[i]){
              su=Schraubw[i][2];
              break;}
          else{}}
    //Unterlegscheibendicke
      real tu=0;
      for(int i=0;i<=(Schraubn.length-1);++i){
          if(t==Schraubn[i]){
              tu=Schraubw[i][3];
              break;}
          else{}}
    //Abfasung
      real f=0;
      for(int i=0;i<=(Schraubn.length-1);++i){
          if(t==Schraubn[i]){
              f=Schraubw[i][4];
              break;}
          else{}}
    //Durchmesser
      real ds=0;
      for(int i=0;i<=(Schraubn.length-1);++i){
          if(t==Schraubn[i]){
              ds=Schraubw[i][6];
              break;}
          else{}}
    
        real ts=m/2;
    
	pair p1=(0.5*s,0);
	pair p2=(0.25*s,0);
	pair p3=(-0.25*s,0);
	pair p4=(-0.5*s,0);
	pair p5=p1+(0,0.875*ts);
	pair p6=p2+(0,0.875*ts);
	pair p7=p3+(0,0.875*ts);
	pair p8=p4+(0,0.875*ts);
	pair p9=(0.44*s,ts);
	pair p10=(0.37*s,ts);
	pair p11=(0,ts);
	pair p12=(-0.37*s,ts);
	pair p13=(-0.44*s,ts);
	
	pair d=c+((tu+m/2)*-sin(w/180*3.14159),(tu+m/2)*cos(w/180*3.14159));
	pair e=c+((tu+m)*-sin(w/180*3.14159),(tu+m)*cos(w/180*3.14159));

	path kopf=p1--p5..p10..p6--p2--p6..p11..p7--p3--p7..p12..p8--p4--p8--p13--p10--p9--p5--p1;
	draw(shift(d)*rotate(w)*kopf,p);
	draw(shift(d)*rotate(w+180)*kopf,p);
	
	pair q1=(0.5*su,0);
	pair q2=(0.5*su,tu-f/sqrt(2));
	pair q3=(0.5*su-f/sqrt(2),tu);
	pair q4=(-0.5*su+f/sqrt(2),tu);
	pair q5=(-0.5*su,tu-f/sqrt(2));
	pair q6=(-0.5*su,0);
	
	path uscheibe=q1--q2--q3--q4--q5--q6--cycle;
	draw(shift(c)*rotate(w)*uscheibe,p);
	
	pair q7=(ds/2,0);
	pair q8=(ds/2,3);
	pair q9=(ds/2-2,5);
	pair q10=(-ds/2+2,5);
	pair q11=(-ds/2,3);
	pair q12=(-ds/2,0);
	
	path schra=q7--q8--q9--q10--q11--q12--q11--q8--q7;
	draw(shift(e)*rotate(w)*schra,p);	
}

 void schraubend (pair a, string t, pen p=defaultpen+0.5){
	include profile;

    //Schraubenkopfradius
      real s=0;
      for(int i=0;i<=(Schraubn.length-1);++i){
          if(t==Schraubn[i]){
              s=Schraubw[i][0];
              break;}
          else{}}
    //Unterlegscheibenradius
      real su=0;
      for(int i=0;i<=(Schraubn.length-1);++i){
          if(t==Schraubn[i]){
              su=Schraubw[i][2];
              break;}
          else{}}
	
	real ss=1/2*s/2;
	real cs=0.866025*s/2;
		
	pair p1=a+(ss,cs);
	pair p2=a+(s/2,0);
	pair p3=a+(ss,-cs);
	pair p4=a+(-ss,-cs);
	pair p5=a+(-s/2,0);
	pair p6=a+(-ss,cs);
	
	path schr=p1--p2--p3--p4--p5--p6--cycle;
	
	kreis(a,su/2,p);
	draw(schr,p);
	kreis(a,cs,defaultpen);
}

 void schraube (pair a, real t, string s, real w=0, bool schaft=false, pen p=defaultpen+0.5){
      include profile;
	
    //Durchmesser
      real ds=0;
      for(int i=0;i<=(Schraubn.length-1);++i){
          if(s==Schraubn[i]){
              ds=Schraubw[i][6];
              break;}
          else{}}
	          
	pair s1=a+(t/2*sin(-w/180*3.14159),t/2*cos(-w/180*3.14159));
	pair s2=a+(t/2*-sin(-w/180*3.14159),t/2*-cos(-w/180*3.14159));
	
	schraubenkopf (s1,s,w,p);
	schraubenmutter (s2,s,w+180,p);
	
	if(schaft==true){
		path schaftp=s1--s2;
	
		pair s3=(ds/2*cos(-w/180*3.14159),ds/2*sin(-w/180*3.14159));
		pair s4=(ds/2*-cos(-w/180*3.14159),ds/2*-sin(-w/180*3.14159));
	
		draw(shift(s3)*schaftp,dashed);
		draw(shift(s4)*schaftp,dashed);
		
	}else{}
}

 void naht (pair b, real a, string n, real t, real w=0, bool spiegeln=false){
	real x;
 	if(spiegeln==true){
 		x=-1;
 	}else{
 		x=1;}
 
 	void kn (pair b, real a, real t, real w, real x=1){
 		pair p1=(0,t/2);
 		pair p2=(a*sqrt(2),t/2);
 		pair p3=(0,t/2+a*sqrt(2));
 
 		path kn=p1--p2--p3--cycle;
 
 		fill(shift(b)*rotate(w)*scale(1,x)*kn,gray(0));
 	}
 
 	void hy (pair b, real a, real t, real w, real x=1){
 		pair p1=(0,t/2);
 		pair p2=(a,t/2);
 		pair p3=(0,t/2-a);
 
 		path hy=p1--p2--p3--cycle;
 
 		fill(shift(b)*rotate(w)*scale(1,x)*hy,gray(0));
 	}
 
 	void vn (pair b, real a, real t, real w, real x=1){
 		pair p1=(-a/2,t/2);
 		pair p2=(a/2,t/2);
 		pair p3=(0,t/2-a);
 
 		path hy=p1--p2--p3--cycle;
 
 		fill(shift(b)*rotate(w)*scale(1,x)*hy,gray(0));
 	}
 
 	if(n=="Doppelkehl"){
		kn(b,a,t,w,1);
		kn(b,a,t,w,-1);
 	}else{
 	if(n=="Kehl"){
	 	kn(b,a,t,w,x);
 	}else{
 	if(n=="V"){
	 	vn(b,t,t,w);
 	}else{
 	if(n=="DV"){
	 	vn(b,t/2,t,w,1);
	 	vn(b,t/2,t,w,-1);
 	}else{
 	if(n=="HV"){
	 	hy(b,t,t,w,x);
 	}else{
 	if(n=="DHV"){
	 	hy(b,t/2,t,w,1);
	 	hy(b,t/2,t,w,-1);
	}else{
 	if(n=="Y"){
	 	vn(b,a,t,w);
 	}else{
 	if(n=="DY"){
	 	vn(b,a/2,t,w,1);
	 	vn(b,a/2,t,w,-1);
 	}else{
 	if(n=="HY"){
	 	hy(b,a,t,w,x);
 	}else{
 	if(n=="DHY"){
	 	hy(b,a/2,t,w,1);
	 	hy(b,a/2,t,w,-1);
 	}}}}}}}}}}
 }

 void nahtd(pair b, real l, real w, real a=6, bool turn=false, real dl=10){
	real aa=1;
	if(turn==false){
		aa=a;}
	else{aa=-a;}
	for(int ii=0; ii*dl<=l; ++ii){
		draw((b+(ii*dl*cos(w/180*3.14159),ii*dl*sin(w/180*3.14159)))--(b+(ii*dl*cos(w/180*3.14159)+aa,ii*dl*sin(w/180*3.14159)+aa)));
	}
 }
 
// --------------------------------------------------------------------------------------------------------------------------------
// Klausurvereinfachungen----------------------------------------------------------------------------------------------------------
 //Funktion: Querschnittswerten-Tabellen für I-Profile 07072017--------------------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------------------------
 
 void AnalyseProfil(string profilklasse, string t, string werkstoff="S355", bool schraff=true, bool csys=true, bool bemass=true, bool punkt=true, int size0=10, int size1=12){
	if((profilklasse=="IPE"||profilklasse=="HEA")||(profilklasse=="HEB"||profilklasse=="HEM")){
		include profile;
		real h=0;
		real b=0;
		real tw=0;
		real tf=0;
		real r=0;
		string ss="stahl";
		if(schraff==true){
		}else{
			ss="white";
		}
		if(profilklasse=="IPE"){
			IPE((0,0),t,defaultpen,0,"M",ss);	
			//Höhe
			for(int i=0;i<=(IPEn.length-1);++i){
				if(t==IPEn[i]){
					h=IPEw[i][0];
					break;}
				else{}}
			//Breite
			for(int i=0;i<=(IPEn.length-1);++i){
				if(t==IPEn[i]){
					b=IPEw[i][1];
					break;}
				else{}}
			//Stegdicke
			for(int i=0;i<=(IPEn.length-1);++i){
				if(t==IPEn[i]){
					tw=IPEw[i][2];
					break;}
				else{}}
			//Flanschdicke
			for(int i=0;i<=(IPEn.length-1);++i){
				if(t==IPEn[i]){
					tf=IPEw[i][3];
					break;}
				else{}}
			//Radius
			for(int i=0;i<=(IPEn.length-1);++i){
				if(t==IPEn[i]){
					r=IPEw[i][4];
					break;}
				else{}}
		}else if(profilklasse=="HEA"){
			HEA((0,0),t,defaultpen,0,"M",ss);
			//Höhe
			for(int i=0;i<=(HEAn.length-1);++i){
				if(t==HEAn[i]){
					h=HEAw[i][0];
					break;}
				else{}}
			//Breite
			for(int i=0;i<=(HEAn.length-1);++i){
				if(t==HEAn[i]){
					b=HEAw[i][1];
					break;}
				else{}}
			//Stegdicke
			for(int i=0;i<=(HEAn.length-1);++i){
				if(t==HEAn[i]){
					tw=HEAw[i][2];
					break;}
				else{}}
			//Flanschdicke
			for(int i=0;i<=(HEAn.length-1);++i){
			if(t==HEAn[i]){
				tf=HEAw[i][3];
					break;}
					else{}}
			//Radius
			for(int i=0;i<=(HEAn.length-1);++i){
				if(t==HEAn[i]){
					r=HEAw[i][4];
					break;}
			else{}}
		}else if(profilklasse=="HEB"){
			HEB((0,0),t,defaultpen,0,"M",ss);
			//Höhe
			for(int i=0;i<=(HEBn.length-1);++i){
				if(t==HEBn[i]){
					h=HEBw[i][0];
					break;}
			else{}}
			//Breite
			for(int i=0;i<=(HEBn.length-1);++i){
				if(t==HEBn[i]){
					b=HEBw[i][1];
					break;}
			else{}}
			//Stegdicke
			for(int i=0;i<=(HEBn.length-1);++i){
				if(t==HEBn[i]){
					tw=HEBw[i][2];
					break;}
			else{}}
			//Flanschdicke
			for(int i=0;i<=(HEBn.length-1);++i){
				if(t==HEBn[i]){
					tf=HEBw[i][3];
					break;}
			else{}}
			//Radius
			for(int i=0;i<=(HEBn.length-1);++i){
				if(t==HEBn[i]){
					r=HEBw[i][4];
					break;}
			else{}}
		}else if(profilklasse=="HEM"){
			HEM((0,0),t,defaultpen,0,"M",ss);
			//Höhe
			for(int i=0;i<=(HEMn.length-1);++i){
				if(t==HEMn[i]){
					h=HEMw[i][0];
					break;}
				else{}}
			//Breite
			for(int i=0;i<=(HEMn.length-1);++i){
				if(t==HEMn[i]){
					b=HEMw[i][1];
					break;}
				else{}}
			//Stegdicke
			for(int i=0;i<=(HEMn.length-1);++i){
				if(t==HEMn[i]){
					tw=HEMw[i][2];
					break;}
				else{}}
			//Flanschdicke
			for(int i=0;i<=(HEMn.length-1);++i){
				if(t==HEMn[i]){
					tf=HEMw[i][3];
					break;}
				else{}}
			//Radius
			for(int i=0;i<=(HEMn.length-1);++i){
				if(t==HEMn[i]){
					r=HEMw[i][4];
					break;}
				else{}}
		}
		real abstand=40;
		real sizeUser=getPictureSizeUser(currentpicture);
		real sizePS=getPictureSizePS(currentpicture);
		real x;
		if(bemass==false){
			sizeUser=(sizePS+0*abstand)/sizePS*sizeUser;
			x=abstand/(sizePS+0*abstand)*sizeUser;
		}else{
			sizeUser=(sizePS+2*abstand)/sizePS*sizeUser;
			x=abstand/(sizePS+2*abstand)*sizeUser;
		}
		if(bemass==true){
			defaultpen(fontsize(size1*pt));
			label("\textbf{"+profilklasse+" "+t+", "+werkstoff+" [mm]}",(-b/2-x*2,h/2+x*2),NE);
			defaultpen(fontsize(size0*pt));
			bemassung((-b/2,h/2),(b/2,h/2),x,true,0,"",false,"O");
			bemassung((-b/2,-h/2),(-b/2,h/2),x,true,0,"",false,"O");
			bemassung((-tw/2,x),(tw/2,x),0,true,1,"",true,"L");		
			rbemassung((tw/2,h/2-tf-r),(tw/2+r,h/2-tf),90,0.5);
			bemassung((-b/4,h/2-tf),(-b/4,h/2),0,true,2,"",true,"L");
		}
		if(csys==true){
			CSYS((0,0),sizeUser/5,270,"","$y$",0.5,0.5,defaultpen+1,2*E,N);
			label("$z$",(tw/2,-sizeUser/10),E);
		}
		real[][] punkte={{-b/2    ,h/2      },
					 {-tw/2-r ,h/2      },
					 {0       ,h/2      },
					 {tw/2+r  ,h/2      },
					 {b/2     ,h/2      },
					 {-b/2    ,-h/2     },
					 {-tw/2-r ,-h/2     },
					 {0       ,-h/2     },
					 {tw/2+r  ,-h/2     },
					 {b/2     ,-h/2     },
					 {0       ,h/2-tf-r },
					 {0       ,-h/2+tf+r},
					 {0 	  ,0        }};
					 
		align[] ausricht={2N,2N,2N,2N,2N,2S,2S,2S,2S,2S,W,W,E};
		
		real[][] rueck={{0,0},
						{0,0},
						{0,0},
						{0,0},
						{0,0},
						{0,0},
						{0,0},
						{0,0},
						{0,0},
						{0,0},
						{-tw/2,0},
						{-tw/2,0},
						{tw/2,0}};
		
		if(punkt==true){
			for(int i=0;i<punkte.length;++i){
				dot((punkte[i][0],punkte[i][1]),defaultpen+4.5);
				label(string(i+1),(punkte[i][0]+rueck[i][0],punkte[i][1]+rueck[i][1]),ausricht[i]);
			}
		}
		real[][] Fout=new real[13][6];
		for(int i=0;i<punkte.length;++i){
			Fout[i][0]=i+1;
			Fout[i][1]=-punkte[i][0];
			Fout[i][2]=-punkte[i][1];
			Fout[i][3]=0;
			Fout[i][4]=0;
			if(i<10){
				Fout[i][5]=tf;
			}else{
				Fout[i][5]=tw;
			}
		}
		Fout[1][3] = abs((Fout[0][1]-Fout[1][1])*(Fout[0][5]))*(Fout[0][2]+Fout[1][5]/2)/(1000);
		Fout[1][4] = abs((Fout[0][1]-Fout[1][1])*(Fout[0][5]))*((Fout[0][1]-Fout[1][1])/2+Fout[1][1])/(1000);
		
		Fout[2][3] = abs((Fout[0][1])*(Fout[0][5]))*(Fout[0][2]+Fout[1][5]/2)/(1000);
		Fout[2][4] = abs((Fout[0][1])*(Fout[0][5]))*((Fout[0][1])/2)/(1000);
		
		Fout[3][3] = Fout[1][3];
		Fout[3][4] = -Fout[1][4];
		
		Fout[6][3] = Fout[1][3];
		Fout[6][4] = -Fout[1][3];
		
		Fout[7][3] = Fout[2][3];
		Fout[7][4] = -Fout[2][3];
		
		Fout[8][3] = Fout[3][3];
		Fout[8][4] = -Fout[3][3];
		
		Fout[10][3] = ((b*tf)*-(h/2-tf/2)+(r*tw)*-(h/2-r/2-tf)+(0.21402*r^2)*-(0.373399*r+(h/2-tf-r))*2)/1000;
			
		Fout[11][3] = -Fout[10][3];
		
		Fout[12][3] = -Fout[10][3]+((h/2-r-tf)^2/2*tw)/1000;
		
		// string[] table=new string[20];
		// table[0]="\renewcommand\arraystretch{1.5}\definecolor{lightgray}{gray}{0.9}";
		// table[1]="\begin{tabularx}{\textwidth}{|>{\columncolor{lightgray}}Y|Y|Y|Y|Y|Y|}";
		// table[2]="\hline";
		// table[3]="\rowcolor{lightgray}";
		// table[4]="Punkt & \multicolumn{2}{c|}{Koordinaten} & \multicolumn{2}{c|}{Statische Momente} & Dicke\\";
		// table[5]="\rowcolor{lightgray}";
		// table[6]="Nr. & $y$ [mm] & $z$ [mm] & $S_y$ [cm$^3$] & $S_z$ [cm$^3$] & t [mm]\\";
		
		// for(int i=0;i<punkte.length;++i){
			// table[i+7]=string(Fout[i][0])+" & "+string(round(Fout[i][1]*100)/100)+" & "+string(round(Fout[i][2]*100)/100)+" & "+string(round(Fout[i][3]*100)/100)+" & "+string(round(Fout[i][4]*100)/100)+" & "+string(round(Fout[i][5]*100)/100)+"\\ \hline";
		// }
		// table[table.length]="\end{tabularx}";
		
		string[] table=new string[20];
		table[0]="\renewcommand\arraystretch{1.5}";
		table[1] = "\begin{center}";
		table[2]="\begin{tabular}{|c|c|c|c|c|c|}";
		table[3]="\hline";
		//table[3]="\rowcolor{lightgray}";
		table[4]="Punkt & \multicolumn{2}{c|}{Koordinaten} & \multicolumn{2}{c|}{Statische Momente} & Dicke\\ \hline";
		//table[5]="\rowcolor{lightgray}";
		table[5]="Nr. & $y$ [mm] & $z$ [mm] & $S_y$ [cm$^3$] & $S_z$ [cm$^3$] & t [mm]\\ \hline";
		
		for(int i=0;i<punkte.length;++i){
			table[i+6]=string(Fout[i][0])+" & "+string(round(Fout[i][1]*10)/10)+" & "+string(round(Fout[i][2]*10)/10)+" & "+string(round(Fout[i][3]*10)/10)+" & "+string(round(Fout[i][4]*10)/10)+" & "+string(round(Fout[i][5]*10)/10)+"\\ \hline";
		}
		table[table.length]="\end{tabular} \end{center}";
		
		
		file fout=output(profilklasse+"_"+t+".tex");
		write(fout,table);
	}
}


/////////////// beliebig offener Profil, zur Aufgabe Spannungzeichnung///////////////////
////////////// added: 21.07.2017 //////////////
////////////// updated: 24.07.2017		 //////////////

 //void OffenProfil (real bw= 10, real hw= 300, real bfol=100, real hfol=10, real bfor=100, real hfor=10, real bful=100, real hful=10, real bfur=100 , real hfur=10, real blolo=0, real hlolo=0, real bloro=0, real hloro=0, real blolu = 0 , real hlolu=0, real bloru = 0, real hloru = 0, real bfml = 0, real hfml = 0, real bfmr = 0, real hfmr = 0, real blulo = 0 , real hlulo = 0, real bluro = 0, real hluro = 0, real blulu = 0, real hlulu = 0, real bluru = 0, real hluru = 0, bool koordi = true, bool last = false, string moment = "My", string sforce = "Vz")
 
 void OffenProfil (pair sw, real sc = 1, real bw= 10, real hw= sc * 300, real bfol= sc *100, real hfol= 10, real bfor=100, real hfor=10, real bful=100, real hful=10, real bfur=100 , real hfur=10, real blolo=0, real hlolo=0, real bloro=0, real hloro=0, real blolu = 0 , real hlolu=0, real bloru = 0, real hloru = 0, real bfml = 0, real hfml = 0, real bfmr = 0, real hfmr = 0, real blulo = 0 , real hlulo = 0, real bluro = 0, real hluro = 0, real blulu = 0, real hlulu = 0, real bluru = 0, real hluru = 0, bool koordi = true, bool last = false, string moment = "My", string sforce = "Vz")
 
 {
	/////////Parameter eines offenen Profils/////////
	// 1. w Steg	
	// bw = sc * bw; 
	// hw = sc * hw;
	// 2. lolo - Lippe Oben Links Oben
	// blolo = sc * blolo;
	// hlolo = sc * hlolo;
	// 3. loro - Lippe Oben Rechts Oben
	// bloro = sc * bloro;
	// hloro = sc * hloro;
	// 4. fol -  Flansch Oben Links	
	// bfol = sc * bfol;
	// hfol = hfol * sc;
	// 5. for - Flansch Oben Rechts
	// bfor = bfor * sc;
	// hfor = hfor * sc;
	// 6. lolu - Lippe Oben Links Unten
	// blolu = blolu * sc;
	// hlolu = hlolu * sc;
	// 7. loru - Lippen Oben Rechts Unten
	// bloru = bloru * sc;
	// hloru = hloru * sc;
	// 8. fml - Flansch Mittel Links
	// bfml = bfml * sc;
	// hfml = hfml * sc;
	// 9. fmr - Flansch Mittel Rechts
	
	
	// 10. lulo - Lippe Unten Links Oben
	
	
	// 11. luro - Lippe Unten Rechts Oben
	
	
	// 12. ful - Flansch Unten Links
	
	
	// 13. fur - Flansch Unten Rechts 
	
	
	// 14. lulu - Lippe Unten Links Unten
	// 15. luru - Lippe Unten Rechts Unten
			
	/////////Eigener Schwerpunkt/////////
	
		real [][] hbdata =  {
			{sc * hw, sc * bw},		//0
			{sc * hlolo, sc * blolo},	//1
			{sc * hloro, sc * bloro},	//2
			{sc * hfol, sc * bfol},	//3
			{sc * hfor, sc * bfor},	//4
			{sc * hlolu, sc * blolu},	//5
			{sc * hloru, sc * bloru},	//6
			{sc * hfml, sc * bfml},	//7
			{sc * hfmr, sc * bfmr},	//8
			{sc * hlulo, sc * blulo},	//9
			{sc * hluro, sc * bluro},	//10
			{sc * hful, sc * bful},	//11
			{sc * hfur, sc * bfur},	//12
			{sc * hlulu, sc * blulu},	//13
			{sc * hluru, sc * bluru}	//14
		}; 
	
		pair sw 	= 	sw;
		// pair sfol 	= 	(sw 	+ ( - 1/2 * bfol - 1/2 * bw , 		+ 1/2 * hw - 1/2 * hfol)); 
		// pair slolo 	= 	(sfol 	+ (	- 1/2 * bfol + 1/2 * blolo , 	+ 1/2 * hfol + 1/2 * hlolo));
		// pair slolu	=	(sfol 	+ (	- 1/2 * bfol + 1/2 * blolu , 	- 1/2 * hfol - 1/2 * hlolu));
		// pair sfor 	= 	(sw 	+ ( + 1/2 * bfor + 1/2 * bw , 		+ 1/2 * hw - 1/2 * hfol));
		// pair sloro	=	(sfor 	+ (	+ 1/2 * bfor - 1/2 * bloro , 	+ 1/2 * hfor + 1/2 * hloro));
		// pair sloru	=	(sfor 	+ (	+ 1/2 * bfor - 1/2 * bloru , 	- 1/2 * hfor - 1/2 * hloru));
		// pair sfml	=	(sw		+ (	- 1/2 * bfml - 1/2 * bw ,		0)); 
		// pair sfmr	=	(sw		+ (	+ 1/2 * bfmr + 1/2 * bw ,		0)); 
		// pair sful 	= 	(sw 	+ ( - 1/2 * bful - 1/2 * bw , 		- 1/2 * hw + 1/2 * hful)); 
		// pair slulo 	= 	(sful 	+ (	- 1/2 * bful + 1/2 * blulo , 	+ 1/2 * hful + 1/2 * hlulo));
		// pair slulu	=	(sful 	+ (	- 1/2 * bful + 1/2 * blulu , 	- 1/2 * hful - 1/2 * hlulu));
		// pair sfur 	= 	(sw 	+ ( + 1/2 * bfur + 1/2 * bw , 		- 1/2 * hw + 1/2 * hfur));
		// pair sluro	=	(sfur 	+ (	+ 1/2 * bfur - 1/2 * bluro , 	+ 1/2 * hfur + 1/2 * hluro));
		// pair sluru	=	(sfur 	+ (	+ 1/2 * bfur - 1/2 * bluru , 	- 1/2 * hfur - 1/2 * hluru));
			
		pair sfol 	= 	(sw 	+ ( - 1/2 * hbdata[3][1] - 1/2 * hbdata[0][1] , 		+ 1/2 * hbdata[0][0] - 1/2 * hbdata[3][0])); 
		pair slolo 	= 	(sfol 	+ (	- 1/2 * hbdata[3][1] + 1/2 * hbdata[1][1] , 	+ 1/2 * hbdata[3][0] + 1/2 * hbdata[1][0]));
		pair slolu	=	(sfol 	+ (	- 1/2 * hbdata[3][1] + 1/2 * hbdata[5][1] , 	- 1/2 * hbdata[3][0] - 1/2 * hbdata[5][0]));
		pair sfor 	= 	(sw 	+ ( + 1/2 * hbdata[4][1] + 1/2 * hbdata[0][1] , 		+ 1/2 * hbdata[0][0] - 1/2 * hbdata[3][0]));
		pair sloro	=	(sfor 	+ (	+ 1/2 * hbdata[4][1] - 1/2 * hbdata[2][1] , 	+ 1/2 * hbdata[4][0] + 1/2 * hbdata[2][0]));
		pair sloru	=	(sfor 	+ (	+ 1/2 * hbdata[3][1] - 1/2 * hbdata[6][1] , 	- 1/2 * hbdata[4][0] - 1/2 * hbdata[6][0]));
		pair sfml	=	(sw		+ (	- 1/2 * hbdata[7][1] - 1/2 * hbdata[0][1] ,		0)); 
		pair sfmr	=	(sw		+ (	+ 1/2 * hbdata[8][1] + 1/2 * hbdata[0][1] ,		0)); 
		pair sful 	= 	(sw 	+ ( - 1/2 * hbdata[11][1] - 1/2 * hbdata[0][1] , 		- 1/2 * hbdata[0][0] + 1/2 * hbdata[11][0])); 
		pair slulo 	= 	(sful 	+ (	- 1/2 * hbdata[11][1] + 1/2 * hbdata[9][1] , 	+ 1/2 * hbdata[11][0] + 1/2 * hbdata[9][0]));
		pair slulu	=	(sful 	+ (	- 1/2 * hbdata[11][1] + 1/2 * hbdata[13][1] , 	- 1/2 * hbdata[11][0] - 1/2 * hbdata[13][0]));
		pair sfur 	= 	(sw 	+ ( + 1/2 * hbdata[12][1] + 1/2 * hbdata[0][1] , 		- 1/2 * hbdata[0][0] + 1/2 * hbdata[12][0]));
		pair sluro	=	(sfur 	+ (	+ 1/2 * hbdata[12][1] - 1/2 * hbdata[10][1] , 	+ 1/2 * hbdata[12][0] + 1/2 * hbdata[10][0]));
		pair sluru	=	(sfur 	+ (	+ 1/2 * hbdata[12][1] - 1/2 * hbdata[14][1] , 	- 1/2 * hbdata[12][0] - 1/2 * hbdata[14][0]));	
			
	/////////Geo. Daten als Array/////////
			

			
		pair [] sdata = // Schwerpunkt
			{
				sw, slolo, sloro, sfol, sfor, slolu, sloru, sfml, sfmr, slulo, sluro, sful, sfur, slulu, sluru
			};
			
		pair [][] peckdata = new pair [sdata.length][4];
		for (int ii=0; ii<sdata.length; ++ii){		
				peckdata [ii][0] = sdata[ii] + ( - hbdata[ii][1] / 2 , + hbdata[ii][0] / 2);
				peckdata [ii][1] = sdata[ii] + ( + hbdata[ii][1] / 2 , + hbdata[ii][0] / 2);
				peckdata [ii][2] = sdata[ii] + ( - hbdata[ii][1] / 2 , - hbdata[ii][0] / 2);
				peckdata [ii][3] = sdata[ii] + ( + hbdata[ii][1] / 2 , - hbdata[ii][0] / 2);
			}
			
	/////////Eigene Querschnittswerte/////////
		real [] adata=new real[hbdata.length]; //Flächeninhalt
		real ages=0; 
		for (int i = 0; i < hbdata.length; ++i)
			{
				adata[i] = hbdata[i][0] * hbdata[i][1];
				ages = ages + adata [i];
			} 
			
		real[][] sidata=new real[hbdata.length][2]; //Statisches Moment
		real sxges=0;
		real syges=0; 
		for (int j = 0; j < hbdata.length; ++j)
			{
				sidata [j][0] = sdata[j].x * adata[j];
				sxges = sxges + sidata[j][0]; 
				sidata [j][1] = sdata[j].y * adata[j];
				syges = syges + sidata[j][1];
			}
			
		/////////Gesamter Schwerpunkt/////////
			
			pair sges = (sxges/ages, syges/ages);
			
		/////////Zeichnen Rechtecks/////////	
			for (int m=0; m < hbdata.length; ++m)
			{
				rechteck (sdata[m], hbdata[m][1], hbdata[m][0], "stahl", "M");
			}
		
		////////Koordinatenachsen		
			if (koordi == true){
				CSYS (sges, sc*100, -90, "$z$", "$y$", 70,70, W, W, 3);
				label ("$S$", sges, NE);
			}
		///////// Bemassung ////////
			// bemassung (peckdata[2-1][1-1], peckdata[2-1][2-1], bemdi, true, true, "L", Bars, Bars);
			// bemassung (peckdata[2-1][2-1], peckdata[1-1][1-1], bemdi + hbdata[2-1][1-1], true, true, "O", (1,20), Bars, Bars);
			// bemassung (peckdata[1-1][1-1], peckdata[1-1][2-1], bemdi + hbdata[2-1][1-1], true, true, "O", (1,5), Bars, Bars);
			// bemassung (peckdata[1-1][2-1], peckdata[3-1][1-1], bemdi + hbdata[2-1][1-1], true, true, "O", (1,5), Bars, Bars); 
		///////// Belastungszustand 
			if (last == true){
				if (moment == "My") {
					draw (  (sges+(5/6*max(bfor,bfur),0))--(sges+((1/6*max(bfor,bfur)),0)), Arrow(size=4) );
					draw (  (sges+(5/6*max(bfor,bfur),0))--(sges+((1.75/6*max(bfor,bfur)),0)), Arrow(size=4) );
					label ("$M_{y}$", (sges+((2/6*max(bfor,bfur)),0)), SE);
				}
				else if (moment == "Mz") {
					draw (  (sges+(0, 8/6*max(bfor,bfur)))--(sges+(0, (4/6*max(bfor,bfur)))), Arrow(size=4) );
					draw (  (sges+(0, 8/6*max(bfor,bfur)))--(sges+(0, (4.75/6*max(bfor,bfur)))), Arrow(size=4) );
					label ("$M_{z}$", (sges+(0, (4/6*max(bfor,bfur)))), NW);
				}	
				else {};
				
				if (sforce == "Vz") {
					draw (  (sges+(0, 8/6*max(bfor,bfur)))--(sges+(0, (5/6*max(bfor,bfur)))), Arrow(size=4) );
					label ("$V_{z}$", (sges+(0, (4/6*max(bfor,bfur)))), NW);
				}
				else if (sforce == "Vy") {
					draw (  (sges+(5/6*max(bfor,bfur),0))--(sges+((1/6*max(bfor,bfur)),0)), Arrow(size=4) );
					label ("$V_{y}$", (sges+((2/6*max(bfor,bfur)),0)), SE);
				}
				else {};
			}
	
			
			}
			
			
///////// einachsig symmetrisch geschweißter I-Querschnitt //////////
////////////// added: 21.07.2017 //////////////
////////////// updated: 		 //////////////

void EinachsIProfil (real hw = 360, real tw =10, real bfo = 250, real tfo = 10, real bfu = 150, real tfu = 20, real aw = 6, real bdi =50, bool koordi = true, bool bemass = true, bool last = false, string moment = "My", string sforce = "Vz"){

	// Parameter
		//hw = Höhe Steg
		//tw = Dicke Steg
		//bfo = Breite Flansch Oben
		//bfu = Breite Flansch Unten
		//tfo = Dicke Flansch Oben
		//tfu = Dicke Flansch Unten
		//aw = Schweißnahtdicke
		//bdi =  Bemassungsabstand
		
	pair sw = (0,0);	//Schwerpunkt Steg		
	pair sfo = (sw + (0, hw/2+tfo/2)); //Schwerpunkt Flansch Oben
	pair sfu = (sw - (0, hw/2+tfu/2)); //Schwerpunkt Flansch Unten
	
	real ages = hw * tw + bfo*tfo + bfu * tfu;
	real syges = hw * tw * sw.y + bfo * tfo * sfo.y + bfu * tfu * sfu.y;
	
	rechteck (sw, tw, hw, "stahl", "M");
	rechteck (sfo,bfo, tfo, "stahl", "M");
	rechteck (sfu,bfu,tfu, "stahl", "M");
	naht ((sfo-(0,tfo/2)), aw, "Doppelkehl", tw, -90);
	naht ((sfu + (0, tfu/2)), aw , "Doppelkehl", tw , 90);	
	
	pair sges = (0, syges/ages);
	if (koordi == true){
	
	CSYS (sges, 100, -90, "$z$", "$y$", 70,70, W, N, 6);
	label ("$S$", sges, E);
	}
	
	if (bemass == true){
	bemassung ((sw - (tw/2,0)),(sw + (tw/2,0)), Bars, Arrows);
	bemassung ((sfo + (-bfo/2,tfo/2)), (sfo + (bfo/2 , tfo/2)), bdi/2, Bars, Arrows);
	bemassung ((sfu + (-bfu/2,-tfu/2)), (sfu + (bfu/2 , -tfu/2)), -bdi , Bars, Arrows);
	real [] vb = {tfu, hw, tfo};
	vbemassung ( vb, (sfu - (0, tfu/2) ), - 0.5 * max(bfo,bfu) - bdi);
	}
	
	///////// Belastungszustand 
	if (last == true){
		if (moment == "My") {
			draw (  (sges+(5/6*max(bfo/2,bfu/2),0))--(sges+((1.4/6*max(bfo/2,bfu/2)),0)), Arrow(size=5) );
			draw (  (sges+(5/6*max(bfo/2,bfu/2),0))--(sges+((1.75/6*max(bfo/2,bfu/2)),0)), Arrow(size=5) );
			label ("$M_{y}$", (sges+((2/6*max(bfo/2,bfu/2)),0)), SE);
		}
		else if (moment == "Mz") {
			draw (  (sges+(0, 8/6*max(bfo/2,bfu/2)))--(sges+(0, (4.5/6*max(bfo/2,bfu/2)))), Arrow(size=5) );
			draw (  (sges+(0, 8/6*max(bfo/2,bfu/2)))--(sges+(0, (4.75/6*max(bfo/2,bfu/2)))), Arrow(size=5) );
			label ("$M_{z}$", (sges+(0, (4/6*max(bfo/2,bfu/2)))), NW);
		}	
		else {};
		
		if (sforce == "Vz") {
			draw (  (sges+(0, 8/6*max(bfo/2,bfu/2)))--(sges+(0, (5/6*max(bfo/2,bfu/2)))), Arrow(size=5) );
			label ("$V_{z}$", (sges+(0, (4/6*max(bfo/2,bfu/2)))), NW);
		}
		else if (sforce == "Vy") {
			draw (  (sges+(5/6*max(bfo/2,bfu/2),0))--(sges+((1/6*max(bfo/2,bfu/2)),0)), Arrow(size=5) );
			label ("$V_{y}$", (sges+((2/6*max(bfo/2,bfu/2)),0)), SE);
		}
		else {};
	}
}

//// draw some silos for Ding ////
void silo (pair p0, real b, real h, int lvtot, int lvcur) 
{
	rechteck (p0, b, h);	
	fill ( (p0+(-b/2, -h/2))--(p0+(b/2, -h/2))--(p0+(b/2, -h/2+h/lvtot*lvcur))--(p0+(-b/2, -h/2+h/lvtot*lvcur))--cycle, opacity(0.5)+grey);
	fill ( (p0+(-b/2, -h/2))--(p0+(b/2, -h/2))--(p0+(b/2, -h/2+h/lvtot*lvcur))--(p0+(-b/2, -h/2+h/lvtot*lvcur))--cycle, pattern("estrich"));
	for (int i =0; i <= lvtot; ++i)
		{
			draw ( (p0 + (- b/2, -  h/2 + h/lvtot * i)) -- (p0 + (b/2, - h/2 + h/lvtot *i)) ,dashed);
		}; 
}

//// draw a symmetrical axis ////
void symmaxis (pair p1, pair p2, real sc =1){
	
		real ag = 30 * 3.14 /180; 
		draw (p1--p2, dashdotted);
		
		path s11 = (p1 + sc* ( 1 * sin(ag), - 1 *cos(ag)) )--(p1 + sc* ( - 1 * sin(ag), 1 *cos(ag)));
		path s12 = (p1 + sc* (-1 * sin(ag), - 1 *cos(ag)) )--(p1 + sc* (   1 * sin(ag), 1 *cos(ag)));
		path s101 =  (p1 + sc* ( 1 * sin(ag), - 1 *cos(ag)) ){right}..{left}p1;
		path s102 =  (p1 + sc* (-1 * sin(ag), - 1 *cos(ag)) ){left}..{right}p1;
		draw (s11^^s12^^s101^^s102,defaultpen);
		
		path s21 = (p2 + sc* ( 1 * sin(ag), - 1 *cos(ag)) )--(p2 + sc* ( - 1 * sin(ag), 1 *cos(ag)));
		path s22 = (p2 + sc* (-1 * sin(ag), - 1 *cos(ag)) )--(p2 + sc* (   1 * sin(ag), 1 *cos(ag)));
		path s201 =  (p2 + sc* (-1 * sin(ag),  1 *cos(ag)) ){left}..{right}p2;
		path s202 =  (p2 + sc* (1 * sin(ag),   1 *cos(ag)) ){right}..{left}p2;
		draw (s21^^s22^^s201^^s202,defaultpen);

}


 
/// draw a schnittlinie

void schnittlinie (pair p0, real l =200, real f = 20, real w = 0, string a = " ", align n1 = W, align n2 =E){
    pair pschnitt1 = p0 + (-l/2,-f);  
    pair pschnitt2 = p0 + (-l/2, 0);
    pair pschnitt3 = p0 + ( l/2, 0);
	pair pschnitt4 = p0 + ( l/2,-f);
    draw ( rotate(w,p0) *(pschnitt2--pschnitt3), dashdotted+1);
	draw ( rotate(w,p0) *(pschnitt2--pschnitt1), defaultpen+1, EndArrow(arrowhead=SimpleHead, size=5, filltype=NoFill));	
	draw ( rotate(w,p0) *(pschnitt3--pschnitt4), defaultpen+1, EndArrow(arrowhead=SimpleHead, size=5, filltype=NoFill));	
    label (a,pschnitt1, n1);
    label (a,pschnitt4, n2);
}

/// draw a cross

void kreuz (pair p0, real l=50, real w=0){
	
	draw ( rotate(w,p0)*(p0+ (l/2,0))--(p0+ (-l/2,0))^^rotate(w,p0)*(p0+ (0, l/2))--(p0+ (0, -l/2)));
	
}

/// draw Strahlung

void strahlung (pair p0, real r, int n){
	
	kreis (p0, r, "white", "M", white);
	pair p1 = p0 + (r,0);
	for (int i = 0; i < n; ++i)
		{
			draw ( p0--(p0+(r*cos(i*2*pi/n),r*sin(i*2*pi/n))) );
		};
	
}

/// do a round Bemassung 

void bogenbemassung (pair a, pair b, pair p0, real x= 20, string n = "annotate me!", align align1 = N, arrowbar bar=Bars(size=8), arrowbar bar2=Arrows(size=6)){
	pair a0 = (a.x-p0.x, a.y-p0.y);
	pair b0 = (b.x-p0.x, b.y-p0.y);
	real awinkel = angle (a0);
	real bwinkel = angle (b0);
	
	pair a1 = p0 + ( ( length(a0) + x ) * cos (awinkel) , ( length(a0) + x ) * sin (awinkel) );
	pair b1 = p0 + ( ( length(b0) + x ) * cos (bwinkel) , ( length(b0) + x ) * sin (bwinkel) );
	path a1b1 = arc (p0, a1, b1); 
	draw (a1b1, bar, bar2);
	
	pair beschr = p0 + ( ( length(a0) + x ) * cos (awinkel/2+bwinkel/2) , ( length(a0) + x ) * sin (awinkel/2+bwinkel/2)); 
	label (n, beschr, align1);
	//draw (arc (p0, length(a0)+x, awinkel, bwinkel));
	
}
