// Asymptote-Modul zum Zeichnen Graphen
// --------------------------------------------------
// Hendrik Jahns 28.01.2015
// --------------------------------------------------

// -------------------------------------------------
// Achsen

void xachse(real l=10, real dl=1, real m=1, string beschriftung="", pen pen1=defaultpen){
         pair b=((l+dl/2)*m,0);
         real n=l/dl;
         for(real i=0; i<n; ++i){
             pair c=(i*dl*m,0);
             pair d=(i*dl*m+dl*m,0);
             draw(c--d,pen1,Bars(size=8));
             string s1=string(i*dl);
             label(s1,c+(0,-0.01*l*m),S);
         }
         string s1=string(l);
         pair c=(l*m,0);
         label(s1,c+(0,-0.01*l*m),S);
         draw(c--b,pen1,EndArrow(size=6));
         label(beschriftung,b,SE);
     }

void yachse(real l=10, real dl=1, real m=1, string beschriftung="", pen pen1=defaultpen){
         pair b=(0,(l+dl/2)*m);
         real n=l/dl;
         for(real i=0; i<n; ++i){
             pair c=(0,i*dl*m);
             pair d=(0,i*dl*m+dl*m);
             draw(c--d,pen1,Bars(size=8));
             string s1=string(i*dl);
             label(s1,c+(-0.01*l*m,0),W);
         }
         string s1=string(l);
         pair c=(0,l*m);
         label(s1,c+(-0.01*l*m,0),W);
         draw(c--b,pen1,EndArrow(size=6));
         label(beschriftung,b,NW);
     }