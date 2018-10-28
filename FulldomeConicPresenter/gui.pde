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

  cp5.addSlider("coneBottom", -1000, 1000).setValue(myStateManager.getConeBottom()).setHeight(h).setWidth(w).setPosition(margin, y0);
  y0 += h + padding;
  cp5.addSlider("coneHeight", 0, 4000).setValue(myStateManager.getConeHeight()).setHeight(h).setWidth(w).setPosition(margin, y0);
  y0 += h + padding;
  cp5.addSlider("coneRadiusTop", 0, 1000).setValue(myStateManager.getConeRadiusTop()).setHeight(h).setWidth(w).setPosition(margin, y0);
  y0 += h + padding;
  cp5.addSlider("coneRadiusBottom", 0, 1000).setValue(myStateManager.getConeRadiusBottom()).setHeight(h).setWidth(w).setPosition(margin, y0);
  y0 += h + padding;
  cp5.addSlider("aperture", 0, 2).setValue(myStateManager.getAperture()).setHeight(h).setWidth(w).setPosition(margin, y0);
  y0 += h + padding;
  cp5.addSlider("coneOrientation", 0, 360).setValue(myStateManager.getConeOrientation()).setHeight(h).setWidth(w).setPosition(margin, y0);
  y0 += h + padding;
  cp5.addButton("nextImage").setHeight(h).setWidth(bw).setPosition(margin, y0);
  y0 += h + padding;
  cp5.addButton("prevImage").setHeight(h).setWidth(bw).setPosition(margin, y0);
  y0 += h + padding;
  cp5.addButton("saveConfig").setHeight(h).setWidth(bw).setPosition(margin, y0);

  cp5.setAutoDraw(false);
}

void coneBottom(float f) {
  myConfig.setImageParam(myStateManager.currentStateIndex, "cone_bottom", f);
}

void coneHeight(float f) {
  myConfig.setImageParam(myStateManager.currentStateIndex, "cone_height", f);
}

void coneRadiusTop(float f) {
  myConfig.setImageParam(myStateManager.currentStateIndex, "cone_radius_top", f);
}

void coneRadiusBottom(float f) {
  myConfig.setImageParam(myStateManager.currentStateIndex, "cone_radius_bottom", f);
}

void aperture(float f) {
  myConfig.setImageParam(myStateManager.currentStateIndex, "aperture", f);
}
void coneOrientation(float f) {
  myConfig.setImageParam(myStateManager.currentStateIndex, "cone_orientation", f);
}

void prevImage() {
  //img = myImgHandler.getPrevImage();
  //myImgHandler.prevImage();
  //  updateCanvas(img);

  myStateManager.previousState();
  //updateGui();
  //BG_COLOR = myImgHandler.getBackgroundColor();
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

  myStateManager.nextState();
  //updateGui();
  //myImgHandler.nextImage();
  // updateCanvas(img);

  //BG_COLOR = myImgHandler.getBackgroundColor();
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
  cp5.get("coneBottom").setValue(myStateManager.getConeBottom());
  cp5.get("coneHeight").setValue(myStateManager.getConeHeight());
  cp5.get("coneRadiusTop").setValue(myStateManager.getConeRadiusTop());
  cp5.get("coneRadiusBottom").setValue(myStateManager.getConeRadiusBottom());
  cp5.get("aperture").setValue(myStateManager.getAperture());
  cp5.get("coneOrientation").setValue(myStateManager.getConeOrientation());
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
