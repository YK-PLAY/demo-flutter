  class StringUtils {
    static bool isDigits(String s) {
      if(s == null) {
        return false;
      }

      return int.parse(s, radix: 10) == null;
    }
  }