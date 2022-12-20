/*String Correct_DNA_Length(String a,int b){
  for(;;){
    if(a.length()==b){
      break;
    }else if(a.length()<b){
      a=a+"-";
    }else if(a.length()>b){
      a=a.substring(0,len);
    }
  }
  return a;
}*/
String Correct_DNA_Length(String a,int b){
  int c;
  if(a.length()==b){
  }else if(a.length()<b){
    c=(int)(random(0,b-a.length()+1));
    String d="";
    for(int i=0;i<c;i++){
      d=d+"-";
    }
    d=d+a;
    for(int i=0,x=b-d.length();i<x;i++){
      d=d+"-";
    }
    return d;
  }else{
    c=(int)(random(0,a.length()-b+1));
    a=a.substring(c,c+b);
  }
  return a;
}
double[]DNA_To_Code(String a){
  char[]tem_str={'A','C','G','T'};
  int nucl_len=tem_str.length;
  int b=a.length();
  double[]out=new double[b*nucl_len];
    
  for(int i=0;i<b;i++){
    char c=a.charAt(i);
    for(int j=0;j<nucl_len;j++){
      if(c==tem_str[j]){
        out[i*nucl_len+j]=1d;
        break;
      }
    }
  }
  return out;
}
void displayDNA1(double[]a,float pos_x,float pos_y,float hei){
  char[]tem_str1={'A','C','G','T',' '};
  color[]tem_col1={color(255,255,0),color(0,0,255),color(0,255,0),color(255,0,0),color(255)};
  
  char[]tem_str2={'T','G','C','A',' '};
  color[]tem_col2={color(255,0,0),color(0,255,0),color(0,0,255),color(255,255,0),color(255)};
  
  int nucl_len=tem_str1.length-1;
  
  int x=a.length/nucl_len;
  
  
  float pos_x2=pos_x+height/2.5;
  float pos_x3=pos_x+height/1.05;
  float pos_x4=float(nn.tot_lay_amo)/(nn.tot_lay_amo+2.5)*width;
  textSize(hei/x*2);
  fill(255,255,0);
  text("Layer 0",pos_x-height/20,hei/x*2/3);
  text("Layer 1",pos_x2-height/20,hei/x*2/3);
  text("Layer 2",pos_x3-height/20,hei/x*2/3);
  text("Output layer",pos_x4-height/20,hei/x*2/3);
  noFill();
  stroke(2);
  stroke(255,255,0);
  rect(pos_x-height/20,hei/x*1/3,height/4,height*0.99);
  rect(pos_x2-height/20,hei/x*1/3,height/2,height*0.99);
  rect(pos_x3-height/20,hei/x*1/3,height/2,height*0.99);
  rect(pos_x4-height/20,hei/x*1/3,height/2.6,height*0.99);
  
  stroke(0);
  textSize(hei/x*4/3);
  pos_y-=hei/2;
  
  int max_pos;
  double max_val;
  for(int i=0;i<x;i++){
    max_val=0d;
    max_pos=4;
    for(int j=0;j<nucl_len;j++){
      double tem_dou=a[i*nucl_len+j];
      if(tem_dou>max_val){
        max_val=tem_dou;
        max_pos=j;
      }
    }
    fill(tem_col1[max_pos]);
    rect(pos_x,pos_y+i*(hei/x),height/17,hei/x*2/3,10);
    fill(0,255,0);
    textAlign(RIGHT,CENTER);
    text(tem_str1[max_pos],pos_x,pos_y+i*(hei/x)+hei/x*1/3);
    fill(tem_col2[max_pos]);
    rect(pos_x+height/16,pos_y+i*(hei/x),height/17,hei/x*2/3,10);
    fill(255,0,0);
    textAlign(LEFT,CENTER);
    text(tem_str2[max_pos],pos_x+height/16+height/17,pos_y+i*(hei/x)+hei/x*1/3);
    textAlign(RIGHT,CENTER);
    fill(255,255,255);
    text(dna_at_pos+i,pos_x-height/50,pos_y+i*(hei/x)+hei/x*1/3);
  }
  fill(200);
  rect(pos_x,pos_y,height/40,hei);
  rect(pos_x+height/16+height/17-height/40,pos_y,height/40,hei);
  
  
  rectMode(CORNER);
  strokeWeight(1);
  stroke(255);
  //nn.neu[2][0][1]=1d;
  
  
  noStroke();
  for(int j=0;j<nn.map_amo[1];j++){
    for(int i=dna_at_pos,y=dna_at_pos+dis_len;i<y;i++){
      fill(Neuron_Color(nn.neu[1][j][i],0,1));
      rect(pos_x2+j*hei/x*2,(i-dna_at_pos)*hei/x+pos_y,hei/x,hei/x);
      //fill(255);
      //text(String.format("%.4f",nn.neu[1][0][i]),pos_x2+height/20,(i-dna_at_pos)*hei/x+pos_y);
    }
  }
  stroke(255);
  strokeWeight(1);
  for(int j=0;j<nn.map_amo[1];j++){
    for(int i=dna_at_pos,y=dna_at_pos+dis_len;i<y;i+=nn.ker_wid[1]*nn.ker_hei[1]){
      fill(0,0,0,0);
      rect(pos_x2+j*hei/x*2,(i-dna_at_pos)*hei/x+pos_y,hei/x,hei/x*nn.ker_hei[1]);
      fill(Neuron_Color(nn.neu[2][j][i/5+nn.pad_hei[2]],0,1));
      rect(pos_x3+j*hei/x*2,(i-dna_at_pos)*hei/x+pos_y,hei/x,hei/x);
    }
  }
  
  fill(255);
  for(int i=dna_at_pos,y=dna_at_pos+dis_len;i<y;i+=nn.ker_wid[1]*nn.ker_hei[1]){
    text(i,pos_x2-(hei/x)/2,pos_y+(i-dna_at_pos)*(hei/x)+hei/x*1/3);
    text(i,pos_x3-(hei/x)/2,pos_y+(i-dna_at_pos)*(hei/x)+hei/x*1/3);
  }
  textAlign(CENTER,CENTER);
  for(int j=0;j<nn.map_amo[1];j++){
    text(j,pos_x2+hei/x*(2*j+0.5),pos_y-hei/x);
    text(j,pos_x3+hei/x*(2*j+0.5),pos_y-hei/x);
  }
}
void displayDNA2(double[]a,float pos_x,float pos_y,float siz){
  char[]tem_str1={'A','C','G','T'};
  color[]tem_col1={color(255,255,0),color(0,0,255),color(0,255,0),color(255,0,0)};
  int nucl_len=tem_str1.length;
  int x=a.length/nucl_len;
  siz/=x;
  
  stroke(255);
  textAlign(CENTER,BOTTOM);
  for(int j=0;j<nucl_len;j++){
    fill(tem_col1[j]);
    text(tem_str1[j],j*siz+pos_x-nucl_len/2*siz+siz/2,pos_y-x/2*siz);
    for(int i=0;i<x;i++){
      fill((float)(a[i*nucl_len+j]*255d));
      rect(j*siz+pos_x-nucl_len/2*siz,i*siz+pos_y-x/2*siz,siz,siz);
    }
  }
}
void displayOutputLayer(){
  double[]a=new double[nn.map_amo[nn.tot_lay_amo-1]];
  for(int i=0,x=a.length;i<x;i++){
    a[i]=nn.neu[nn.tot_lay_amo-1][i][0];
  }
  
  float pos_x1=float(nn.tot_lay_amo)/(nn.tot_lay_amo+2.5)*width;
  //float pos_x2=(nn.tot_lay_amo+2.5)/(nn.tot_lay_amo+3)*width;
  float pos_y1=float(height)/(a.length+1);
  
  rectMode(CENTER);
  stroke(255);
  strokeWeight(((width<height)?width:height)/480);
  for(int j=0;j<a.length;j++){
    fill(Neuron_Color(a[j],0,1));
    rect(pos_x1,(j+1)*pos_y1,width/40,width/40);
    //fill((float)((1d-nn.des_out[j][0])*255d),(float)(nn.des_out[j][0]*255d),0);
    //rect(pos_x2,(j+1)*pos_y1,width/40,width/40);
  }
}
void displayOutputText(){
  int x=nn.map_amo[nn.tot_lay_amo-1];
  float pos_x2=(nn.tot_lay_amo+0.25)/(nn.tot_lay_amo+2.5)*width;
  float pos_y1=float(height)/(x+1);
  
  fill(255);
  textSize(width/80);
  textAlign(LEFT,CENTER);
  for(int j=0;j<x;j++){
    text(classes[j],pos_x2,(j+1)*pos_y1);
  }
}
void displayWeightsLayer(int a,float pos_x,int pos_y){
  int siz=8;
  double min_wei=nn.wei[a][0][0][0][0],max_wei=nn.wei[a][0][0][0][0];
  for(int i=0;i<nn.map_amo[a-1];i++){
    for(int j=0;j<nn.map_amo[a];j++){
      for(int k=0;k<nn.ker_hei[a-1]*nn.ker_wid[a-1];k++){
        if(nn.wei[a][i][k][j][0]<min_wei){
          min_wei=nn.wei[a][i][k][j][0];
        }else if(nn.wei[a][i][k][j][0]>max_wei){
          max_wei=nn.wei[a][i][k][j][0];
        }
      }
    }
  }
  noStroke();
  textAlign(RIGHT,CENTER);
  for(int k=0;k<nn.map_amo[a];k++){
    fill(255);
    text(k,pos_x-siz,pos_y+45*k+nn.ker_hei[a-1]*siz/2);
    for(int i=0;i<nn.ker_hei[a-1];i++){
      for(int j=0;j<nn.ker_wid[a-1];j++){
        fill(Weight_Color(nn.wei[a][0][j+i*nn.ker_wid[a-1]][k][0],min_wei,max_wei));
        rect(j*siz+pos_x,i*siz+pos_y+45*k,siz,siz);
      }
    }
  }
  noFill();
  strokeWeight(1);
  stroke(255);
  for(int k=0;k<nn.map_amo[a];k++){
    rect(pos_x-2,pos_y+45*k-2,siz*nn.ker_wid[a-1]+2,siz*nn.ker_hei[a-1]+2);
  }
}
color Neuron_Color(double a,double b,double c){
  return lerpColor(color(255),color(0),(float)(map(c-a,c,b,1d,0d)));
}
color Weight_Color(double a,double min_wei,double max_wei){
  if(a<0){
    return lerpColor(color(0),color(200,80,50),(float)(map(a*-1,0,min_wei*-1,0,1)));
  }else{
    return lerpColor(color(0),color(85,150,170),(float)(map(a,0,max_wei,0,1)));
  }
}
/*color Neuron_Color(double a,int b){
  return lerpColor(color(255),color(0),(float)(map(nn.max_neu[b]-a,nn.max_neu[b],nn.min_neu[b],1d,0d)));
}*/
double map(double a,double b,double c,double d,double e){
  return d+(e-d)*((a-b)/(c-b));
}
