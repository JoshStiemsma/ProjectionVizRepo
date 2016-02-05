static class Keys {
  static private final int LEFT = 37;
  static private final int RIGHT = 39;
  static private final int UP = 38;
  static private final int DOWN = 40;
  static private final int SPACE = 32;
  static private final int ENTER = 13;
  
  static private final int MAX_CODE = 128;
  static private boolean[] keys = new boolean[MAX_CODE];
  static private boolean[] pkeys = new boolean[MAX_CODE];
  
  static public void update() {
    pkeys = keys.clone();
  }
  static public void handleKey(int code, boolean pressed) {
      keys[code] = pressed;
  }
  
  static public boolean isDown(int code){
    if(code < 0 || code >= keys.length) return false;
    return keys[code]; 
  }
  static public boolean isUp(int code){
    if(code < 0 || code >= keys.length) return false;
    return !keys[code]; 
  }
  static public boolean onDown(int code){
    if(code < 0 || code >= keys.length) return false;
    return keys[code] && !pkeys[code]; 
  }
  static public boolean onUp(int code){
    if(code < 0 || code >= keys.length) return false;
    return !keys[code] && pkeys[code]; 
  }
  
}


void keyPressed() {
  Keys.handleKey(keyCode, true);
}
void keyReleased() {
  Keys.handleKey(keyCode, false);
}