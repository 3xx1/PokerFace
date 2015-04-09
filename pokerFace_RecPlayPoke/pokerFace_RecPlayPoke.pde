// plug Arduino on 1411(left), and LeapMotion on 1451(right)

import processing.serial.*;

import java.util.Map;
import java.util.concurrent.ConcurrentMap;
import java.util.concurrent.ConcurrentHashMap;

import com.leapmotion.leap.Controller;
import com.leapmotion.leap.Finger;
import com.leapmotion.leap.Frame;
import com.leapmotion.leap.Hand;
import com.leapmotion.leap.Tool;
import com.leapmotion.leap.Vector;
import com.leapmotion.leap.processing.LeapMotion;
Serial myPort; 
LeapMotion leapMotion;
int screenWidth = 16 * 50;
ConcurrentMap<Integer, Integer> fingerColors;
ConcurrentMap<Integer, Integer> toolColors;
ConcurrentMap<Integer, Vector> fingerPositions;
ConcurrentMap<Integer, Vector> toolPositions;

int fingers = 0;
boolean beginRecording;
ArrayList<Float> data = new ArrayList<Float>();

void setup()
{
  size(screenWidth, 9 * 50);
  background(20);
  frameRate(60);
  ellipseMode(CENTER);
  leapMotion = new LeapMotion(this);
  fingerColors = new ConcurrentHashMap<Integer, Integer>();
  toolColors = new ConcurrentHashMap<Integer, Integer>();
  fingerPositions = new ConcurrentHashMap<Integer, Vector>();
  toolPositions = new ConcurrentHashMap<Integer, Vector>();
  
  myPort = new Serial(this, "/dev/tty.usbmodem1411", 9600);
  
  beginRecording = false;
}

void draw()
{
  background(0);
  
  if(fingers==1){
    if(!beginRecording){
      for (int i = data.size() - 1; i >= 0; i--) {
        data.remove(i); 
      }
    }
    beginRecording = true;
  }else{
    beginRecording = false;
  }
  
  noStroke();
  if(!beginRecording)fill(0,0,255);
  if(beginRecording) fill(255,0,0);
  ellipse(width-50,50,50,50);
  
  
  
  for (Map.Entry entry : fingerPositions.entrySet())
  {
    Integer fingerId = (Integer) entry.getKey(); 
    println(fingerId); 
    Vector position = (Vector) entry.getValue(); 
    
    if(fingers==1 && fingerId%10==1) {
      // ellipse(leapMotion.leapToSketchX(position.getZ()), leapMotion.leapToSketchY(position.getY()), 24.0, 24.0);
      
      data.add(leapMotion.leapToSketchX(position.getZ()) );
      myPort.write(int(map(leapMotion.leapToSketchX(position.getZ()), 0, width, 90, 0)));
    }
  }
  
  stroke(255);
  for(int i=0; i<data.size()-1; i++){
    line(width-i, data.get(data.size()-(i+1)), width-(i+1), data.get(data.size()-(i+2)));
  }
}

void onFrame(final Controller controller)
{
  fingers = countExtendedFingers(controller);
  // println(fingers);
  
  Frame frame = controller.frame();
  fingerPositions.clear();
  for (Finger finger : frame.fingers())
  {
    int fingerId = finger.id();
    color c = color(random(0, 255), random(0, 255), random(0, 255));
    fingerColors.putIfAbsent(fingerId, c);
    fingerPositions.put(fingerId, finger.tipPosition());
  }
  toolPositions.clear();
  for (Tool tool : frame.tools())
  {
    int toolId = tool.id();
    color c = color(random(0, 255), random(0, 255), random(0, 255));
    toolColors.putIfAbsent(toolId, c);
    toolPositions.put(toolId, tool.tipPosition());
  }
}


int countExtendedFingers(final Controller controller)
{
  int fingers = 0;
  if (controller.isConnected())
  {
    Frame frame = controller.frame();
    if (!frame.hands().isEmpty())
    {
      for (Hand hand : frame.hands())
      {
        int extended = 0;
        for (Finger finger : hand.fingers())
        {
          if (finger.isExtended())
          {
            extended++;
          }
        }
        fingers = Math.max(fingers, extended);
      }
    }
  }
  return fingers;
}


void mousePressed(){
  for(int i=0; i<data.size(); i++){
    myPort.write(int(map(data.get(i), 0, width, 90, 0)));
    delay(15);
  }
}
