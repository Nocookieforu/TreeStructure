int high, wide;
Node root;

void setup() {
  high = 1000;
  wide = 1500;
  size(wide,high);
  colorMode(HSB,256);
  background(0,0,256);
  strokeWeight(1);
  stroke(0,0,0);
  fill(0,0,0);
  smooth();
}

void draw() {
  frame.setTitle(int(frameRate) + " fps");
}

void mousePressed() {
  // Clear window and generate a new tree from the mouse position
  //background(0,0,256);
  root = new Node(mouseX,mouseY,null,0);
  root.render();
}

void keyPressed() {
  String timestamp = year() + nf(month(),2) + nf(day(),2) 
    + "-"  + nf(hour(),2) + "h" + nf(minute(),2) + "m" + nf(second(),2) + "s";
  //println(timestamp);
  //save("TreeBranches" + timestamp + ".jpg");
  background(0,0,256);
}

private class Node {
  
  // Depth of the Node
  private int tier;
  // List of the children of the Node
  private ArrayList<Node> children;
  // Parent of the Node
  private Node parent;
  // x and y values of the nodef
  private float x, y;
  // The maximum depth of the tree
  // Created in order to limit random generation of tree
  private final int maxTier = 7;
  
  // Constructor for the tree
  // Should only be called once for the root. The rest of the 
  // tree will be generated underneath the root.
  public Node(float xVal, float yVal, Node parent, int tier) {
    this.x = xVal;
    this.y = yVal;
    this.parent = parent;
    this.children = new ArrayList<Node>(3);
    this.tier = tier;
    //println("Created Node with tier " + tier);
    if (tier < maxTier) {
      createChildren();
    }
  }
  
  // Creates a random number of children with random positions
  int createChildren() {
    // Because the maximum number of children is the higher limit of this function
    // raised to the number of tiers, this function is scaled with negative
    // exponential decay
    int numChildren = round(random(0,ceil(float(10)/(1*tier+1))));
    //println("  Created " + numChildren + " children with tier " + (tier + 1));
    for (int i = 0; i < numChildren; i++) {
      // Create all the children from random r, theta
      // Scale r with tier
      float radius = random(200/(.75*tier+1),500/(.9*tier+1));
      float theta = random(0,2*PI);
      
      // This code not quite working yet.
      //theta = (3*theta + direct(force(new PVector(this.x, this.y)).normalize(null)))/4;
      
      PVector newPos = new PVector(radius*cos(theta)+x,radius*sin(theta)+y);
      if (newPos.x < 0) {
        newPos.x = 0;
      }else if (newPos.x > wide) {
        newPos.x = wide;
      }
      if (newPos.y < 0) {
        newPos.y = 0; 
      }else if (newPos.y > high) {
        newPos.y = high; 
      }
      // Assign them with this as parent and one higher tier
      children.add(new Node(newPos.x, 
                            newPos.y,
                            this, (this.tier+1)));
    }
    return numChildren;
  }
  
  // This fuction provides a centering force that gets very 
  // strong near the edge of the window in order to keep the
  // points in the window
  PVector force(PVector point) {
    //Megan says they should be free.
    return new PVector( - pow((point.x - wide/2) * 4.5/wide,5),
                        - pow((point.y - high/2) * 4.5/high,5) );
  }
  
  // Returns the heading of the vector direction.
  // PVector.heading() doesn't work for this editon
  float direct(PVector direction) {
    PVector xHat = new PVector(1,0);
    return acos(xHat.dot(direction)/direction.mag());
  }
  
  // Draws the tree in the window recursively
  void render() {
    // Render lowest Nodes first 
    for (int i = 0; i < children.size(); i++) {
      children.get(i).render(); 
    }
    stroke(0,110,tier*256/maxTier);
    fill(0,110,tier*250/maxTier);    
    ellipse(x,y,ceil(float(20)/(tier+1)),ceil(float(20)/(tier+1)));
    // Draw a line from this Node to its parent
    if (parent != null) {
      line(x,y,parent.getX(), parent.getY());
    }
  } 
  
  // Return x value of this node
  float getX() {
    return this.x;
  }
  
  // Return y value of this node
  float getY() {
    return this.y;
  }
}

