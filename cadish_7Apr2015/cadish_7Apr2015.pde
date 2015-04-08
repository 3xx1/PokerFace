import controlP5.*;

float angleX, angleY; 
int layers = 30;
int granurarity = 60;
int stretch = 10;
int[][][] points = new int[layers][granurarity][3];

void setup(){
  size(1280, 720, P3D);
  colorMode(RGB, 256);
  smooth();
  background(0);
  stroke(255);
  for(int j=0; j<layers; j++){
    for(int i=0; i<granurarity; i++){
      points[j][i][0] = int(100*cos(radians((360/granurarity)*i)));
      points[j][i][1] = int(100*sin(radians((360/granurarity)*i)));
      points[j][i][2] = j*stretch; 
    }
  }
}

void draw(){
  background(0);
  angleX += .001;
  angleY += .003;         
  // rotateY(angleX);
  
  translate(width/2, 3*height/4, stretch*layers/2);
  rotateX(radians(90));
  rotateZ(radians(mouseX));
  stroke(255, 150);
  for(int j=0; j<layers-1; j++){
    for(int i=0; i<granurarity-1; i++){
      line(points[j][i][0], points[j][i][1], points[j][i][2], points[j][i+1][0], points[j][i+1][1], points[j][i+1][2]);
      line(points[j][i][0], points[j][i][1], points[j][i][2], points[j+1][i][0], points[j+1][i][1], points[j+1][i][2]);
    }
    line(points[j][granurarity-1][0], points[j][granurarity-1][1], points[j][granurarity-1][2], points[j][0][0], points[j][0][1], points[j][0][2]);
  }
  line(points[layers-1][granurarity-1][0], points[layers-1][granurarity-1][1], points[layers-1][granurarity-1][2], points[0][granurarity-1][0], points[0][granurarity-1][1], points[0][granurarity-1][2]);
}




