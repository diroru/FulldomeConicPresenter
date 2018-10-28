class StateManager { //<>// //<>//
  PresenterConfiguration myConfig;
  float transitionPhase = 0;
  JSONObject currentState, nextState;
  int currentStateIndex = 0, nextStateIndex = 0;
  Ani transitionAni;
  boolean scheduleStateChange = false;
  boolean inStateChange = false;
  boolean stateChangeFinished = false;
  int stateCount = 0;
  PImage currentImage, nextImage;

  StateManager(PresenterConfiguration config) {
    myConfig = config;
    stateCount = config.imageConfig.size();
    transitionAni = new Ani(this, myConfig.getDuration(), 0, "transitionPhase", 1, Ani.LINEAR, "onEnd:transitionEnd");
    transitionAni.end();
    transitionPhase = 0;
    currentImage = loadImage(myConfig.imageConfig.getJSONObject(0).getString("path"));
    currentState = myConfig.imageConfig.getJSONObject(0);
    println(currentState);
  }

  void nextState() {
    if (!(scheduleStateChange || inStateChange)) {
      nextStateIndex = (currentStateIndex + 1) % stateCount;
      nextState = myConfig.imageConfig.getJSONObject(nextStateIndex);
      nextImage = getImage(nextStateIndex);
      scheduleStateChange = true;
      inStateChange = false;
      stateChangeFinished = false;
      //updateStatesAndImages();
    }
  }

  void previousState() {
    if (!(scheduleStateChange || inStateChange)) {
      nextStateIndex = (currentStateIndex + stateCount - 1) % stateCount;
      nextState = myConfig.imageConfig.getJSONObject(nextStateIndex);
      nextImage = getImage(nextStateIndex);
      scheduleStateChange = true;
      inStateChange = false;
      stateChangeFinished = false;
      //updateStatesAndImages();
    }
  }

  /*
  void updateStatesAndImages() {
   if (inStateChange) {
   //transitionEnd();
   transitionAni.seek(1f);
   transitionAni.end();
   }
   scheduleStateChange = true;
   if (nextState != null) {
   currentState = nextState;
   }
   if (nextImage != null) {
   currentImage = nextImage;
   }
   nextState = myConfig.imageConfig.getJSONObject(nextStateIndex);
   nextImage = getImage(nextStateIndex);
   }
   */

  void draw(PGraphics canvas) {
    if (scheduleStateChange && nextImage.width > 0 && currentImage.width > 0) {
      println("transition scheduled");
      /*
      if (transitionAni != null && transitionAni.isPlaying()) {
       transitionAni.end();
       }
       */
      transitionPhase = 0;
      //transitionAni = new Ani(this, 2, 0, "transitionAlpha", 255, Ani.LINEAR, "onEnd:transitionEnd");
      transitionAni.start();
      scheduleStateChange = false;
      stateChangeFinished = false;
      inStateChange = true;
      println(myConfig.imageConfig.getJSONObject(currentStateIndex).getFloat("cone_orientation"), "->", myConfig.imageConfig.getJSONObject(nextStateIndex).getFloat("cone_orientation"));
      println(currentStateIndex, "->", nextStateIndex);
    }
    fitImage(canvas, currentImage, 255);
    if (inStateChange) {
      fitImage(canvas, nextImage, getAlpha());
      //updateGui();
    }
    if (inStateChange && stateChangeFinished) {
      scheduleStateChange = false;
      inStateChange = false;
      stateChangeFinished = false;

      currentStateIndex = nextStateIndex;
      currentImage = nextImage;
      currentState = myConfig.imageConfig.getJSONObject(nextStateIndex);
      transitionPhase = 0;
      updateGui();
      println(currentState.getFloat("cone_orientation"));
      println("DRAW: state change finished");
    }
  }

  float currentValue(String name, float f) {
    float v0 = currentState.getFloat(name);
    float v1 = currentState.getFloat(name);
    if (nextState != null) {
      v1 = nextState.getFloat(name);
    }
    return lerp(v0, v1, f);
  }

  float currentValue(String name) {
    return currentValue(name, transitionPhase);
  }

  float getAlpha() {
    return transitionPhase * 255;
  }

  float getConeBottom() {
    return getConeBottom(transitionPhase);
  }

  float getConeRadiusTop() {
    return getConeRadiusTop(transitionPhase);
  }

  float getConeRadiusBottom() {
    return getConeRadiusBottom(transitionPhase);
  }

  float getConeOrientation() {
    return getConeOrientation(transitionPhase);
  }

  float getConeHeight() {
    return getConeHeight(transitionPhase);
  }

  float getAperture() {
    return getAperture(transitionPhase);
  }

  int getBackgroundColor() {
    return getBackgroundColor(transitionPhase);
  }

  int getBackgroundColor(float f) {
    color currentColor = currentImage.get(0,0);
    color nextColor = currentColor;
    if (nextImage != null) {
      nextColor = nextImage.get(0,0);
    }
    return lerpColor(currentColor, nextColor, f);
  }

  float getConeBottom(float f) {
    return currentValue("cone_bottom", f);
  }

  float getConeRadiusTop(float f) {
    return currentValue("cone_radius_top", f);
  }

  float getConeRadiusBottom(float f) {
    return currentValue("cone_radius_bottom", f);
  }

  float getConeOrientation(float f) {
    return currentValue("cone_orientation", f);
  }

  float getConeHeight(float f) {
    return currentValue("cone_height", f);
  }

  float getAperture(float f) {
    return currentValue("aperture", f);
  }


  void transitionEnd() {
    /*
    scheduleStateChange = false;
     inStateChange = false;
     currentStateIndex = nextStateIndex;
     currentImage = nextImage;
     currentState = nextState;
     transitionPhase = 0;
     */
    stateChangeFinished = true;
    println("state change finished");
  }


  PImage getImage(int index) {
    return requestImage(myConfig.imageConfig.getJSONObject(index).getString("path"));
  }

  float getPointerSize() {
    float h0 = currentImage.height;
    float h = h0;
    if (nextImage != null && nextImage.height > 0) {
      float h1 = nextImage.height;
      h = lerp(h0, h1, transitionPhase);
    }
    return h / height * myConfig.getPointerSize();
  }

  void fitImage(PGraphics canvas, PImage img, float alpha) {
    float s = max(float(canvas.width)/img.width, float(canvas.height)/img.height);
    canvas.tint(255, alpha);
    canvas.image(img, 0, 0, img.width*s, img.height*s);
  }
}

/*
class State {
 JSONObject myData;
 
 State(JSONObject theData) {
 myData = theData;
 }
 
 String getImagePath() {
 return myData.getString("path");
 }
 
 float getConeBottom() {
 return myData.getFloat("cone_bottom");
 }
 
 float getConeRadiusTop() {
 return myData.getFloat("cone_radius_top");
 }
 
 float getConeRadiusBottom() {
 return myData.getFloat("cone_radius_bottom");
 }
 
 float getConeOrientation() {
 return myData.getFloat("cone_orientation");
 }
 
 float getAperture() {
 return myData.getFloat("aperture");
 }
 }
 */
