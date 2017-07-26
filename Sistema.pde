import java.util.*;

class Sistema{
  
  ArrayList<Agente> agentes;
  ArrayList<Obstaculo> carretera;
  
  PImage fondo;
  boolean ejecutar = false;
  
  int filas;
  int columnas;
  
  int nAgentes;
  
  Obstaculo p;
  
  Sistema(int num, int fil, int col){  //Constructor
    this.nAgentes = num;
    this.filas = fil;
    this.columnas = col;
    
    agentes = new ArrayList<Agente>();
    carretera = new ArrayList<Obstaculo>();
    
    if(ejecutar){
      agregarAgente(this.nAgentes);
    }
    else{
      fondo = loadImage("Carretera1.png");
      fondo.resize(width, height);
      background(fondo);
    }
    
    p = new Obstaculo(new PVector(0, 0), 20);
    carretera.add(p);
  }
  
  void ejecutar(){
    if(ejecutar){
      background(255);
      p.pos = new PVector(mouseX, mouseY);
      println("Agentes: "+agentes.size());
      
      Iterator<Agente> iter = agentes.iterator();
      while(iter.hasNext()){
        Agente m = iter.next();
        if(m.visibleX() && m.visibleY()){
          m.impulsar(m.velMax*0.01);
          m.albedrio(visibles(m), carreteraVisible(m));
          m.mover();
          m.dibujar();
          //m.bordes();
        }
        else{
          iter.remove();
        }
      }
      
      for(Obstaculo m: carretera){
        m.dibujar();
      }
      
      lineas();
    }
    else{
      modelarCarretera();
    }
  }
  
  ArrayList visibles(Agente agente){
    ArrayList visibles = new ArrayList<Agente>();
    for(Agente m: agentes){
      if(m != agente){
        //Si esta muy cerca
        if(agente.cercano(m.pos, m.radio)){
          //Si esta en el radio de vision
          PVector dirOtro = PVector.sub(m.pos, agente.pos);
          dirOtro.normalize();
          float angulo = PVector.angleBetween(agente.vel, dirOtro);
          if(angulo <= PI/4){
            visibles.add(m);
          }
        }
      }
    }
    return visibles;
  }
  
  ArrayList carreteraVisible(Agente agente){
    ArrayList visibles = new ArrayList<Obstaculo>();
    for(Obstaculo m: carretera){
      if(agente.cercano(m.pos, m.radio)){
        PVector dirOtro = PVector.sub(m.pos, agente.pos);
        //dirOtro.normalize();
        float angulo = PVector.angleBetween(agente.vel, dirOtro);
        if(angulo <= PI/4){
          visibles.add(m);
        }
      }
    }
    return visibles;
  }
  
  //  Distribucion de los Agentes
  void agregarAgente(int cantidad) {
    for (int i = 0; i < cantidad; i++) {
      Agente auxiliar = new Agente(random(width), random(height));
      boolean validar = false;
      while (!validar) {
        validar = true;
        
        for(Obstaculo m: carretera){
          if (m.colision(auxiliar.radio, auxiliar.pos)) {
            validar = false;
            auxiliar.posicionar();
          }
        }
        
        for (Agente m : agentes) {
          if (m.colision(auxiliar.radio, auxiliar.pos)) {
            validar = false;
            auxiliar.posicionar();
          }
        }
      }
      auxiliar.vel = new PVector(random(1), random(1));
      //auxiliar.velMax = random(1, 3);
      auxiliar.velMax = 2;
      agentes.add(auxiliar);
    }
  }
  
  void removerAgente(){
    
  }
  
  int radio = 250;
  void modelarCarretera(){  //Modela la carretera con agentes
    PVector candidato = candidato();
    if(candidato != null){
      carretera.add(new Obstaculo(candidato, this.radio));
      stroke(0, 255, 0);
      fill(#5EA8F5);
      ellipseMode(RADIUS);
      ellipse(candidato.x, candidato.y, radio, radio);
    }
    else if(this.radio > 10){
      this.radio -= 2;
    }
    else{
      this.ejecutar = true;
      agregarAgente(this.nAgentes);
    }
  }
  
  PVector candidato(){  //Busca las coordenadas X, Y adecuadas para el radio actual
    println("Calculando Candidato, Radio: "+this.radio);
    for(int y = 0; y < height; y++){
      int norte = y-radio;
      int sur = y+radio;
      for(int x = 0; x < width; x++){
        //  Si el pixel es negro
        if(get(x, y) == color(0)){
          int este = x+radio;
          int oeste = x-radio;
          //  Si esta en rango de pantalla
          if(este<=width && oeste>=0 && sur<=height && norte>=0){
            boolean blanco = false;
            PVector direccion = new PVector(1, 0);
            direccion.mult(this.radio);
            float angulo = 0;
            //  Si encuentra otro color alrededor del circulo
            while(angulo <= PI){
              if(get(x+int(direccion.x), y+int(direccion.y)) != color(0)){
                blanco = true;
                break;
              }
              angulo += PI/180;
              direccion.rotate(angulo);
            }
            if(!blanco){
              return new PVector(x, y);
            }
          }
        }
      }
    }
    return null;
  }
  
  void addObstaculo(){
    carretera.add(new Obstaculo(new PVector(mouseX, mouseY), 20));
  }
  
  void addAgente(){
    Agente agente = new Agente(mouseX, mouseY);
    agente.vel = new PVector(random(1), random(1));
    agente.velMax = 2;
    agentes.add(agente);
  }
  
  void verVision(){
    for(Agente m: agentes){
      if(m.colision(new PVector(mouseX, mouseY))){
        m.vision = true;
        break;
      }
    }
  }
  
  // Lineas que muestran las zonas
  void lineas() {
    stroke(0);
    for (int i = 0; i < this.columnas; i++) {
      float aux = width/this.columnas;
      line(i*aux, 0, i*aux, height);
    }
    for (int i = 0; i < this.filas; i++) {
      float aux = height/this.filas;
      line(0, i*aux, width, i*aux);
    }
  }
}