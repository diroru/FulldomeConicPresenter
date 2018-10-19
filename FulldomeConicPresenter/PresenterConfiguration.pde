class PresenterConfiguration {
  String myPath;
  JSONObject defaultConfig, globalConfig;
  JSONArray imageConfig;

  PresenterConfiguration(String thePath) {
    myPath = thePath;
    loadData(myPath);
  }

  void loadData(String thePath) {
    JSONObject temp = loadJSONObject(thePath);
    defaultConfig = temp.getJSONObject("defaultConfig");
    globalConfig = temp.getJSONObject("globalConfig");
    imageConfig = temp.getJSONArray("imageConfig");
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
    try {
      imageConfig.getJSONObject(index).setFloat(paramName, paramVal);
    } 
    catch(Exception e) {
    }
  }
}
