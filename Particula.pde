class Particula{
  PVector pos = new PVector(0,0);
  PVector vel = new PVector(0,0);
  PVector acc = new PVector(0,0);
  float velMax;
  int radio = 13;
  float radioVision = radio + 70;
  float masa = 1;
  
  // para ver vision
  boolean vision = false;
  PVector line1 = new PVector(cos(PI/4), sin(PI/4));
  PVector line2 = new PVector(cos(-PI/4), sin(-PI/4));
  
  // Constructor
  Particula(float x_, float y_){
    pos = new PVector(x_, y_);
  }
  
//_____________________________________________________________________________________________________________  
  // metodos
//_____________________________________________________________________________________________________________  
  void dibujar(){
    if( visibleX() && visibleY()){
      stroke(15);
      noFill();
      pushMatrix();
        translate(pos.x, pos.y);
        rotate(vel.heading());
        //ellipseMode(RADIUS);
        ellipse(0, 0, radio, radio);
        if(vision){
          line(0, 0, line1.x*(this.radioVision), line1.y*(this.radioVision));
          line(0,0, line2.x*(this.radioVision), line2.y*(this.radioVision));
          arc(0, 0, this.radioVision, this.radioVision, -PI/4,PI/4);
        }
        //line(0,0,radio,0);
        //line(0,0,-cos(PI/4)*(radio+50),0);
        //textAlign(CENTER);
        //stroke(0); 
        //fill(0);
        //text(str(id)+":: "+str(this.zona),0, -5);
      popMatrix();
    }
  }
//_____________________________________________________________________________________________________________
  void mover(){
    vel.add(acc);
    vel.limit(this.velMax);
    pos.add(vel);
    acc.mult(0);
  }
  
  void aplicarFuerza(PVector f){
    PVector fuerza = f.copy();
    fuerza.div(masa);
    acc.add(fuerza);
  }
  
  void impulsar(float impulso){
    // aplicar impulso frontal
    PVector dir = vel.copy();
    dir.normalize();
    dir.mult(impulso);
    aplicarFuerza(dir);
  }
  
  void rotar(float a){
    vel.rotate(a);
  }
//_____________________________________________________________________________________________________________
  // detectar la colision con otra particula
  boolean colision(int r, PVector p){
    if(distancia(p) < (radio + r)) return true;
    return false;
  }
  // detectar la colision con un punto del espacio
  boolean colision(PVector p){
    if(distancia(p) < (radio)) return true;
    return false;
  }
//_____________________________________________________________________________________________________________
  // Calcular la distancia a un punto del espacio.
  float distancia(PVector p){
    return dist(pos.x, pos.y, p.x, p.y);
  }
//_____________________________________________________________________________________________________________  
  void posicionar(){
    posicionar(new PVector(random(width), random(height)));
  }
  void posicionar(PVector p){
    pos = p.copy();
  }
//_____________________________________________________________________________________________________________  
  boolean visibleX(){
    return ((pos.x + radio) >= 0) && ((pos.x - radio) <= width);
  }
  boolean visibleY(){
    return ((pos.y + radio) >= 0) && ((pos.y - radio) <= height);
  }
  
  void bordes(){
    if(pos.x <= -radio){
      pos.x = width;
    }
    else if(pos.x >= width + radio){
      pos.x = 0;
    }
    if(pos.y < -radio){
      pos.y = height;
    }
    else if(pos.y > height + radio){
      pos.y = 0;
    }
  }
  
}