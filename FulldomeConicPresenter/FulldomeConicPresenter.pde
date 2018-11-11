//TODO: settings in config file!!!
import controlP5.*;
import java.util.Collections;
import de.looksgood.ani.*;

PShader domeShader;
PShader transitionShader;
PShape domeQuad, coneQuad;

final int FULLDOME_MODE = 0;
final int CANVAS_MODE = 1;

PGraphics canvas;
ConicMeshInfo coneInfo;

/*
float APERTURE = 1f;
 float CONE_RADIUS_BOTTOM = 512;
 float CONE_RADIUS_TOP = 512;
 float CONE_HEIGHT = 512;
 float CONE_BOTTOM = 0;
 float CONE_ORIENTATION = 0;
 */

//PImage img;

ControlP5 cp5;
ImageHandler myImageHandler;
StateManager myStateManager;
PresenterConfiguration myConfig;
//color BG_COLOR = color(0);
color pointerColor;
boolean showCursor = true;

/*TODO
 - usage documentation
 */

void setup() {
  size(512, 512, P3D);
  pixelDensity(displayDensity());
  Ani.init(this);

  myImageHandler = new ImageHandler("images");
  myConfig = new PresenterConfiguration("config.json", "images.json", myImageHandler);
  myStateManager = new StateManager(myConfig);

  //img = myImgHandler.currentImg;
  //BG_COLOR = myImgHandler.getBackgroundColor();

  surface.setResizable(true);
  surface.setSize(myConfig.getDomeSize(), myConfig.getDomeSize());
  surface.setResizable(false);

  coneInfo = new ConicMeshInfo(myConfig.getInfoSize(), myConfig.getInfoSize(), myStateManager);
  pointerColor = unhex(myConfig.getPointerColor());

  domeShader = loadShader("glsl/fulldomeCone.frag", "glsl/fulldomeCone.vert");
  transitionShader = loadShader("glsl/crossFade.frag", "glsl/crossFade.vert"); 
  updateShader();

  canvas = createGraphics(myConfig.getCanvasSize(), myConfig.getCanvasSize()/2, P2D);

  domeShader.set("canvas", canvas);
  //updateCanvas(img);

  domeQuad = getShape(width, height);
  coneQuad = getShape(myConfig.getCanvasSize(), myConfig.getCanvasSize()/2);

  /*
  APERTURE = myConfig.getImageParam(myImgHandler.currentImgIndex, "aperture");
   CONE_RADIUS_BOTTOM = myConfig.getImageParam(myImgHandler.currentImgIndex, "cone_radius_bottom");
   CONE_RADIUS_TOP = myConfig.getImageParam(myImgHandler.currentImgIndex, "cone_radius_top");
   CONE_HEIGHT = myConfig.getImageParam(myImgHandler.currentImgIndex, "cone_height");
   CONE_BOTTOM = myConfig.getImageParam(myImgHandler.currentImgIndex, "cone_bottom");
   CONE_ORIENTATION = myConfig.getImageParam(myImgHandler.currentImgIndex, "cone_orientation");
   */
  initGUI();
}

void draw() {
  PVector mm = mappedMouse(FULLDOME_MODE);
  color backgroundColor = myStateManager.getBackgroundColor();
  background(backgroundColor);
  float pointerSize = myStateManager.getPointerSize();
  canvas.beginDraw();
  canvas.background(backgroundColor);
  canvas.pushMatrix();
  canvas.translate(canvas.width, 0);
  canvas.scale(-1, 1);
  myStateManager.draw(canvas);
  canvas.popMatrix();
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
  domeShader.set("aperture", myStateManager.getAperture());
  domeShader.set("radiusBottom", myStateManager.getConeRadiusBottom());
  domeShader.set("radiusTop", myStateManager.getConeRadiusTop());
  domeShader.set("coneBottom", myStateManager.getConeBottom());
  domeShader.set("coneHeight", myStateManager.getConeHeight());
  domeShader.set("coneOrientation", myStateManager.getConeOrientation());
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  //CONE_HEIGHT = floor(constrain(CONE_HEIGHT+ e,0,4096));
}

void mouseMoved() {

  //PVector mm = mappedMouse(FULLDOME_MODE);
  if (keyPressed && keyCode == SHIFT) {

    PVector dm = new PVector(pmouseX - mouseX, pmouseY - mouseY);
    PVector radial = new PVector(mouseX - width/2, mouseY - height/2);
    radial.normalize();
    PVector tangential = radial.copy();
    tangential.rotate(HALF_PI);
    tangential.normalize();

    float radComponent = dm.dot(radial);
    float tanComponent = dm.dot(tangential);
    //println(radComponent, tanComponent);

    int dmy = (pmouseY - mouseY);
    int dmx = (pmouseX - mouseX);
    if (abs(radComponent) > abs(tanComponent)) {
      coneBottom(myStateManager.getConeBottom() + radComponent);
    } else {
      coneOrientation(myStateManager.getConeOrientation() - map(-tanComponent, 0, width / 4, 0, 45));
    }  
    updateGui();
  }
}

void mouseDragged() {
  /*
  PVector dm = new PVector(pmouseX - mouseX, pmouseY - mouseY);
   PVector radial = new PVector(mouseX - width/2, mouseY - height/2);
   radial.normalize();
   PVector tangential = radial.copy();
   tangential.rotate(HALF_PI);
   tangential.normalize();
   
   float radComponent = dm.dot(radial);
   float tanComponent = dm.dot(tangential);
   //println(radComponent, tanComponent);
   
   int dmy = (pmouseY - mouseY);
   int dmx = (pmouseX - mouseX);
   if (abs(radComponent) > abs(tanComponent)) {
   coneBottom(CONE_BOTTOM + radComponent);
   } else {
   coneOrientation(CONE_ORIENTATION - map(-tanComponent, 0, width / 4, 0, 45));
   }  
   updateGui();
   */
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
    if (showCursor) {
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

PShape getShape(int w, int h) {
  PShape result = createShape();
  result.beginShape();
  result.fill(255, 255, 0);
  result.textureMode(NORMAL);
  result.noStroke();
  result.vertex(-w * 0.5f, -h * 0.5f, 0, 1, 1);
  result.vertex(w * 0.5f, -h * 0.5f, 0, 0, 1);
  result.vertex(w * 0.5f, h * 0.5f, 0, 0, 0);
  result.vertex(-w * 0.5f, h * 0.5f, 0, 1, 0);
  result.endShape();
  return result;
}


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
