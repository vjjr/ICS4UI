void setup(){
  String a = "7.15x10^4";
  String b = "4.0x10^3";
  String aTimesb = multiplyInSciNotation(a,b); // SHould print "2.86x10^8"
  println(aTimesb); // SHould print "2.86x10^8"
  
  String c="1.3x10^1";
  String aTimesc=multiplyInSciNotation(a,c);
  println(aTimesc); // SHould print "9.295x10^-5"
  
  String d="1.x0x10^-4";
  String aTimesd=multiplyInSciNotation(a,d); // SHould print "7.15 with no powers attached"
  println(aTimesd); //// SHould print "7.15 with no powers attached"
}
