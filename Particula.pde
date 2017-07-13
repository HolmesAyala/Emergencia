class Particula{
  PVector pos = new PVector(0,0);
  PVector vel = new PVector(0,0);
  PVector acc = new PVector(0,0);
  float radio = 20;
  int id;
  int zona = 0;
  float masa = 1;
  color colorParticula = color(255);
  // Constructor
  Particula(float x_, float y_, int i){
    pos = new PVector(x_, y_);
    id = i;
    //println(pos.x+":"+pos.y+"  "+this.zona);
  }
  
//_____________________________________________________________________________________________________________  
  // metodos
//_____________________________________________________________________________________________________________  
  void dibujar(){
    if( visibleX() && visibleY()){
      stroke(15);
      //noFill();
      fill(colorParticula, 100);
      //fill(colorParticula);
      pushMatrix();
        translate(pos.x, pos.y);
        rotate(vel.heading());
        ellipse(0, 0, radio*2, radio*2);
        //ellipse(0, 0, (radio+50)*2, (radio+50)*2);
        line(0,0,radio,0);
        textAlign(CENTER);
        stroke(0); 
        fill(0);
        //text(str(id)+":: "+str(this.zona),0, -5);
      popMatrix();
    }
  }
//_____________________________________________________________________________________________________________
  void mover(){
    vel.add(acc);
    acc.mult(0);
    pos.add(vel);
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
  boolean colision(Particula p){
    if(distancia(p) < (radio + p.radio)) return true;
    return false;
  }
  // detectar la colision con un punto del espacio
  boolean colision(PVector p){
    if(distancia(p) < (radio)) return true;
    return false;
  }
//_____________________________________________________________________________________________________________
  // Calcular la distancia a otra particula
  float distancia(Particula p){
    return dist(pos.x, pos.y, p.pos.x, p.pos.y);
  }
  // CAlcular la distancia a un punto del espacio.
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
//_____________________________________________________________________________________________________________  

  void setMasa(float m){
    masa = m;
  }
  
  void setRadio(float r){
    radio = r;
  }
}