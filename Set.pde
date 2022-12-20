int[]Shuffle(int[]a){
  int[]b=new int[a.length];
  for(int i=0,x=a.length;i<x;i++){
    int ran=int(random(0,a.length));
    b[i]=a[ran];
    for(int j=ran,y=a.length-1;j<y;j++){
      a[j]=a[j+1];
    }
    a=shorten(a);
  }
  return b;
}
String[]Search_In_Array(String[]a,String b){
  String[]c;
  for(int i=0,x=a.length,y;i<x;i++){
    if(a[i].equals(b)){
      y=x-i-1;
      c=new String[y];
      for(int j=0;j<y;j++){
        c[j]=a[j+i+1];
      }
      return c;
    }
  }
  return null;
}
String A(int[]a){
  String b="";
  for(int i=0,x=a.length;i<x;i++){
    b=b+a[i]+",";
  }
  return b.substring(0,b.length()-1);
}
String A(String[]a){
  String b="";
  for(int i=0,x=a.length;i<x;i++){
    b=b+a[i]+",";
  }
  return b.substring(0,b.length()-1);
}
String A(double[]a){
  String b="";
  for(int i=0,x=a.length;i<x;i++){
    b=b+a[i]+",";
  }
  return b.substring(0,b.length()-1);
}
double[]B(String[]a){
  int x=a.length;
  double[]b=new double[x];
  for(int i=0;i<x;i++){
    b[i]=Double.parseDouble(a[i]);
  }
  return b;
}
