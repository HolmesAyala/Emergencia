class Agente extends Particula {
  
  PVector cuadricula;
  float maxF = 0.1;
  
  Agente(float x_, float y_) {
    super(x_, y_);
  }
  
  // Metodos del agente
  boolean cercano(PVector p, int r){
    return (distancia(p) < radioVision + r);
  }
  
  void albedrio(ArrayList<Agente> agentes, ArrayList<Obstaculo> m){
    PVector separacion = separar(agentes);
    PVector alineacion = alineacion(agentes);
    //PVector cohesion = cohesion(agentes);
    PVector carretera = separarCamino(m);
    //PVector objetivo = buscar(new PVector(mouseX, mouseY));
    
    separacion.mult(1.5);
    alineacion.mult(1);
    //cohesion.mult(1);
    carretera.mult(1);
    //objetivo.mult(1);
    
    //aplicarFuerza(objetivo);
    aplicarFuerza(separacion);
    aplicarFuerza(alineacion);
    //aplicarFuerza(cohesion);
    aplicarFuerza(carretera);
  }
  
  PVector alineacion(ArrayList<Agente> agentes){
    PVector velocidades = new PVector(0, 0);
    int cont = 0;
    for(Agente m: agentes){
      velocidades.add(m.vel);
      cont++;
    }
    if(cont > 0){
      velocidades.div(cont);
      velocidades.normalize();
      velocidades.mult(this.velMax);
      velocidades.sub(this.vel);
      velocidades.limit(this.maxF);
    }
    return velocidades;
  }
  
  PVector separar(ArrayList<Agente> agentes){
    PVector suma = new PVector(0, 0);
    int contador = 0;
    for(Agente m: agentes){
      float dist = distancia(m.pos);
      PVector contra = PVector.sub(this.pos ,m.pos);
      contra.normalize();
      contra.div(dist);
      suma.add(contra);
      contador++;
    }
    if(contador > 0){
      suma.div(contador);
      suma.normalize();
      suma.mult(this.velMax);
      suma.sub(this.vel);
      suma.limit(this.maxF);
    }
    return suma;
  }
  
  PVector cohesion(ArrayList<Agente> agentes){
    PVector suma = new PVector(0, 0);
    int contador = 0;
    for(Agente m: agentes){
      suma.add(m.pos);
      contador++;
    }
    if(contador > 0){
      suma.div(contador);
      return buscar(suma);
    }
    return suma;
  }
  
  PVector separarCamino(ArrayList<Obstaculo> carretera){
    PVector suma = new PVector(0, 0);
    int contador = 0;
    for(Obstaculo m: carretera){
      PVector contra = PVector.sub(this.pos ,m.pos);
      contra.normalize();
      float dist = PVector.dist(this.pos, m.pos);
      contra.div(dist);
      suma.add(contra);
      contador++;
    }
    if(contador > 0){
      suma.div(contador);
      suma.normalize();
      suma.mult(this.velMax);
      suma.sub(this.vel);
      suma.limit(this.maxF);
    }
    return suma;
  }
  
  PVector buscar(PVector objetivo){
    PVector deseo = PVector.sub(objetivo, pos);
    deseo.normalize();
    deseo.mult(velMax);
    deseo.sub(this.vel);
    deseo.limit(this.maxF);
    return deseo;
  }
}