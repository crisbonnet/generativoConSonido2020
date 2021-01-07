
class Trazo {
  PImage imagenTrazo;
  float x, y;
  float vida=250;
  color relleno;
  float vel, dir;
  float angulo;

  Trazo() {
    imagenTrazo=loadImage("trazos00.png");
    imagenTrazo.filter(INVERT);
    relleno = color( random(255), random(255), random(255));
    x = random (width/2-150, width/2+150);
    y = random (height/2-150, height/2+150);

    vel=3;
    dir=radians (random(360));

    angulo = random(360);
  }


  void asignarColor( color nuevoColor ) {
    relleno = nuevoColor;
  }

  void dibujar() {
    pushStyle();
    pushMatrix();
    imageMode ( CENTER );
    translate(x, y);
    rotate(angulo);
    tint (relleno, vida);
    blendMode (BLEND);
    image (imagenTrazo, 0, 0);   
    popMatrix();
    popStyle();
  }

  boolean finished() {
    vida=vida-0.5;
    //println(vida);
    if (vida<=0) {
      return true;
    } else {
      return false;
    }
  }

  void mover() {   
    if (x<=width/2-200 || x>=width/2+200) { 
      dir+=radians(180);
    } else if ( y <=height/2-200 || y>=height/2+200) {
      dir+=radians(180);
    }

    x=x+vel*cos(dir);
    y= y+vel*sin(dir);
  }

  void rotarPos() {
    angulo+=0.01;
  }

  void rotarNeg() {
    angulo-=0.01;
  }

  void vida() {
    vida=vida-2;
  }
}
