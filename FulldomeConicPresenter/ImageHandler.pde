class ImageHandler {
  ArrayList<String> imagePaths = new ArrayList<String>();
  HashMap<String, String> imageNameMap  = new HashMap<String, String>();
  ArrayList<String> imageNames = new ArrayList<String>();

  PImage prevImg, currentImg, nextImg;
  int currentImgIndex = 0;

  ImageHandler(String path) {
    loadImages(path);
    currentImg = getImage(currentImgIndex);
    //prevImg = getImage(currentImgIndex-1);
    //nextImg = getImage(currentImgIndex+1);
  }

  PImage getNextImage() {
    currentImgIndex = (currentImgIndex + 1) %  imageNames.size();
    currentImg = getImage(currentImgIndex);
    /*
     prevImg = currentImg.copy();
     currentImg = nextImg.copy();
     nextImg = getImage(currentImgIndex+1);
     */
    //currentImg = getImage(currentImgIndex+1);


    /*
    prevImg = currentImg;
     currentImg = nextImg;
     nextImg = getImage(currentImgIndex+1);
     */
    //prevImg = getImage(currentImgIndex);
    //currentImg = getImage(currentImgIndex+1);
    //nextImg = getImage(currentImgIndex+2);
    while (currentImg.width == 0) {
      println("waiting");
    }
    println("current", imageNames.get(currentImgIndex));
    println("---");
    return currentImg;
  }

  PImage getPrevImage() {
    currentImgIndex = (currentImgIndex + imageNames.size() - 1) %  imageNames.size();
    currentImg = getImage(currentImgIndex);
    /*
     prevImg = currentImg.copy();
     currentImg = nextImg.copy();
     nextImg = getImage(currentImgIndex-1);
     */

    //currentImg = getImage(currentImgIndex-1);



    //prevImg = getImage(currentImgIndex);
    //currentImg = getImage(currentImgIndex+1);
    //nextImg = getImage(currentImgIndex+2);

    /*
    nextImg = currentImg;
    currentImg = prevImg;
    prevImg = getImage(currentImgIndex-1);
    */
    while (currentImg.width == 0) {
      println("waiting");
    }

    println("current", imageNames.get(currentImgIndex));
    println("---");
    return currentImg;
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
      result = loadImage(imageNameMap.get(imageNames.get(index)));
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
    return currentImg.get(0,0);
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
}
