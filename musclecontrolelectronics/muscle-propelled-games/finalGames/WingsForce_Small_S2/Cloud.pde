class Cloud {
  
  //int posX = 1280; //changed
  int posX = 800; //changed
  //int posY = int(random(75,650)); //720/2; //changed
  int posY = int(random(75,550)); //720/2; //changed
  PShape cloudshape;
  int speed = 10/4;
  boolean dir = true;
  int collideX = 300/2; //changed /2
  int collideY = 250/2;//changed /2
  boolean evil = true;
  boolean isDrawn = true;

  
  // Contructor (required)
  Cloud(int type,boolean leftToRight, int sspeed) {
    speed = sspeed;
    dir = leftToRight;
    
    if (!leftToRight)
    {
     posX  = 0; 
    }
    
    if (type == 1)
    {
      //cloudshape = loadShape("cloud2_white.svg");  
      cloudshape = cloud2_white;  
      evil = false;    
    }
    else if (type == 2)
    {
      cloudshape = loadShape("cloudz2_white.svg");
      //cloudshape = cloudz2_white;
      evil = false;
    }
    else if (type == 3) {
      cloudshape = loadShape("cloud2_black.svg"); 
      //cloudshape = cloud2_black; 
      evil = true;
    }    
    else if (type == 4) {
      cloudshape = loadShape("cloudz2_black.svg"); 
      //cloudshape = cloudz2_black; 
      evil = true;
    }
    else if (type == 5) {
      cloudshape = loadShape("cloud2_black.svg"); 
      //cloudshape = cloud2_black; 
      evil = true;
    }        
      else if (type == 6) {
      cloudshape = loadShape("cloud2_white.svg"); 
      //cloudshape = cloudz2_black; 
      evil = true;
    }          
      else if (type == 7) {
        cloudshape = loadShape("cloudz2_white.svg"); 
//      cloudshape = cloudz2_black; 
      evil = true;
    }      
  }
  
 
  void update() {
    
    if (!isDrawn) return;  
  
    //reached edge, reverse
    //if (posX 
    
    if (dir) {
      if (posX <= -100) //reached edge, reverse
      dir = !dir;
      else
        posX -= speed;
    }
    else 
    {      
      if (posX >= width + 100) //reached edge, reverse
        dir = !dir;
      else
        posX += speed;      
    }
    
    if ( boxX < posX + collideX/2 && boxX > posX - collideX/2 && boxY < posY + collideY/2 && boxY > posY - collideY/2) 
    {
     if (evil)
     {
//      println("Lost Health!");
      health--;
     }
     else 
     {
//      println("Bonus Point!");       
      bonus++;
     }
     isDrawn = false;
//     this = null;
    }
    
    //println ("boxX: " + boxX + "/boxY :" + boxY + "|posX: " + posX + "/posY: " + posY);
    
  }
  
  void draw() {
    //println("cloud draw"); 
   if (cloudshape == null) return; 
    if (isDrawn) shape(cloudshape, -185, -80, 370*scaleFactor, 190*scaleFactor); //changed to half size   
    //rect(0,0, collideX, collideY);   

  }
}
