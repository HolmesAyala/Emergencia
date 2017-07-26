class Obstaculo{

  PVector pos;
  int radio;
  
  Obstaculo(PVector p, int r){
    this.pos = p.copy();
    this.radio = r;
  }
  
  void dibujar(){
    stroke(0);
    //fill(#5EA8F5);
    noFill();
    ellipse(this.pos.x, this.pos.y, radio, radio);
  }
  
  boolean colision(int r, PVector p){
    if(distancia(p) < this.radio + r){
      return true;
    }
    return false;
  }
  
  float distancia(PVector p){
    return PVector.dist(this.pos, p);
  }
}