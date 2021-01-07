//VOZ=======VOZ=========VOZ=========VOZ===========VOZ========VOZ======
import oscP5.*; // importar la libreria

//=======================================
//variables de calibración
float umbralAmp = 60;
boolean haySonido;

float minimoAmpExtremo = 86;
float maximoAmpExtremo = 100;

float minimoAmpFuerte = 80;
float maximoAmpFuerte = 85;

float minimoAmpBajo = 68;
float maximoAmpBajo = 79;

float minimoPitchGrave = 50;
float maximoPitchGrave = 58;

float minimoPitchAgudo = 63;
float maximoPitchAgudo = 75;

float factorAmortiguacion = 0.9;

boolean sonidoGrave=false;
boolean sonidoAgudo= false;
boolean sonidoExtremo= false;
boolean sonidoFuerte=false;
boolean sonidoBajo= false;

boolean monitor = false;
//=======================================
OscP5 osc; // declaracion del objeto osc

float amp = 0.0;
float pitch = 0.0;

GestorSenial gestorAmp;
GestorSenial gestorPitch;
//VOZ=======VOZ=========VOZ=========VOZ===========VOZ========VOZ======

PImage camisa;

ArrayList <Trazo> listaTrazo;

int cantidad = 1;
Paleta paleta;


void setup() {
  size (800, 600, P2D);
  background (255);

  //VOZ=======VOZ=========VOZ=========VOZ===========VOZ========VOZ======
  //inicializar el objeto osc 
  osc = new OscP5(this, 12345); // parametros: puntero a processing y puerto

  //inicialización
  //por defecto el rango es 0-100
  gestorAmp = new GestorSenial( minimoAmpBajo, maximoAmpExtremo, factorAmortiguacion );
  gestorPitch = new GestorSenial( minimoPitchAgudo, maximoPitchGrave, factorAmortiguacion );
  //VOZ=======VOZ=========VOZ=========VOZ===========VOZ========VOZ======

  paleta = new Paleta("obrasOp.png");
  listaTrazo=new ArrayList<Trazo> ();
  
  camisa=loadImage ("circulo1.png");
  imageMode ( CENTER );

  for (int i=0; i<cantidad; i++) { 
    Trazo esteTrazo =new Trazo();
    listaTrazo.add (esteTrazo);
    esteTrazo.asignarColor( paleta.darUnColor() );
  }
}



void draw() {
  background(255);

  //VOZ=======VOZ=========VOZ=========VOZ===========VOZ========VOZ======
  gestorAmp.actualizar(amp);
  gestorPitch.actualizar(pitch);
  haySonido = amp > umbralAmp;

  sonidoExtremo= amp > minimoAmpExtremo && amp < maximoAmpExtremo;
  sonidoFuerte= amp > minimoAmpFuerte && amp < maximoAmpFuerte;
  sonidoBajo= amp > minimoAmpBajo && amp < maximoAmpBajo;
  sonidoGrave= pitch > minimoPitchGrave && pitch < maximoPitchGrave;
  sonidoAgudo= pitch > minimoPitchAgudo && pitch < maximoPitchAgudo;
  //VOZ=======VOZ=========VOZ=========VOZ===========VOZ========VOZ======

  for (int i=listaTrazo.size()-1; i>=0; i--) {
    Trazo esteTrazo =listaTrazo.get(i);

    if (haySonido) {
      if (sonidoFuerte) {     
        esteTrazo.vida();
        //println("fuerte");
      } else if (sonidoBajo) {
        esteTrazo.mover();
        //println("bajo");
      }

      if (sonidoGrave) {
        esteTrazo.rotarPos();
        //println("grave");
      } else if (sonidoAgudo) {
        esteTrazo.rotarNeg();
        //println("agudo");
      }

      if (listaTrazo.size()<6) {  
        if (sonidoExtremo) {
          Trazo nuevoTrazo=new Trazo();
          listaTrazo.add(nuevoTrazo);
          //println(".......");
        }
      }
    }

    esteTrazo.dibujar();
    if (esteTrazo.finished()) {
      listaTrazo.remove(i);
    }
  }
  
    //Para que reinicie 
    if (listaTrazo.size()==0) {
      setup();
    }

  image(camisa,width/2, height/2);
  println(listaTrazo.size());

  //VOZ=======VOZ=========VOZ=========VOZ===========VOZ========VOZ======
  gestorAmp.actualizar( amp );  //en cada fotograma hay que actualizar
  gestorPitch.actualizar( pitch );

  if (monitor) {
    gestorAmp.imprimir( 150, 150 );
    gestorPitch.imprimir( 150, 350 );
  }
  //VOZ=======VOZ=========VOZ=========VOZ===========VOZ========VOZ======
}

//VOZ=======VOZ=========VOZ=========VOZ===========VOZ========VOZ======
void oscEvent( OscMessage m) {

  if (m.addrPattern().equals("/amp")) {    
    amp = m.get(0).floatValue();
    //println("amp: " + amp);
  }

  if (m.addrPattern().equals("/pitch")) {    
    pitch = m.get(0).floatValue();
    //println("pitch: " + pitch);
  }
}
//VOZ=======VOZ=========VOZ=========VOZ===========VOZ========VOZ======
