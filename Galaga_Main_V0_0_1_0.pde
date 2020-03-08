// Game Control Plus Library Declarations
import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;

ControlIO control;
ControlDevice stick;

// Global Variable Declarations

// UI Related Global Variables
float UIBarThickness = 1.0/10;

// Ship, Wall, and Bullet Related Global Variables
<<<<<<< HEAD
int enemyRows = 4;
=======
int enemyRows = 4; 
>>>>>>> parent of fd6eddc... Add files via upload
int enemyCols = 9;

PImage enemySprite;
PImage userSprite;
PImage wallSprite;

<<<<<<< HEAD
Ship[] userShip = new Ship[1];
Bullet[] userBullets = new Bullet[1];
 
=======
Ship[] userShip = new Ship[1]; // Create User Ship Array
Bullet[] userBullets = new Bullet[1]; // Create User Buller Array

Ship[] walls = new Ship[4];

>>>>>>> parent of fd6eddc... Add files via upload
Ship[] enemyShips = new Ship[enemyRows*enemyCols];
Bullet[] enemyBullets = new Bullet[5];

int fireRate = 2;
IntList enemyShooting = new IntList(enemyShips.length);

boolean KeyboardMode = false;
float userSpeed = 0;


// Core Function Definitions
void setup() {
  //Window Setup
  //fullScreen(); // To be used with final product
  size(1000, 750);
  frameRate(30);
  
  control = ControlIO.getInstance(this);
  
   stick = control.filter(GCP.STICK).getMatchedDevice("UserShipInput");
  if (stick == null) {
    KeyboardMode = true;
  }
  println(stick);
  // Creating Background
  background(0);
  
  // Create Ship Sprites  
  enemySprite = createImage(width/(enemyCols+5), int(height*(1.0/3*(1-UIBarThickness)/(enemyRows+1))), RGB);
  userSprite = createImage(width/(enemyCols+5), int(height*(1.0/3*(1-UIBarThickness)/(enemyRows+1))), RGB);
  wallSprite = createImage(width/5, int(height/6), RGB);
  
  enemySprite.loadPixels();
  userSprite.loadPixels();
  wallSprite.loadPixels();
  
  for(int i=0; i<enemySprite.pixels.length; i++) {
    enemySprite.pixels[i] = color(255, 0, 0);
    userSprite.pixels[i] = color(0, 0, 255);
  }
  
  for(int i=0; i<wallSprite.pixels.length; i++) {
    wallSprite.pixels[i] = color(0, 255, 0);
  }
  
  enemySprite.updatePixels();
  userSprite.updatePixels();
  wallSprite.updatePixels();
  
  // Initializing Enemy Ships & Properties
  for(int i=0; i<enemyCols; i++) {
    for(int j=0; j<enemyRows; j++) {
      int idx = i + j*enemyCols;
      
      float xPos = width*(i+1)/(enemyCols+1);
      float yPos = height*(1.0/2*(1-UIBarThickness)*(j+1)/(enemyRows+1) + UIBarThickness);
      
      enemyShips[idx] = new Ship( 0, xPos, yPos ); //<>//
    }
  }
  
  for(int i=0; i<enemyShips.length; i++) {
    enemyShooting.append(i);
  }
  
  // Initializing User Ship
  userShip[0] = new Ship( 1, width/2, height*(9.0/10) );
}

void draw() {
  
  // Drawing Modes
  imageMode(CENTER);
  
  // Enemy Ship Firing
<<<<<<< HEAD
  if(0 == frameCount % fireRate) {
=======
  if( (0 == frameCount%fireRate) && ( {
>>>>>>> parent of fd6eddc... Add files via upload
     enemyShooting.shuffle(); 
     
     for(int i=1; i<=enemyBullets.length; i++) {
       enemyShips[enemyShooting.get(i)].shoot();
     }
  }
  
  // Drawing Enemy Ships
  for(int i=0; i<enemyShips.length; i++) {
    if(enemyShips[i].display == true) {
      image(enemyShips[i].sprite, enemyShips[i].xPos, enemyShips[i].yPos);
    }
  }
  userShip[0].movement();
  image(userShip[0].sprite, userShip[0].xPos, userShip[0].yPos);
  
<<<<<<< HEAD
 //<>//
=======
  for(int i=0; i<walls.length; i++) {
    image(walls[i].sprite, walls[i].xPos, walls[i].yPos);
  } //<>//
>>>>>>> parent of fd6eddc... Add files via upload
}

// Other Function Definitions
void keyPressed(){
  if (keyCode == (LEFT)){
     userSpeed = -1.0;
  }
  if (keyCode == (RIGHT)){
    userSpeed = 1.0;
  }
}

void keyReleased(){
  if (keyCode == (LEFT)) {
    userSpeed = 0;
  }
  if (keyCode == (RIGHT)){
    userSpeed = 0;
  }
}

void processUserGameInput(){
  
}

// Class Definitions
class Ship {
  int type;
  PImage sprite;
  
  float xPos, yPos;
  
  int health;
  boolean display;
  
  Ship (int hostility, float x, float y) {
    type = hostility;
    
    xPos = x;
    yPos = y;
    
    display = true;
    
    switch(type) {
      case 0:
        health = 1;
      
        sprite = createImage(enemySprite.width, enemySprite.height, RGB);
        sprite.loadPixels();
      
        for(int i=0; i<enemySprite.pixels.length; i++) {
          sprite.pixels[i] = enemySprite.pixels[i];
        }
      break;
      case 1:
        health = 3;
      
        sprite = createImage(userSprite.width, userSprite.height, RGB);
        sprite.loadPixels();
      
        for(int i=0; i<userSprite.pixels.length; i++) {
          sprite.pixels[i] = userSprite.pixels[i];
        }
      break;
      case 2:
        health = 10;
        
        sprite = createImage(wallSprite.width, wallSprite.height, RGB);
        sprite.loadPixels();
      
        for(int i=0; i<wallSprite.pixels.length; i++) {
          sprite.pixels[i] = wallSprite.pixels[i];
        }
      break;
    }
  }

    void updateHealth() {
      health--;
      
      if(health <= 0) {
        display = false;
      }
      
      if(type == 2) {
        sprite.loadPixels();
        tint(255, 242);
        sprite.updatePixels();
      }
    }
    
    void movement() {
      switch(type) {
        case 0:
        
        break;
        case 1:
        userSpeed = stick.getSlider("SHIP X").getValue();
        xPos = xPos+userSpeed*6;
        break;
        case 2:
        
        break;
      } 
    }

     void shoot() {
       switch(type) {
         case 0:
        
         break;
         case 1:
        
         break;
         case 2:
        
         break;
       }
     }
}

class Bullet {
  
}
