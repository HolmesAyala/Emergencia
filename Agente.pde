class Agente extends Particula {
  float radioVision = radio + 50;
  boolean libre = true;
  
  Agente(float x_, float y_, int i) {
    super(x_, y_, i);
    
  }
  // Metodos del agente
  boolean obstaculo(Agente otro){
    if(detectable(otro)){
      PVector dir = vel.copy();            // la copia de la velocidad contiene la direccion del agente
      dir.normalize();
      //ellipse(dir.x*radioVision+pos.x, dir.y*radioVision+pos.y, 5, 5);
      float d = distancia(otro);           // 
      dir.mult(d);                         // calcular el punto que hace contacto con el obstaculo
      dir.add(pos);                        // trasladar el vector de vision a la posicion del agente
      if(otro.colision(dir)){
        stroke(255,0,0);
        line(pos.x, pos.y, otro.pos.x, otro.pos.y);
        return true;
      }
    }
    return false;
  }
  
  boolean detectable(Agente otro){
    return (distancia(otro) < radioVision + otro.radio);
  }
  
  void setRadioVision(float r){
    radioVision = radio + r;
  }
}