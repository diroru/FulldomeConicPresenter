class PresenterConfiguration {
  String myConfigPath, myImageConfigPath;
  JSONObject defaultConfig, globalConfig;
  JSONArray imageConfig;
  PImage currentImg, nextImg;

  PresenterConfiguration(String theConfigPath, String theImageConfigPath, ImageHandler theImageHandler) {
    myConfigPath = theConfigPath;
    myImageConfigPath = theImageConfigPath;
    loadData(myConfigPath, myImageConfigPath);
    checkData(theImageHandler);
  }

  void loadData(String theConfigPath, String theImageConfigPath) {
    //TODO: handle exceptions;
    JSONObject temp = loadJSONObject(theConfigPath);
    defaultConfig = temp.getJSONObject("defaultConfig");
    globalConfig = temp.getJSONObject("globalConfig");
    
    JSONArray temp2 = null;
    try {
      temp2 = loadJSONArray(theImageConfigPath);
    } catch (Exception e) {
      temp2 = new JSONArray();
    }
    imageConfig = temp2;
  }

  void checkData(ImageHandler theImageHandler) {
    for (int i = 0; i < theImageHandler.getImageCount(); i++) {
      String imageName = theImageHandler.getImageName(i);
      String imagePath = theImageHandler.getImagePath(i);
      String imageNameConfig = "";
      try {
        imageNameConfig = imageConfig.getJSONObject(i).getString("name");
      } catch (Exception e) {
      }
      if (!imageName.equals(imageNameConfig)) {
        imageConfig.setJSONObject(i,getDefaultObject());
        imageConfig.getJSONObject(i).setString("path", imagePath);
        imageConfig.getJSONObject(i).setString("name", imageName);
      }
    }
    while (imageConfig.size() > theImageHandler.getImageCount()) {
      imageConfig.remove(imageConfig.size()-1);
    }
  }

  int getDomeSize() {
    return globalConfig.getInt("domeSize");
  }

  int getPointerSize() {
    return globalConfig.getInt("pointerSize");
  }

  int getInfoSize() {
    return globalConfig.getInt("infoSize");
  }

  String getPointerColor() {
    return globalConfig.getString("pointerColor");
  }
  
  int getCanvasSize() {
    return globalConfig.getInt("canvasSize");
  }


  void saveData() {
    saveData(myImageConfigPath);
  }

  void saveData(String theImageConfigPath) {
    println(imageConfig);
    saveJSONArray(imageConfig, dataPath(theImageConfigPath));
  }

  String getImagePath(int index) {
    String result = null;
    try {
      result = imageConfig.getJSONObject(index).getString("path");
    } 
    catch(Exception e) {
    }
    return result;
  }

  Float getImageParam(int index, String paramName) {
    Float result = null;
    try {
      result = imageConfig.getJSONObject(index).getFloat(paramName);
    } 
    catch(Exception e) {
    }
    return result;
  }

  void setImageParam(int index, String paramName, Float paramVal) {
    JSONObject jsonObj = new JSONObject();
    try {
      jsonObj = imageConfig.getJSONObject(index);
    } 
    catch(Exception e) {
      jsonObj = getDefaultObject();
      imageConfig.setJSONObject(index, jsonObj);
    } 
    finally {
      jsonObj.setFloat(paramName, paramVal);
    }
  }

  float getDuration() {
    return globalConfig.getFloat("transitionDuration");
  }

  JSONObject getDefaultObject() {
    JSONObject result = new JSONObject();
    for (Object theKeyObj : defaultConfig.keys()) {
      String theKey = (String)theKeyObj;
      Float theValue = defaultConfig.getFloat(theKey);
      result.setFloat(theKey, theValue);
    }
    result.setString("path", "");
    result.setString("name", "");
    return result;
  }
  
}
