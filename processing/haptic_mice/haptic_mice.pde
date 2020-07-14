import cc.arduino.*;
import org.firmata.*;
import processing.serial.*;
import controlP5.*;
import java.util.*;

int serialPortNumber;
String osName;
int motorL = 5;
int motorR = 6;
int motorV = 3;
int sensorL = 2;
int sensorR = 4;
int timeFeed = 5;

Arduino ardu;
ControlP5 cp5;
Textfield fldFreq1;
Textfield fldFreq2;
Textfield fldTime1;
Textfield fldTime2;
Textfield fldTimeout;
Button btnRun;
Button btnFill;
Button btnLeft;
Button btnRight;

void setup()
{
  println(Arduino.list());
  size(250,100);
  background(0);
  surface.setTitle("Haptic Mice");
  cp5 = new ControlP5(this);
  btnFill = cp5.addButton("fill")
  .setPosition(0,0)
  ;
  fldFreq1 = cp5.addTextfield("freq1")
    .setPosition(110,0)
    .setSize(40,20)
    .setText("0");
  fldFreq2 = cp5.addTextfield("freq2")
    .setPosition(110,40)
    .setSize(40,20)
    .setText("0");
   ;
  btnRun = cp5.addButton("run")
    .setPosition(160,80)
    .setSize(80,20)
    ;
  btnLeft = cp5.addButton("left")
    .setPosition(0,80);
  btnRight = cp5.addButton("right")
    .setPosition(80,80);

    ardu = new Arduino(this,Arduino.list()[0],57600);
    ardu.pinMode(2,Arduino.INPUT);
    ardu.pinMode(4,Arduino.INPUT);
    ardu.pinMode(3,Arduino.OUTPUT);
    ardu.pinMode(5,Arduino.OUTPUT);
    ardu.pinMode(6,Arduino.OUTPUT);
}

void draw()
{
}

public void controlEvent(ControlEvent event)
{
  if (event.getController().getName() == "run")
  {
    println("run");
    println(int(fldFreq1.getText()));
    vibrate(int(fldFreq1.getText()),1);
    delay(500);
    println(int(fldFreq2.getText()));
    vibrate(int(fldFreq2.getText()),1);
    println("end");
    
  } else if (event.getController().getName() == "fill")
  {
    println("filling");
    ardu.digitalWrite(motorL,Arduino.HIGH);
    ardu.digitalWrite(motorR,Arduino.HIGH);
    delay(9000);
    ardu.digitalWrite(motorR,Arduino.LOW);
    ardu.digitalWrite(motorL,Arduino.LOW);
  } else if (event.getController().getName() == "left")
  {
    feed(motorL);
    println("left");
  } else if (event.getController().getName() == "right")
  {
    feed(motorR);
    println("right");
  }
}

void feed(int motor)
{
  ardu.digitalWrite(motor,Arduino.HIGH);
  delay(timeFeed);
  ardu.digitalWrite(motor,Arduino.LOW);
  delay(10);
  ardu.digitalWrite(motor,Arduino.HIGH);
  delay(timeFeed);
  ardu.digitalWrite(motor,Arduino.LOW);
}

void vibrate(int ifreq,int iduration)
{
  if(ifreq > 0)
  {
    int off_time,duration;
    off_time = (1000/ifreq);
    duration = (ifreq*iduration)-1;
    for (int i = 0; i <= duration; i++)
    {
     ardu.digitalWrite(3,Arduino.HIGH);
     delay(10);
     ardu.digitalWrite(3,Arduino.LOW);
     delay(off_time);
    }
  } else {
    delay(iduration);
  }
}
