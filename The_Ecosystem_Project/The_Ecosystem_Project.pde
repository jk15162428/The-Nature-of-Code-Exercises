/*
Develop a set of rules for simulating the real-world behavior of a creature, 
such as a nervous fly, swimming fish, hopping bunny, slithering snake, etc. 
Can you control the object’s motion by only manipulating the acceleration? 
Try to give the creature a personality through its behavior 
(rather than through its visual design).
*/

// author: Utopia

// warning: this project is very awful due to its bad implement 
// of collision clause, edgechecking, initialization, etc. 
// However, it doesn't matter, right? After all, it's the First Chapter.

Mover[] movers = new Mover[20];
int[] check = new int [20];

void setup() {
    size(1366,768);
    for (int i = 0; i < movers.length - 1; i++) {
        movers[i] = new Mover(int(2));  // animals are randomly generated, except flies, they are too small.
    }
    // but birds are not, because they are stupid, and will crash, so they almost die out.
    movers[movers.length - 1] = new Mover(3);
}

void draw() {
  
  background(255);

  for (int i = 0; i < movers.length; i++) {
    movers[i].update(movers[i].kind);
    movers[i].checkCollision();
    movers[i].checkEdges();
    movers[i].display();
  }
}
