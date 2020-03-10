// Blake Christierson
// Elaina Guardado
// Peter Milam
// Stuart Scolaro

// CTS012 WQ2020
// Professor Michael Neff

// Game Control Plus Library Declarations
import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;

ControlIO control;
ControlDevice stick;

boolean controllerMode = true;

// UI Related Global Variables
float UIBarThickness = 1.0/10; // UI Bar Thickness
int time = 120; // Game Time
int score = 0; // Game Score

// Ship, Wall, and Bullet Related Global Variables
int enemyRows = 4; // Number of Enemy Rows
int enemyCols = 9; // Number of Enemy Columns

PImage enemySprite; // Initialize Sprites
PImage userSprite;

PImage enemyBulletSprite;
PImage userBulletSprite; 

PImage wallSprite;
PImage backgroundSprite;

Ship[] userShip = new Ship[1]; // Create User Ship Array
Bullet[] userBullets = new Bullet[1]; // Create User Bullets Array

float userSpeed = 0; // Initialize User Speed

Ship[] walls = new Ship[4]; // Create Walls Array

Ship[] enemyShips = new Ship[enemyRows*enemyCols]; // Create Enemy Ships Array
Bullet[] enemyBullets = new Bullet[5]; // Create Enemy Bullets Array

int fireRate = 2; // Enemy Bullet Fire Rate
IntList enemyShooting = new IntList(enemyShips.length); // Integer List Used for Randomly Selecting Firing Ship

// Core Function Definitions
void setup() {
  //Window Setup
  fullScreen(); // To be used with final product
  //size(1000, 750); // For use in testing
  frameRate(30);

  //Controller Setup
  control = ControlIO.getInstance(this);
  stick = control.filter(GCP.STICK).getMatchedDevice("UserShipInput");
  if (stick == null) {
    controllerMode = false;
  }

  // Load & Resize Sprites
  enemySprite = loadImage("Antag.png");
  userSprite = loadImage("Protag.png");
  
  enemyBulletSprite = loadImage("Ant_Bullet.png");
  userBulletSprite = loadImage("Pro_Bullet.png");
  
  wallSprite = loadImage("Wall.png");
  backgroundSprite = loadImage("Background.png");
  
  enemySprite.resize(width/(enemyCols+10), int(height*(1.0/3*(1-UIBarThickness)/(enemyRows+1))));
  userSprite.resize(width/(enemyCols+10), int(height*(1.0/3*(1-UIBarThickness)/(enemyRows+1))));
  
  enemyBulletSprite.resize(width/100, height/50);
  userBulletSprite.resize(width/100, height/50);
  
  wallSprite.resize(width/8, int(height/8));
  backgroundSprite.resize(width,height);

  // Initializing Enemy Ships & Bullet Properties
  for (int i=0; i<enemyCols; i++) {
    for (int j=0; j<enemyRows; j++) {
      int idx = i + j*enemyCols;

      float xPos = width*(i+1)/(enemyCols+5) + width/6;
      float yPos = height*(1.0/2*(1-UIBarThickness)*(j+1)/(enemyRows+1) + UIBarThickness);

      enemyShips[idx] = new Ship(0, xPos, yPos); // See Class Constructor Below
    }
  }

  for (int i=0; i<enemyBullets.length; i++) {
    enemyBullets[i] = new Bullet(0, 0, 0); // Initialize Hidden Enemy Bullets in Top-Left Corner
  }
  
  for (int i=0; i<enemyShips.length; i++) {
    enemyShooting.append(i); // Populate Shooting Integer List
  }

  // Initializing User Ship, Bullets, & Walls Properties
  userShip[0] = new Ship(1, width/2, height*(9.0/10)); // Create User Ship
  userBullets[0] = new Bullet(1, 0, 0); // Create User Bullet
  
  for (int i=0; i<walls.length; i++) {
    walls[i] = new Ship(2, width*(i+1)/(walls.length+1), height*(7.0/10)); // Create Walls
  }
}

void draw() {
  // Creating Background
  background(0);
  
  if ((userShip[0].health <= 0) || (time <= 0) || (score >= 720) ) { // Game Over Condition
    textAlign(CENTER, CENTER);
    fill(255, 0, 0);
    textSize(height/6);
    text("GAME OVER", width/2, height/3);
    text("SCORE: "+str(score+userShip[0].health*50+time), width/2, height*2); // Add User Health and Time Remaining to Score
  } else { // Game in Progress Condition
    // Drawing Modes
    imageMode(CENTER);

    // Enemy Ship Firing
    if (0 == frameCount%(fireRate*int(frameRate))) { // Determines Fire Rate
      enemyShooting.shuffle(); // Shuffle Integer List

      for (int i=1; i<=enemyBullets.length; i++){ // Loop Through Enemy Bullet Array
        if (enemyBullets[i-1].display == false) { // Only Progress if Bullet is Hidden
          enemyShips[enemyShooting.get(i)].shoot(enemyBullets[i-1]); // Shoot Bullet from Randomly Choosen Ship Position
        }
      }
    }

    // Draw Enemy Ships
    if (enemyShips[0].xVel > 0) { // If Moving Right
      for (int i=0; i<enemyShips.length; i++) { // Loop Through Ships
        enemyShips[i].movement(); // Move Ships
        
        if (enemyShips[i].display == true) { // Display Ships if True
          image(enemyShips[i].sprite, enemyShips[i].xPos, enemyShips[i].yPos);
        }
      }
    } else { // If Moving Left
      for (int i=enemyShips.length-1; i>=0; i--) { // Loop Backwards Through Ships (Must be Done do Avoid an Error)
        enemyShips[i].movement(); // Move Ships
        
        if (enemyShips[i].display == true) { // Display Ships if True
          image(enemyShips[i].sprite, enemyShips[i].xPos, enemyShips[i].yPos);
        }
      }
    }

    // Draw User Ship & Walls
    userShip[0].movement(); // Move User Ship
    image(userShip[0].sprite, userShip[0].xPos, userShip[0].yPos);

    for (int i=0; i<walls.length; i++) { // Loop Through Walls
      if (walls[i].display == true) { // Proceed if True
        tint(255, walls[i].health*255/10.0); // Tint Based on Current Health
        image(walls[i].sprite, walls[i].xPos, walls[i].yPos);
      }
    }
  
    noTint(); // Reset Tint
    
    // Draw Bullets
    if (userBullets[0].display == true) { // Draw if True
      userBullets[0].movement(); // Move User Bullet
      userBullets[0].hit(); // Hit Detection for Bullet
      
      image(userBullets[0].sprite, userBullets[0].xPos, userBullets[0].yPos);
    }
    
    for (int i=0; i<enemyBullets.length; i++) { // Loop Through Enemy Bullet
      if (enemyBullets[i].display == true) { // Draw if True
        enemyBullets[i].movement(); // Move Enemy Bullet
        enemyBullets[i].hit(); // Hit Detection for Bullet
      
        image(enemyBullets[i].sprite, enemyBullets[i].xPos, enemyBullets[i].yPos);  
      }
    }
  
    // Time & Score Tracker
    time = 120 - int(frameCount/frameRate); // Time Calculation
    
    fill(255, 255, 255); // Fill White
    textSize(height*UIBarThickness*0.6);
    
    textAlign(CENTER, CENTER); // Alignment
    text("Time: "+str(time), (width/2), int(UIBarThickness*height/2)); // Display Time
  
    textAlign(LEFT, CENTER); // Alignment
    text("SCORE: "+str(score), (width/20), int(UIBarThickness*height/2)); // Display Score
  
    textAlign(RIGHT, CENTER); // Alignment
    text("Health: "+str(userShip[0].health)+"   ", width*(1-1/20), int(UIBarThickness*height/2)); // Display User Score
  }
  if (controllerMode){
    if (stick.getButton("FIRE").pressed()){
      if (userBullets[0].display == false) {
       userShip[0].shoot(userBullets[0]);
    }
    }
  }
}

// Movement Function Definitions
void keyPressed() { // User Input Definitions for Keyboard Input
  if (keyCode == (LEFT)) {
    userSpeed = -1.0; 
  }
  if (keyCode == (RIGHT)) {
    userSpeed = 1.0;
  }
  if (keyCode == ' ') {
    if (userBullets[0].display == false) {
       userShip[0].shoot(userBullets[0]);
    }
  }
}

void keyReleased() {
  if (keyCode == (LEFT)) {
    userSpeed = 0;
  }
  if (keyCode == (RIGHT)) {
    userSpeed = 0;
  } 
}

// Class Definitions
class Ship { // Ship Class Definition
  int type;
  PImage sprite;

  float xPos, yPos;
  float xVel;

  int health;
  boolean display;

  Ship (int hostility, float x, float y) {
    type = hostility; // Set Type (0 == Enemy, 1 == User, 2 == Wall)

    xPos = x; // Set Position
    yPos = y;

    display = true; // Display Boolean

    switch(type) { 
    case 0: // Enemy Case
      health = 1; // Set Health
      xVel = 2; // Set Velocity
      
      // Allocate Sprite
      sprite = createImage(enemySprite.width, enemySprite.height, RGB);
      sprite.loadPixels();

      for (int i=0; i<enemySprite.pixels.length; i++) {
        sprite.pixels[i] = enemySprite.pixels[i];
      }
      break;
    case 1: // User Case
      health = 3; // Set Health
      
      // Allocate Sprite
      sprite = createImage(userSprite.width, userSprite.height, RGB);
      sprite.loadPixels();

      for (int i=0; i<userSprite.pixels.length; i++) {
        sprite.pixels[i] = userSprite.pixels[i];
      }
      break;
    case 2: // Wall Case
      health = 10; // Set Health
      
      // Allocate Sprite
      sprite = createImage(wallSprite.width, wallSprite.height, RGB);
      sprite.loadPixels();

      for (int i=0; i<wallSprite.pixels.length; i++) {
        sprite.pixels[i] = wallSprite.pixels[i];
      }
      break;
    }
  }

  void updateHealth() { // Called if Hit Detected
    health--; // Decrement Health

    if (health <= 0) {
      display = false; // Cease to Display
      
      if (type == 0) {
        score = score + 20; // Increase Score
      }
    }
  }

  void movement() {
    switch(type) {
    case 0: // Enemy Case
      if (enemyShips[enemyShips.length-1].xPos >= width-sprite.width) { // Reverse from Right to Left on Right Border
          xVel = -xVel;
      } else if (enemyShips[0].xPos <= sprite.width) { // Reverse from Left to Right on Left Border
        xVel = -xVel;
      }

      xPos = xPos + xVel; // Update Position
      break;
    case 1: // User Case
      if (controllerMode) { // If Outboard Controller Used
        userSpeed = stick.getSlider("SHIP X").getValue(); //<>//
      }
      if (xPos > width - userSprite.width) { // Right Border
        userSpeed = 0;
        xPos = xPos - 1;
      }
      if (xPos < userSprite.width) { // Left Border
        userSpeed = 0;
        xPos = xPos +1;
      }
      
      xPos = xPos+userSpeed*6; // Update Position
      break;
    }
  }

  void shoot(Bullet instBullet) { // Update Bullet Instance
    switch(type) {
    case 0: // Enemy Case
        instBullet.xPos = xPos; // Update Bullet Position
        instBullet.yPos = yPos;
        instBullet.display = true; // Display Bullet
      break;
    case 1: // User Case
        instBullet.xPos = xPos; // Update Bullet Position
        instBullet.yPos = yPos;
        instBullet.display = true; // Display Bullet
      break;
    }
  }
}

class Bullet { // Bullet Class Constructor
  int type;
  
  PImage sprite;
  boolean display;
  
  float xPos, yPos;
  int velocity;
  
  Bullet (int hostility, float x, float y) {
    type = hostility; // Set Type (0 == Enemy, 1 == User)
    
    display = false; // Display Value
    
    xPos = x; // Set Position
    yPos = y;
    
    switch(type) {
      case 0: // Enemy Case
        velocity = 8; // Move Down
        
        // Allocate Sprite
        sprite = createImage(enemyBulletSprite.width, enemyBulletSprite.height, RGB);
        sprite.loadPixels();
        
        for(int i=0; i<enemyBulletSprite.pixels.length; i++) {
         sprite.pixels[i] = enemyBulletSprite.pixels[i];
        }
        
        break;
      case 1: // User Case
        velocity = -8; // Move Up 
        
        // Allocate Sprite
        sprite = createImage(userBulletSprite.width, userBulletSprite.height, RGB);
        sprite.loadPixels();
        
        for(int i = 0; i<userBulletSprite.pixels.length; i++) {
          sprite.pixels[i] = userBulletSprite.pixels[i];
        }
        
        break;
    }
  }
  
  void movement() {
    yPos = yPos + velocity; // Update Position
  }
  
  void hit() { // Hit Detection
    switch(type) { 
      case 0: // Enemy Case
        for (int i=0; i<walls.length; i++) { // Loop Through Walls
          if (walls[i].display == true) { // Proceed if Wall Exists
            if (xPos + sprite.width/2 >= walls[i].xPos - walls[i].sprite.width/2 && // Check if Bullet and Wall Boundary Intersect
                xPos - sprite.width/2 <= walls[i].xPos + walls[i].sprite.width/2 &&
                yPos + sprite.height/2 >= walls[i].yPos - walls[i].sprite.height/2 &&
                yPos - sprite.height/2 <= walls[i].yPos + walls[i].sprite.height/2) {
                  display = false; // Cease to Display Bullet
                  
                  walls[i].updateHealth(); // Update Wall Health
            }
          }
        }
        
        if (xPos + sprite.width/2 >= userShip[0].xPos - userShip[0].sprite.width/2 && // Check if Bullet and User Boundary Intersect
            xPos - sprite.width/2 <= userShip[0].xPos + userShip[0].sprite.width/2 &&
            yPos + sprite.height/2 >= userShip[0].yPos - userShip[0].sprite.height/2 &&
            yPos - sprite.height/2 <= userShip[0].yPos + userShip[0].sprite.height/2) {
              display = false; // Cease to Display Bullet
                  
              userShip[0].updateHealth(); // Update User Health
        }
        
        if (yPos > height) { // Check OOB for Bullet
          display = false; // Cease to Display Bullet
        }
        
        break;
      case 1: // User Case
        for (int i=0; i<walls.length; i++) { // Loop Through Walls
          if (walls[i].display == true) { // Proceed if Wall Exists
            if (xPos + sprite.width/2 >= walls[i].xPos - walls[i].sprite.width/2 && // Check if Bullet and Wall Boundary Intersect
                xPos - sprite.width/2 <= walls[i].xPos + walls[i].sprite.width/2 &&
                yPos + sprite.height/2 >= walls[i].yPos - walls[i].sprite.height/2 &&
                yPos - sprite.height/2 <= walls[i].yPos + walls[i].sprite.height/2) {
                  display = false; // Cease to Display Bullet
                  
                  walls[i].updateHealth(); // Update Wall Health
            }
          }
        }
        
        for(int i=0; i<enemyShips.length; i++) { // Loop Through Enemies
          if (enemyShips[i].display == true) { // Proceed if Enemy Exist
            if (xPos + sprite.width/2 >= enemyShips[i].xPos - enemyShips[i].sprite.width/2 && // Check if Bullet and Enemy Boundary Intersect
                xPos - sprite.width/2 <= enemyShips[i].xPos + enemyShips[i].sprite.width/2 &&
                yPos + sprite.height/2 >= enemyShips[i].yPos - enemyShips[i].sprite.height/2 &&
                yPos - sprite.height/2 <= enemyShips[i].yPos + enemyShips[i].sprite.height/2) {
                  display = false; // Cease to Display Bullet
                    
                  enemyShips[i].updateHealth(); // Update Enemy Health
            }
          }
        }
        
        if (yPos < 0) { // Check OOB for Bullet
          display = false; // Cease to Dispaly Bullet
        } //<>//
        
        break;
    }
  }
}
