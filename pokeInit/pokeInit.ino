
#include <Servo.h> 
 
Servo myservo;
int pos = 0;

void setup() 
{ 
  Serial.begin(9600);
  myservo.attach(9);
} 
 
void loop() 
{ 
  if(Serial.available()>0){
    pos = Serial.read();
  }
  
  myservo.write(pos);
  /*
  for(pos = 0; pos <= 90; pos +=5) // goes from 0 degrees to 180 degrees 
  {                                  // in steps of 1 degree 
    myservo.write(pos);              // tell servo to go to position in variable 'pos' 
    delay(15);                       // waits 15ms for the servo to reach the position 
  } 
  for(pos = 90; pos>=0; pos-=5)     // goes from 180 degrees to 0 degrees 
  {                                
    myservo.write(pos);              // tell servo to go to position in variable 'pos' 
    delay(15);                       // waits 15ms for the servo to reach the position 
  } 
  */
} 
