boolean drawGUI = false;

void initGUI() {
  cp5 = new ControlP5(this);
  //Button b = cp5.addButton("toggleBox", 1, 20, 20, 100, 20);
  //b.setLabel("Toggle Box");
  int margin = 20;
  int padding = 10;
  int w = 200;
  int bw = 50;
  int h = 20;
  int y0 = margin;
  String[] sliders = {};
  textFont(createFont("", 30));
  //cp5.addButton("button", 10, 100, 60, 80, 20).setId(1);
  //cp5.addButton("buttonValue", 4, 100, 90, 80, 20).setId(2);

  cp5.addSlider("coneBottom", -1000, 1000).setValue(CONE_BOTTOM).setHeight(h).setWidth(w).setPosition(margin, y0);
  y0 += h + padding;
  cp5.addSlider("coneHeight", 0, 4000).setValue(CONE_HEIGHT).setHeight(h).setWidth(w).setPosition(margin, y0);
  y0 += h + padding;
  cp5.addSlider("coneRadiusTop", 0, 1000).setValue(CONE_RADIUS_TOP).setHeight(h).setWidth(w).setPosition(margin, y0);
  y0 += h + padding;
  cp5.addSlider("coneRadiusBottom", 0, 1000).setValue(CONE_RADIUS_BOTTOM).setHeight(h).setWidth(w).setPosition(margin, y0);
  y0 += h + padding;
  cp5.addSlider("aperture", 0, 2).setValue(APERTURE).setHeight(h).setWidth(w).setPosition(margin, y0);
  y0 += h + padding;
  cp5.addSlider("coneOrientation", 0, 360).setValue(CONE_ORIENTATION).setHeight(h).setWidth(w).setPosition(margin, y0);
  y0 += h + padding;
  cp5.addButton("nextImage").setHeight(h).setWidth(bw).setPosition(margin, y0);
  y0 += h + padding;
  cp5.addButton("prevImage").setHeight(h).setWidth(bw).setPosition(margin, y0);
  y0 += h + padding;
  cp5.addButton("saveConfig").setHeight(h).setWidth(bw).setPosition(margin, y0);

  cp5.setAutoDraw(false);
}

void coneBottom(float f) {
  CONE_BOTTOM = f;
  myConfig.setImageParam(myImgHandler.currentImgIndex, "cone_bottom", f);
}

void coneHeight(float f) {
  CONE_HEIGHT = f;
  myConfig.setImageParam(myImgHandler.currentImgIndex, "cone_height", f);
}

void coneRadiusTop(float f) {
  CONE_RADIUS_TOP = f;
  myConfig.setImageParam(myImgHandler.currentImgIndex, "cone_radius_top", f);
}

void coneRadiusBottom(float f) {
  CONE_RADIUS_BOTTOM = f;
  myConfig.setImageParam(myImgHandler.currentImgIndex, "cone_radius_bottom", f);
}

void aperture(float f) {
  APERTURE = f;
  myConfig.setImageParam(myImgHandler.currentImgIndex, "aperture", f);
}
void coneOrientation(float f) {
  CONE_ORIENTATION = f;
  myConfig.setImageParam(myImgHandler.currentImgIndex, "cone_orientation", f);
}

void prevImage() {
  //img = myImgHandler.getPrevImage();
  myImgHandler.prevImage();
//  updateCanvas(img);
  updateGui();
  BG_COLOR = myImgHandler.getBackgroundColor();
  /*
  try {
   mesh.setTexture(loadImage(images.get(currentImage)));
   } 
   catch (Exception e) {
   }
   */
}

void nextImage() {
  //img = myImgHandler.getNextImage();
  myImgHandler.nextImage();
 // updateCanvas(img);
  updateGui();
  BG_COLOR = myImgHandler.getBackgroundColor();
  /*
  try {
   mesh.setTexture(loadImage(images.get(currentImage)));
   } 
   catch (Exception e) {
   }
   */
}

void saveConfig() {
  myConfig.saveData();
}

void updateGui() {
  cp5.get("coneBottom").setValue(myConfig.getImageParam(myImgHandler.currentImgIndex, "cone_bottom"));
  cp5.get("coneHeight").setValue(myConfig.getImageParam(myImgHandler.currentImgIndex, "cone_height"));
  cp5.get("coneRadiusTop").setValue(myConfig.getImageParam(myImgHandler.currentImgIndex, "cone_radius_top"));
  cp5.get("coneRadiusBottom").setValue(myConfig.getImageParam(myImgHandler.currentImgIndex, "cone_radius_bottom"));
  cp5.get("aperture").setValue(myConfig.getImageParam(myImgHandler.currentImgIndex, "aperture"));
  cp5.get("coneOrientation").setValue(myConfig.getImageParam(myImgHandler.currentImgIndex, "cone_orientation"));
}  


void drawGUI() {
  hint(DISABLE_DEPTH_TEST);
  camera();
  if (drawGUI) {
    cp5.draw();
    coneInfo.display();
  } 
  hint(ENABLE_DEPTH_TEST);
}
