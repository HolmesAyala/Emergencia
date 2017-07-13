import java.util.Map;

int radio;

int filas = 9;
int columnas = 9;

int contAgentes = 1;
int numAgentes = 100;

PImage fondo;
ArrayList <Agente> agentes;
Agente m = new Agente(0, 0, 0);

boolean comenzar = false;

//  Configuracion de pantalla
void settings() {
  size(columnas*100, filas*100);
  radio = height/4;
}

//  Configuracion general
void setup() {
  textSize(15);
  fondo = loadImage("Carretera4.png");
  fondo.resize(width, height);
  background(fondo);
  agentes = new ArrayList<Agente>();
  agentes.add(m);
  //agregarAgente(this.numAgentes);
}

//  Dibujar
void draw() {
  if(comenzar){
    logica();
  }
  else{
    modelarCarretera();
  }
}

//  Metodo principal de los agentes
void logica() {
  background(255);
  m.posicionar(new PVector(mouseX, mouseY));
  //println("Agentes: "+agentes.size());

  for (Agente p : agentes) {
    if(p.libre){
      p.zona = calcularZona(p.pos.x, p.pos.y);
      //drawZona(p.zona);
      if (colision(p)) {
        p.rotar(PI/180);
        //p.impulsar(-0.1);
      } else {
        //p.impulsar(0.1);
      }
      p.mover();
    }
    p.dibujar();
  }
  lineas();
  renovarAgentes();
}

boolean colision(Agente a) {
  boolean validar = false;
  for (Agente i : agentes) {
    if (i!=a) {
      if (a.obstaculo(i)) {
        validar = true;
        break;
      }
    }
  }
  return validar;
}

void modelarCarretera() {
  PVector candidato = calcularCandidato();
  if(candidato.x != -1){
    Agente agente = new Agente(candidato.x, candidato.y, this.contAgentes++);
    agente.radio = this.radio;
    agente.colorParticula = color(#305AFA);
    agente.libre = false;
    agentes.add(agente);
    stroke(0, 0, 255);
    fill(255, 0, 0);
    ellipse(candidato.x, candidato.y, radio*2, radio*2);
  }
  else if(radio > 15){
    this.radio = this.radio - 1;
  }
  else{
    println("Carretera Completada!");
    this.comenzar = true;
    agregarAgente(this.numAgentes);
  } //<>//
}

PVector calcularCandidato(){
  println(radio);
  println(" Calculando Candidatos...");
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
  return new PVector(-1, -1);
}

//  Renovar los agentes que salen de la ventana
void renovarAgentes() {
  int removidos = 0;
  boolean validar;
  do {
    validar = true;
    for (Agente p : agentes) {
      if (!(p.visibleX() && p.visibleY())) {
        agentes.remove(p);
        validar = false;
        removidos++;
        break;
      }
    }
  } while (!validar);
  //agregarAgente(removidos);
}

//  Distribucion de los Agentes
void agregarAgente(int cantidad) {
  for (int i = 0; i < cantidad; i++) {
    Agente auxiliar = new Agente(random(width), random(height), this.contAgentes++);
    boolean validar = false;
    while (!validar) {
      validar = true;
      for (Agente m : agentes) {
        if (m.colision(auxiliar)) {
          validar = false;
          auxiliar.posicionar();
        }
      }
    }
    auxiliar.zona = calcularZona(auxiliar.pos.x, auxiliar.pos.y);
    agentes.add(auxiliar);
  }
}

// Lineas que muestran las zonas
void lineas() {
  for (int i = 0; i < this.columnas; i++) {
    float aux = width/this.columnas;
    line(i*aux, 0, i*aux, height);
  }
  for (int i = 0; i < this.filas; i++) {
    float aux = height/this.filas;
    line(0, i*aux, width, i*aux);
  }
}

//  Pinta una zona
void drawZona(int zona) {
  float columna = zona % this.columnas;
  float fila = (zona - columna) / this.columnas;
  //println(fila+" : "+columna);
  float x = columna / this.columnas * width;
  float y = fila / this.filas * height;
  //println(x+" : "+y);
  fill(255, 0, 0, 50);
  rect(x, y, width/this.columnas, height/this.filas);
}

//  Calcula una zona
int calcularZona(float x, float y) {
  int columna = int(map(x, 0, width, 0, this.columnas));
  int fila = int(map(y, 0, height, 0, this.filas));
  //println(fila+" : "+columna);
  //println(fila*this.columnas+columna);
  return fila*this.columnas+columna;
}

//  Funciones con teclas
void keyPressed() {
  switch(key) {
  case '1':
    for (Agente i : agentes) {
      i.aplicarFuerza(new PVector(random(-1, 1), random(-1, 1)));
    }
    break;
  case '2':
    for (Agente i : agentes) {
      i.impulsar(0.1);
    }
    break;
  case '3':
    for (Agente i : agentes) {
      i.impulsar(-0.5);
    }
    break;
  }
}