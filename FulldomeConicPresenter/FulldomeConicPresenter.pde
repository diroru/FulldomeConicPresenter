//TODO: settings in config file!!!
import controlP5.*;
import java.util.Collections;

PShader domeShader;
PShape domeQuad;

final int FULLDOME_MODE = 0;
final int CANVAS_MODE = 1;

PGraphics canvas;
ConicMeshInfo coneInfo;

float APERTURE = 1f;
float CONE_RADIUS_BOTTOM = 512;
float CONE_RADIUS_TOP = 512;
float CONE_HEIGHT = 512;
float CONE_BOTTOM = 0;
float CONE_ORIENTATION = 0;

PImage img;

ControlP5 cp5;
ImageHandler myImgHandler;
PresenterConfiguration myConfig;
color BG_COLOR = color(0);
color pointerColor;
boolean showCursor = true;

/*TODO:
 - image handling
 - background color
 - smoothing
 - usage documentation
 - fitting options
 – config 
 – transition 
 - scale cursor
 */

void setup() {
  size(512, 512, P3D);
  pixelDensity(displayDensity());

  myImgHandler = new ImageHandler("images");

  img = myImgHandler.currentImg;
  BG_COLOR = myImgHandler.getBackgroundColor();

  myConfig = new PresenterConfiguration("config.json", myImgHandler);

  surface.setResizable(true);
  surface.setSize(myConfig.getDomeSize(), myConfig.getDomeSize());
  surface.setResizable(false);

  coneInfo = new ConicMeshInfo(width/2, height/2);
  pointerColor = unhex(myConfig.getPointerColor());

  domeShader = loadShader("glsl/fulldomeCone.frag", "glsl/fulldomeCone.vert");
  updateShader();

  canvas = createGraphics(myConfig.getCanvasSize(), myConfig.getCanvasSize()/2, P2D);

  domeShader.set("canvas", canvas);
  //updateCanvas(img);

  initShape();

  APERTURE = myConfig.getImageParam(myImgHandler.currentImgIndex, "aperture");
  CONE_RADIUS_BOTTOM = myConfig.getImageParam(myImgHandler.currentImgIndex, "cone_radius_bottom");
  CONE_RADIUS_TOP = myConfig.getImageParam(myImgHandler.currentImgIndex, "cone_radius_top");
  CONE_HEIGHT = myConfig.getImageParam(myImgHandler.currentImgIndex, "cone_height");
  CONE_BOTTOM = myConfig.getImageParam(myImgHandler.currentImgIndex, "cone_bottom");
  CONE_ORIENTATION = myConfig.getImageParam(myImgHandler.currentImgIndex, "cone_orientation");
  initGUI();
}

void draw() {
  PVector mm = mappedMouse(FULLDOME_MODE);

  background(BG_COLOR);
  float pointerSize = myConfig.getPointerSize() * img.height / float(height);

  canvas.beginDraw();
  canvas.background(BG_COLOR);
  fitImage(canvas, img);
  canvas.ellipseMode(RADIUS);
  canvas.noStroke();
  canvas.fill(pointerColor);
  canvas.ellipse(mm.x, mm.y, pointerSize, pointerSize);
  canvas.ellipse(mm.x + canvas.width, mm.y, pointerSize, pointerSize);
  canvas.endDraw();
  //image(canvas,0,0, canvasToWindowRatio() * canvas.width, canvasToWindowRatio() * canvas.height );
  //CONE_ORIENTATION = frameCount/10000f;
  //CONE_RADIUS_BOTTOM = mouseY + 0f;
  //CONE_RADIUS_TOP = mouseX + 0f;
  //CONE_BOTTOM = mouseY - height*0.5;
  updateShader();
  pushMatrix();
  translate(width*0.5, height*0.5);
  shader(domeShader);
  shape(domeQuad);
  resetShader();
  popMatrix();

  drawGUI();
}

void updateShader() {
  domeShader.set("aperture", APERTURE);
  domeShader.set("radiusBottom", CONE_RADIUS_BOTTOM);
  domeShader.set("radiusTop", CONE_RADIUS_TOP);
  domeShader.set("coneBottom", CONE_BOTTOM);
  domeShader.set("coneHeight", CONE_HEIGHT);
  domeShader.set("coneOrientation", CONE_ORIENTATION);
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  //CONE_HEIGHT = floor(constrain(CONE_HEIGHT+ e,0,4096));
}

void mouseDragged() {
  PVector dm = new PVector(pmouseX - mouseX, pmouseY - mouseY);
  PVector radial = new PVector(mouseX - width/2, mouseY - height/2);
  radial.normalize();
  PVector tangential = radial.copy();
  tangential.rotate(HALF_PI);
  tangential.normalize();
  
  float radComponent = dm.dot(radial);
  float tanComponent = dm.dot(tangential);
  println(radComponent, tanComponent);
   
  int dmy = (pmouseY - mouseY);
  int dmx = (pmouseX - mouseX);
  if (abs(radComponent) > abs(tanComponent)) {
    coneBottom(CONE_BOTTOM + radComponent);
  } else {
    coneOrientation(CONE_ORIENTATION - map(-tanComponent, 0, width / 4, 0, 45));
  }  
  updateGui();
  //CONE_ORIENTATION += map((pmouseX - mouseX), 0, width / 4, 0, 0.25);
  //CONE_BOTTOM = constrain(CONE_BOTTOM, -2048, 2048);
}

void keyPressed() {
  switch(key) {
  case 'G':
  case 'g':
    drawGUI = !drawGUI;
    break;
  case 'C':
  case 'c':
    showCursor = !showCursor;
    if(showCursor) {
      cursor();
    } else {
      noCursor();
    }
    break;
  case ' ':
    nextImage();
    break;
  }
}

/*
void updateCanvas(PImage img) {
 canvas = createGraphics(img.width, img.height, P2D);
 println("w", img.width, "h", img.height);
 
 //canvas.beginDraw();
 //canvas.background(0);
 //canvas.image(img, 0, 0);
 //canvas.endDraw();
 
 domeShader.set("canvas", canvas);
 }
 */

void initShape() {
  domeQuad = createShape();
  domeQuad.beginShape();
  domeQuad.fill(255, 255, 0);
  domeQuad.textureMode(NORMAL);
  domeQuad.noStroke();
  domeQuad.vertex(-width * 0.5f, -height * 0.5f, 0, 1, 1);
  domeQuad.vertex(width * 0.5f, -height * 0.5f, 0, 0, 1);
  domeQuad.vertex(width * 0.5f, height * 0.5f, 0, 0, 0);
  domeQuad.vertex(-width * 0.5f, height * 0.5f, 0, 1, 0);
  domeQuad.endShape();
}

void fitImage(PGraphics canvas, PImage img) {
  float s = max(float(canvas.width)/img.width, float(canvas.height)/img.height);
  canvas.image(img, 0, 0, img.width*s, img.height*s);
}

void mouseMoved() {
  PVector mm = mappedMouse(FULLDOME_MODE);
  //println(mm.x, mm.y);
}
