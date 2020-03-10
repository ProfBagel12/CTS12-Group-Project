// Global Variable Declarations

// UI Related Global Variables
float UIBarThickness = 1.0/10; // UI Bar Thickness

// Ship, Wall, and Bullet Related Global Variables
int enemyRows = 4; // Number of Enemy Rows
int enemyCols = 9; // Number of Enemy Columns

PImage enemySprite; // Initialize Sprites
PImage userSprite;
PImage wallSprite;

Ship[] userShip = new Ship[1]; // Create User Ship Array
Bullet[] userBullets = new Bullet[1]; // Create User Bullets Array

Ship[] walls = new Ship[4]; // Create Walls Array

Ship[] enemyShips = new Ship[enemyRows*enemyCols]; // Create Enemy Ships Array
Bullet[] enemyBullets = new Bullet[5]; // Create Enemy Bullets Array

int fireRate = 2; // Enemy Bullet Fire Rate
IntList enemyShooting = new IntList(enemyShips.length); // Integer List Used for Randomly Selecting Firing Ship

// Core Function Definitions
void setup() {
  //Window Setup
  //fullScreen(); // To be used with final product
  size(1000, 750); // For use in testing
  frameRate(30); // Setting Frame Rate
  
  // Create Ship Sprites  
  enemySprite = createImage(width/(enemyCols+10), int(height*(1.0/3*(1-UIBarThickness)/(enemyRows+1))), RGB);
  userSprite = createImage(width/(enemyCols+10), int(height*(1.0/3*(1-UIBarThickness)/(enemyRows+1))), RGB);
  wallSprite = createImage(width/10, int(height/10), RGB);
  
  enemySprite.loadPixels();
  userSprite.loadPixels();
  wallSprite.loadPixels();
  
  for(int i=0; i<enemySprite.pixels.length; i++) { // Generate User & Enemy Sprites
    enemySprite.pixels[i] = color(255, 0, 0);
    userSprite.pixels[i] = color(0, 0, 255);
  }
  
  for(int i=0; i<wallSprite.pixels.length; i++) {
    wallSprite.pixels[i] = color(0, 255, 0);
  }
  
  enemySprite.updatePixels();
  userSprite.updatePixels();
  wallSprite.updatePixels();
  
  // Initializing Enemy Ships & Bullet Properties
  for(int i=0; i<enemyCols; i++) {
    for(int j=0; j<enemyRows; j++) {
      int idx = i + j*enemyCols;
      
      float xPos = width*(i+1)/(enemyCols+5) + width/6;
      float yPos = height*(1.0/2*(1-UIBarThickness)*(j+1)/(enemyRows+1) + UIBarThickness);
      
      enemyShips[idx] = new Ship(0, xPos, yPos);
    }
  }
  
  for(int i=0; i<enemyShips.length; i++) {
    enemyShooting.append(i);
  }
  
  // Initializing User Ship, Bullets, & Walls Properties
  userShip[0] = new Ship(1, width/2, height*(9.0/10));
  
  for(int i=0; i<walls.length; i++) {
    walls[i] = new Ship(2, width*(i+1)/(walls.length+1), height*(7.0/10));
  }
}

void draw() {
  // Drawing Modes
  imageMode(CENTER);
  
  // Creating Background
  background(0);
  
  // Enemy Ship Firing
  if( (0 == frameCount%fireRate)) {
     enemyShooting.shuffle(); 
     
     for(int i=1; i<=enemyBullets.length; i++) {
       enemyShips[enemyShooting.get(i)].shoot();
     }
  }
  
  // Draw Enemy Ships
  if(enemyShips[0].xVel > 0) { 
    for(int i=0; i<enemyShips.length; i++) {
      if(enemyShips[i].display == true) {
        enemyShips[i].movement();
      
        image(enemyShips[i].sprite, enemyShips[i].xPos, enemyShips[i].yPos);
      }
    }
  }
  else {
    for(int i=enemyShips.length-1; i>=0; i--) {
      if(enemyShips[i].display == true) {
        enemyShips[i].movement();
      
        image(enemyShips[i].sprite, enemyShips[i].xPos, enemyShips[i].yPos);
      }
    }
  }
  
  // Draw User Ship & Walls
  image(userShip[0].sprite, userShip[0].xPos, userShip[0].yPos);
  
  for(int i=0; i<walls.length; i++) {
    image(walls[i].sprite, walls[i].xPos, walls[i].yPos);
  }
  
  
}

// Other Function Definitions


// Class Definitions
class Ship {
  int type;
  PImage sprite;
  
  float xPos, yPos;
  float xVel;
  
  int health;
  boolean display;
  
  Ship (int hostility, float x, float y) {
    type = hostility;
    
    xPos = x;
    yPos = y;
    
    display = true;
    
    switch(type) {
      case 0: // Enemy Case
        health = 1;
        xVel = 2;
        
        sprite = createImage(enemySprite.width, enemySprite.height, RGB);
        sprite.loadPixels();
      
        for(int i=0; i<enemySprite.pixels.length; i++) {
          sprite.pixels[i] = enemySprite.pixels[i];
        }
      break;
      case 1: // User Case
        health = 3;
      
        sprite = createImage(userSprite.width, userSprite.height, RGB);
        sprite.loadPixels();
      
        for(int i=0; i<userSprite.pixels.length; i++) {
          sprite.pixels[i] = userSprite.pixels[i];
        }
      break;
      case 2: // Wall Case
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
        case 0: // Enemy Case
          if(enemyShips[enemyShips.length-1].xPos >= width-enemySprite.width) {
            xVel = -xVel; 
          }
          else if(enemyShips[0].xPos <= enemySprite.width) {
            xVel = -xVel; //<>//
          }
          
          xPos = xPos + xVel;
        break;
        case 1: // User Case
        
        break;
        case 2: // Wall Case
        
        break;
      } 
    }

     void shoot() {
       switch(type) {
         case 0: // Enemy Case
        
         break;
         case 1: // User Case
        
         break;
         case 2: // Wall Case
        
         break;
       }
     }
}

class Bullet {
  
}
