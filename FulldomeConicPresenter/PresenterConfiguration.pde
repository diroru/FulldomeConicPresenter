class PresenterConfiguration {
  String myPath;
  JSONObject defaultConfig, globalConfig;
  JSONArray imageConfig;

  PresenterConfiguration(String thePath, ImageHandler theImageHandler) {
    myPath = thePath;
    loadData(myPath);
    checkData(theImageHandler);
  }

  void loadData(String thePath) {
    JSONObject temp = loadJSONObject(thePath);
    defaultConfig = temp.getJSONObject("defaultConfig");
    globalConfig = temp.getJSONObject("globalConfig");
    imageConfig = temp.getJSONArray("imageConfig");
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

  String getPointerColor() {
    return globalConfig.getString("pointerColor");
  }
  
  int getCanvasSize() {
    return globalConfig.getInt("canvasSize");
  }


  void saveData() {
    saveData(dataPath("config.json"));
  }

  void saveData(String thePath) {
    JSONObject temp = new JSONObject();
    temp.setJSONObject("defaultConfig", defaultConfig);
    temp.setJSONObject("globalConfig", globalConfig);
    temp.setJSONArray("imageConfig", imageConfig);
    saveJSONObject(temp, thePath);
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
