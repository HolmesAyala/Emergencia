
int filas = 10;
int columnas = 10;

int numAgentes = 100;

Sistema sistema;

//  Configuracion de pantalla
void settings() {
  size(columnas*100, filas*100);
}

//  Configuracion general
void setup() {
  sistema = new Sistema(this.numAgentes, this.filas, this.columnas);
  ellipseMode(RADIUS);
}

//  Dibujar
void draw() {
  sistema.ejecutar();
  println("fps: "+frameRate);
} //<>//

//  Funciones con teclas
void keyPressed() {
  switch(key) {
  case '1':
    sistema.addObstaculo();
    break;
  case '2':
    sistema.addAgente();
    break;
  case '3':
    sistema.verVision();
    break;
  }
}