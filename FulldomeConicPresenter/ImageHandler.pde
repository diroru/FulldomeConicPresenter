class ImageHandler {
  ArrayList<String> imagePaths = new ArrayList<String>();
  HashMap<String, String> imageNameMap  = new HashMap<String, String>();
  ArrayList<String> imageNames = new ArrayList<String>();

  PImage currentImg, nextImg;
  int currentImgIndex = 0;

  boolean scheduleTransition = false;
  boolean inTransition = false;
  float transitionAlpha = 0;

  Ani transitionAni;

  ImageHandler(String path) {
    loadImages(path);
    currentImg = getImage(currentImgIndex);
    //transitionAni = new Ani(this, 2, 0, "transitionAlpha", 255, Ani.LINEAR, "onEnd:transitionEnd");
  }

  void nextImage() {
    transitionEnd();
    currentImgIndex = (currentImgIndex + 1) %  imageNames.size();
    //currentImg = getImage(currentImgIndex);
    nextImg = getImage(currentImgIndex);
    scheduleTransition = true;
    /*
    if (transitionAni != null) {
      transitionAni.end();
    }
    */
    transitionShader.set("fadeFactor", 0.5f);
  }

  void prevImage() {
    transitionEnd();
    currentImgIndex = (currentImgIndex + imageNames.size() - 1) %  imageNames.size();
    //currentImg = getImage(currentImgIndex);
    nextImg = getImage(currentImgIndex);
    scheduleTransition = true;
    /*
    if (transitionAni != null) {
      transitionAni.end();
    }
    */
    transitionShader.set("fadeFactor", 0.5f);
  }

  PImage getImage(int index) {
    PImage result = null;
    int count = imageNames.size();
    while (index >= count) {
      index -= count;
    }
    while (index < 0) {
      index += count;
    }

    try {
      //println("getting", index);
      result = requestImage(imageNameMap.get(imageNames.get(index)));
    } 
    catch(Exception e) {
    }
    return result;
  }

  void loadImages(String path) {
    File folder = new File(dataPath(path));
    for (final File fileEntry : folder.listFiles()) {
      if (!fileEntry.isDirectory()) {
        String fileName = fileEntry.getName();
        if (!fileName.startsWith(".") && (fileName.endsWith("jpeg") ||  fileName.endsWith("jpg") || fileName.endsWith("png"))) {
          println(fileEntry.getAbsolutePath());
          imageNames.add(fileName);
          imageNameMap.put(fileName, fileEntry.getAbsolutePath());
          imagePaths.add(fileEntry.getAbsolutePath());
        }
      }
    }
    Collections.sort(imageNames);
    //TODO: dip to black!
    //for (int i = 0; i < imagePaths.size()-1; i++) {
    /*
  for (int i = imagePaths.size()-1; i >= 0; i--) {
     PImage img = loadImage(imagePaths.get(i));
     imageMap.put(imagePaths.get(i), img);
     imageNameMap.put(imagePaths.get(i), imagePaths.get(i).);
     }
     */
  }

  color getBackgroundColor() {
    return currentImg.get(0, 0);
  }

  String getImageName(int index) {
    return imageNames.get(index);
  }

  String getImagePath(int index) {
    return imagePaths.get(index);
  }


  int getImageCount() {
    return imageNames.size();
  }

  void draw(PGraphics canvas) {
    if (scheduleTransition && nextImg.width > 0 && currentImg.width > 0) {
      println("transition scheduled");
      if (transitionAni != null && transitionAni.isPlaying()) {
        transitionAni.end();
      }
      transitionAlpha = 0;
      //transitionShader.set("inTex", currentImg);
      //transitionShader.set("outTex", nextImg);
      transitionAni = new Ani(this, 2, 0, "transitionAlpha", 255, Ani.LINEAR, "onEnd:transitionEnd");
      //transitionAni.start();
      scheduleTransition = false;
      inTransition = true;
    }
    fitImage(canvas, currentImg, 255);
    println(transitionAlpha);
    if (inTransition) {
      fitImage(canvas, nextImg, transitionAlpha);
    }
    //transitionShader.set("inTex", currentImg);
    //transitionShader.set("outTex", nextImg);
    //canvas.shader(transitionShader);
    //fitImage(canvas, currentImg, 255);
    //canvas.shader(transitionShader);
    //canvas.shape(coneQuad);
    //canvas.resetShader();
    //transitionShader.set("fadeFactor", transitionAlpha);
    /*
    canvas.shader(transitionShader);
     canvas.pushMatrix();
     canvas.translate(canvas.width*0.5, canvas.height*0.5);
     canvas.shape(coneQuad);
     canvas.resetShader();
     canvas.popMatrix();
     */
    /*
    println(transitionAlpha);
     fitImage(canvas, currentImg, 255);
     if (transitionAni != null && transitionAni.isPlaying()) {
     //fitImage(canvas, nextImg, transitionAlpha);
     }
     */
  }

  void transitionEnd() {
    println("transition finished");
    scheduleTransition = false;
    inTransition = false;
    if (transitionAni != null && transitionAni.isPlaying()) {
      transitionAni.end();
    }
    if (nextImg != null) {
      currentImg = nextImg;
    }
  }

  void fitImage(PGraphics canvas, PImage img, float alpha) {
    float s = max(float(canvas.width)/img.width, float(canvas.height)/img.height);
    canvas.tint(255, alpha);
    canvas.image(img, 0, 0, img.width*s, img.height*s);
  }
}
