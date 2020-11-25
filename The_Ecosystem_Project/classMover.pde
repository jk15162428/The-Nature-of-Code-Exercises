// author: Utopia

class Mover {
  
    // the basic attributes
    int kind;  // this shows what animal it is.
    int size;  // this shows how big the animal is.
    PVector position;
    PVector velocity;
    PVector acceleration;
    PVector wind;  // for snakes
    float topSpeed;
    
    // the default constructor, just trash.
    Mover() {
        position = new PVector(random(width), random(height));
        velocity = new PVector(0, 0);
        kind = -1;  // it's not animal at all.
        topSpeed = 5;
        size = 0;  // of course no size.
    }
    
    Mover(int _kind) {
      
        kind = _kind;
        velocity = new PVector(random(-0.1, 0.1), random(-0.1, 0.1));
        acceleration = new PVector(random(-0.1, 0.1), random(-0.1, 0.1)); 
        wind = new PVector(random(1000),random(1000));
        
        switch(kind){
           // 0 means fly, 1 means snake, 2 means fish, 3 means bird.
           case 0:  // fly
               position = new PVector(random(width/8, width/2), random(height/8, height/2));
               topSpeed = 0.5;
               size = 2;
               break;
           case 1:  // snake
               position = new PVector(random(width/2, 7*width/8), random(height/2, 7*height/8));
               topSpeed = 3;
               size = 15;
               break;
           case 2:  // fish
               position = new PVector(random(width/8, width/2), random(height/2, 7*height/8));
               topSpeed = 5;
               size = 50;
               break;
           case 3:  // bird
               position = new PVector(random(width/2, 7*width/8), random(height/8, height/2));
               topSpeed = 4;
               size = 30;
               break;
        }
    }
    
    void update(int _kind) {

        float ax, ay;
        PVector temp;
        
        switch(_kind){
           // 0 means fly, 1 means snake, 2 means fish, 3 means bird.
           case 0:  // fly - almost random
               if(acceleration.x >= 0) {
                   ax = random(-0.3, 0.7);
               } else ax = random(-0.7, 0.3);
               if(acceleration.y >= 0) {
                   ay = random(-0.4, 0.6);   
               } else ay = random(-0.6, 0.4);
               acceleration = new PVector(ax, ay);
               velocity.add(acceleration);
               velocity.limit(topSpeed);
               position.add(velocity);
               break;
           case 1:  // snake - winding
               // they are g
               while(velocity.x == 0) velocity.x = random(-0.2,0.2);
               while(velocity.y == 0) velocity.y = random(-0.2,0.2);
               if(position.x<size+10 || position.x>width-10-size)
                   acceleration.x = width/2-position.x;
               else acceleration.x = random(velocity.x/30);
               if(position.y<size+5 || position.y>height-size-5)
                   acceleration.y = height/2-position.y;
               acceleration.y *= random(0.9, 1.2);
               if(velocity.y >= 1 || velocity.y <= -1) {
                   acceleration.y = random(-velocity.y/8, -velocity.y/16);
               }
               if(velocity.x >= 1) velocity.x -= 0.1;
               else if(velocity.x <= -1) velocity.x += 0.1;
               velocity.add(acceleration);
               velocity.limit(topSpeed);
               position.add(velocity);
               break;
           case 2:  // fish - faster and faster until reaching the max
              if(acceleration.x >= 0) {
                   ax = random(0.4);
               } else ax = random(-0.4, 0);
               if(acceleration.y >= 0) {
                   ay = random(0.4);   
               } else ay = random(-0.4, 0);
               temp = new PVector(ax, ay);
               acceleration.add(temp);
               velocity.add(acceleration);
               velocity.limit(topSpeed);
               position.add(velocity);
               break;
           case 3:  // bird
               temp = new PVector(mouseX-position.x, mouseY-position.y);
               float dis = dist(mouseX, position.x, mouseY, position.y);
               temp.normalize();
               if(dis > 1.5) dis = 1.5;
               temp.mult(dis);
               acceleration.add(temp);
               velocity.add(acceleration);
               velocity.limit(topSpeed);
               position.add(velocity);
               break;
        }
    }
      
    void checkEdges() {
        boolean flag = false;
        if (position.x + size/2 > width) {
            flag = true;
        } 
        else if (position.x - size/2 < 0) {
            flag = true;
        }
    
        if (position.y + size/2 > height) {
            flag = true;
        } 
        else if (position.y - size/2 < 0) {
            flag = true;
        }
        if(flag) {
            velocity.x = -velocity.x;
            velocity.y = -velocity.y;
            acceleration.x = -acceleration.x/2;
            acceleration.y = -acceleration.y/2;
            position.add(velocity);
        }   
    }
    
    void checkCollision() {
        
        for(int i = 0; i < movers.length; i++) check[i] = 0;
        for(int j = 0; j < movers.length; j++) {
            if(check[j] == 1 || movers[j].position.x == position.x) continue; // it's itself.s or have checked.
            int Size = (size + movers[j].size + 1)/ 2;
            if(dist(position.x, position.y, movers[j].position.x, movers[j].position.y) <= Size) {
                // collision makes the kinetic energy loss.
                velocity.x = -velocity.x;
                velocity.y = -velocity.y;
                movers[j].velocity.x = -movers[j].velocity.x;
                movers[j].velocity.y = -movers[j].velocity.y;
                acceleration.x = -acceleration.x/2;
                acceleration.y = -acceleration.y/2;
                movers[j].acceleration.x = -movers[j].acceleration.x/2;
                movers[j].acceleration.y = -movers[j].acceleration.y/2;
                position.add(velocity);
                movers[j].position.add(movers[j].velocity);
            }
        }
    }
    
    void display() {
        stroke(0);
        strokeWeight(2);
        fill(127,200);
        ellipse(position.x, position.y, size, size);
    }
}
