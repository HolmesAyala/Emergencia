import java.util.Map;

//ArrayList <Particula> particulas;
//int zonas = 9;

int filas = 9;
int columnas = 9;

int contAgentes = 1;
int numAgentes = 100;

ArrayList <Agente> agentes;
Agente m;

void settings(){
  size(columnas*100, filas*100);
}

void setup(){
  textSize(15);
  m=new Agente(mouseX, mouseY, 0);
  agentes = new ArrayList<Agente>(); 
  agentes.add(m);
  for(int i = 0; i < numAgentes; i++){
    Agente auxiliar = new Agente(random(width), random(height), this.contAgentes++);
    
    //  Distribucion de los Agentes
    boolean validar = false;
    while(!validar){
      validar = true;
      for(Agente m: agentes){
        if(m.buscarPosicion(auxiliar)){
          validar = false;
          auxiliar.posicionar();
        }
      }
    }
    
    auxiliar.zona = calcularZona(auxiliar.pos.x, auxiliar.pos.y);
    agentes.add(auxiliar);
  }
}

void draw(){
  background(255);
  m.posicionar(new PVector(mouseX, mouseY));
  //println("Agentes: "+agentes.size());
  
  for(Agente p: agentes){
    p.zona = calcularZona(p.pos.x, p.pos.y);
    drawZona(p.zona);
    if(colision(p)>=0){
      //p.impulsar(-0.1);
    }
    else{
      //p.impulsar(0.1);
    }
    p.mover();
    p.dibujar();
  }
  lineas();
  renovarAgentes();
}

void renovarAgentes(){
  boolean validar;
  do{
    validar = true;
    for(Agente p: agentes){
      if(!(p.visibleX() && p.visibleY())){
        agentes.remove(p);
        validar = false;
        //agentes.add(new Agente(random(width), random(height), this.contAgentes++));
        break;
      }
    }
  }while(!validar);
}

float colision(Agente a){
  float d = -1;
  for(Agente i : agentes){
    if(i!=a){
      if(a.obstaculo(i)){
        d = a.distancia(i);
        break;
      }
    }
  }
  return d;
}

boolean colisiona(Agente a){
  boolean det=false;
  for(Agente i : agentes){
   if(a.colision(i)){
     det = true;
   }
  }
  return det;
}

void lineas(){
  for(int i = 0; i < this.columnas; i++){
    float aux = width/this.columnas;
    line(i*aux, 0, i*aux, height);
  }
  for(int i = 0; i < this.filas; i++){
    float aux = height/this.filas;
    line(0, i*aux, width, i*aux);
  }
}

void drawZona(int zona){
  float columna = zona % this.columnas;
  float fila = (zona - columna) / this.columnas;
  println(fila+" : "+columna);
  float x = columna / this.columnas * width;
  float y = fila / this.filas * height;
  //println(x+" : "+y);
  fill(255, 0, 0, 50);
  rect(x, y, width/this.columnas, height/this.filas);
}

int calcularZona(float x, float y){
    int columna = int(map(x, 0, width, 0, this.columnas));
    int fila = int(map(y, 0, height, 0, this.filas));
    //println(fila+" : "+columna);
    //println(fila*this.columnas+columna);
    return fila*this.columnas+columna;
}

void keyPressed(){
 switch(key){
   case '1':
      for(Agente i : agentes){
        i.aplicarFuerza(new PVector(random(-1, 1), random(-1, 1)));
      }
     break;
   case '2':
      for(Agente i : agentes){
        i.impulsar(0.1);
      }
     break;
   case '3':
      for(Agente i : agentes){
        i.impulsar(-0.5);
      }
     break;
 }
}