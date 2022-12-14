import peasy.*;

Table data;
String photos_folder;
PImage[] photos = new PImage[12865];
PShape[] shapes = new PShape[12865];
int number_of_photos = 4000;


PeasyCam cam;

void setup() {
  size(1080, 720, P3D);
  
  
  data = loadTable("3d.csv", "header");

  photos_folder = "photos/thumbs/";

  //println(data.getRowCount() + " total rows in table");
 
   int count=0;
 
  for (TableRow row : data.rows())  {
     count++;
     //if (count==100)
     //  break;
     if (count!=0) { // diffe 
     
       String image_path = photos_folder+row.getString("filename").substring(7);
       
       photos[count-1] = loadImage (image_path);
       shapes[count-1] = createShape(RECT, 0,0,photos[count-1].width, photos[count-1].height);
       shapes[count-1].setTexture(photos[count-1]);
       //println (image_path);
     }
 
 }
 
 setupcam ();
 registerMethod("keyEvent", this);
 println("done loading "+str(count)+" features");
 
}

void draw() {
  background(0);
  updateCam();
  translate(width/2, height/2);
  pushMatrix();
  for (int i=1;i<number_of_photos;i++) 
    drawShape(i);
  popMatrix();
  println (cam.getDistance());  // current distance
  println (str(cam.getLookAt()[0])+" "+str(cam.getLookAt()[1])+" "+str(cam.getLookAt()[2]));  
  println (str(cam.getPosition()[0])+" "+str(cam.getPosition()[1])+" "+str(cam.getPosition()[2]));  
  println(cam.getWheelScale());
}
void drawShape(int i) {
  pushStyle();
  pushMatrix();
  TableRow row = data.getRow(i);
  translate(row.getFloat("x")*0.5, row.getFloat("y")*0.5, row.getFloat("z")*0.5);
  //rotateX(rot.x);
  //rotateY(rot.y);
  //rotateZ(rot.z);
  //scale(shapeScale);

  shape(shapes[i]);

  //box(5);

  popMatrix();
  popStyle();
}

void setupcam () {
  //hint(ENABLE_STROKE_PERSPECTIVE);
  float fov      = PI/3;  // field of view
  float nearClip = 1;
  float farClip  = 100000;
  float aspect   = float(width)/float(height);  
  perspective(fov, aspect, nearClip, farClip);  
  //cam = new PeasyCam(this, 400);
  cam = new PeasyCam (this, 400);
  cam.setWheelScale(5.0); 
  TableRow row = data.getRow(1);
  cam.lookAt(row.getFloat("x")*0.5, row.getFloat("y")*0.5,0.0);
}

void updateCam () {
  //----- perspective -----
  float fov      = PI/3;  // field of view
  float nearClip = 1;
  float farClip  = 100000;
  float aspect   = float(width)/float(height);  
  perspective(fov, aspect, nearClip, farClip);
}

void keyEvent(KeyEvent event) {
  // Navigation keys
  switch(event.getKey()) {
  case'c':
     cam.setWheelScale(10.0); 
     break;
  case'x':
     cam.setWheelScale(5.0); 
     break;
  case'z':
     cam.setWheelScale(1.0);
     break;
  }
  
}
