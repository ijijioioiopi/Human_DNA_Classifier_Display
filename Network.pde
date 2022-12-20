class Network{
  int[][][]win_neu;
  double[][][]neu;//1. this layer 2. this feature map 3. this neuron
  double[][][]bia;//1. this layer 2. this feature map 3. this neuron
  double[][][][][]wei;//1. this layer 2. previous feature map 3. previous neuron 4. this feature map 5. this neuron.
  double[][]des_out;//1. this feature map 3. this neuron
  double[][][]dbia;
  double[][][][][]dwei;
  
  //double[]min_neu,max_neu;
  
  String opt;
  double[][][]vdb;
  double[][][][][]vdw;
  double[][][]sdb;
  double[][][][][]sdw;
  
  double lea_rat;
  double beta1;
  double beta2;
  double epsilon;
  
  int tot_lay_amo;
  int[]map_amo={};
  int[]stride_wid={};
  int[]stride_hei={};
  int[]ker_wid={};
  int[]ker_hei={};
  int[]pad_wid={};
  int[]pad_hei={};
  int[]neu_wid={};
  int[]neu_hei={};
  double[]thr={};
  String[]wei_ini={};
  String[]type={};//0. Convolutional. 1. Hidden.
  String[]act_fun={};//0. Max pool. 1. Average pool. 2. SoftMax. 3. Sigmoid. 4. ReLU.
  /*double[]wei_c={};
  int[]pix_norm={};*/
  
  int at_epoch;
  int at_ite;
  int bat_siz;
  int ite_gap;
  int tot_ite;
  
  String fil_nam;
  
  PrintWriter ite_graph;
  PrintWriter epo_graph;
  //boolean[]share;
  Network(String a){
    fil_nam=a;
    LoadNetworkS();
    reset();
    LoadNetworkP();
    
    String[]tem_str=loadStrings(dat_pat+"/"+fil_nam+"/"+"Iteration_Graph.txt");
    ite_graph=createWriter(dat_pat+"/"+fil_nam+"/"+"Iteration_Graph.txt");
    for(int i=0,x=tem_str.length;i<x;i++){
      ite_graph.println(tem_str[i]);
    }
    ite_graph.flush();
    
    tem_str=loadStrings(dat_pat+"/"+fil_nam+"/"+"Epoch_Graph.txt");
    epo_graph=createWriter(dat_pat+"/"+fil_nam+"/"+"Epoch_Graph.txt");
    for(int i=0,x=tem_str.length;i<x;i++){
      epo_graph.println(tem_str[i]);
    }
    epo_graph.flush();
  }
  Network(int a,int b,String c,String d,double e){
    bat_siz=a;
    ite_gap=b;
    fil_nam=c;
    opt=d;
    lea_rat=e;
    
    at_epoch=0;
    
    ite_graph=createWriter(dat_pat+"/"+fil_nam+"/"+"Iteration_Graph.txt");
    epo_graph=createWriter(dat_pat+"/"+fil_nam+"/"+"Epoch_Graph.txt");
  }
  Network(int a,int b,String c,String d,double e,double f,double g,double h){
    bat_siz=a;
    ite_gap=b;
    fil_nam=c;
    opt=d;
    lea_rat=e;
    beta1=f;
    beta2=g;
    epsilon=h;
    
    at_epoch=0;
    
    ite_graph=createWriter(dat_pat+"/"+fil_nam+"/"+"Iteration_Graph.txt");
    epo_graph=createWriter(dat_pat+"/"+fil_nam+"/"+"Epoch_Graph.txt");
  }
  void addConvLayer(int a,int b,int c,int d,int e,int f,int g,int h,int i,double j,String k,String m){
    //a=feature map amount.
    //b=stride width.
    //c=stride height
    //d=kernel width.
    //e=kernel height.
    //f=padding width.
    //g=padding height.
    //h=neuron width.
    //i=neuron height.
    //j=type of layers.
    //k=activation functions.
    //l=batch size.
    //m=learning rate.
    map_amo=append(map_amo,a);
    stride_wid=append(stride_wid,b);
    stride_hei=append(stride_hei,c);
    ker_wid=append(ker_wid,d);
    ker_hei=append(ker_hei,e);
    pad_wid=append(pad_wid,f);
    pad_hei=append(pad_hei,g);
    neu_wid=append(neu_wid,h);
    neu_hei=append(neu_hei,i);
    thr=(double[])(append(thr,j));
    wei_ini=append(wei_ini,k);
    type=append(type,"c");
    act_fun=append(act_fun,m);
    /*wei_c=(double[])(append(wei_c,1d));
    pix_norm=append(pix_norm,0);*/
    
    tot_lay_amo=map_amo.length;
  }
  void addPoolLayer(int a,int b,int c,int d,int e,int f,int g,int h,int i,String m){
    //a=feature map amount.
    //b=stride width.
    //c=stride height
    //d=kernel width.
    //e=kernel height.
    //f=padding width.
    //g=padding height.
    //h=neuron width.
    //i=neuron height.
    //j=type of layers.
    //k=activation functions.
    //l=batch size.
    //m=learning rate.
    map_amo=append(map_amo,a);
    stride_wid=append(stride_wid,b);
    stride_hei=append(stride_hei,c);
    ker_wid=append(ker_wid,d);
    ker_hei=append(ker_hei,e);
    pad_wid=append(pad_wid,f);
    pad_hei=append(pad_hei,g);
    neu_wid=append(neu_wid,h);
    neu_hei=append(neu_hei,i);
    thr=(double[])(append(thr,0d));
    wei_ini=append(wei_ini,"-");
    type=append(type,"c");
    act_fun=append(act_fun,m);
    /*wei_c=(double[])(append(wei_c,1d));
    pix_norm=append(pix_norm,0);*/
    
    tot_lay_amo=map_amo.length;
  }
  /*void PixelNormalisation(int a){
    if(type[a].equals("c")){
      pix_norm[a]=1;
    }
  }*/
  void addHiddenLayer(int h,double j,String k,String m){
    map_amo=append(map_amo,1);
    stride_wid=append(stride_wid,-1);
    stride_hei=append(stride_hei,-1);
    ker_wid=append(ker_wid,h);
    ker_hei=append(ker_hei,1);
    pad_wid=append(pad_wid,0);
    pad_hei=append(pad_hei,0);
    neu_wid=append(neu_wid,h);
    neu_hei=append(neu_hei,1);
    thr=(double[])(append(thr,j));
    wei_ini=append(wei_ini,k);
    type=append(type,"h");
    act_fun=append(act_fun,m);
    /*wei_c=(double[])(append(wei_c,1d));
    pix_norm=append(pix_norm,0);*/
    
    tot_lay_amo=map_amo.length;
  }
  void randomizeAll(){
    for(int i=1;i<tot_lay_amo;i++){
      randomizeLayer(i);
      SaveNetworkP(i);
    }
    SaveNetworkS();
  }
  void reset(){
    tot_ite=0;
    
    win_neu=new int[tot_lay_amo][][];
    neu=new double[tot_lay_amo][][];
    bia=new double[tot_lay_amo][][];
    wei=new double[tot_lay_amo][][][][];
    dbia=new double[tot_lay_amo][][];
    dwei=new double[tot_lay_amo][][][][];
    
    if(opt.equals("Adam")){
      vdb=new double[tot_lay_amo][][];
      vdw=new double[tot_lay_amo][][][][];
      sdb=new double[tot_lay_amo][][];
      sdw=new double[tot_lay_amo][][][][];
    }
    
    neu[0]=new double[map_amo[0]][neu_wid[0]*neu_hei[0]];
    for(int i=1;i<tot_lay_amo;i++){
      neu[i]=new double[map_amo[i]][neu_wid[i]*neu_hei[i]];
      if(act_fun[i].equals("Max_Pool")){
        win_neu[i]=new int[map_amo[i]][neu_wid[i]*neu_hei[i]];
      }else if(!act_fun[i].equals("Avg_Pool")){
        bia[i]=new double[map_amo[i]][1];
        wei[i]=new double[map_amo[i-1]][ker_wid[i-1]*ker_hei[i-1]][map_amo[i]][1];
        dbia[i]=new double[map_amo[i]][1];
        dwei[i]=new double[map_amo[i-1]][ker_wid[i-1]*ker_hei[i-1]][map_amo[i]][1];
        if(opt.equals("Adam")){
          vdb[i]=new double[map_amo[i]][1];
          vdw[i]=new double[map_amo[i-1]][ker_wid[i-1]*ker_hei[i-1]][map_amo[i]][1];
          sdb[i]=new double[map_amo[i]][1];
          sdw[i]=new double[map_amo[i-1]][ker_wid[i-1]*ker_hei[i-1]][map_amo[i]][1];
        }
      }
    }
    des_out=new double[map_amo[tot_lay_amo-1]][neu_wid[tot_lay_amo-1]*neu_hei[tot_lay_amo-1]];
  }
  /*void PrintError(){
    if(lea_rat>0.0007d){
      lea_rat*=0.98d;
    }
    graph.println("Batch *"+bat_siz+": "+(at_ite)+", Epoch: "+at_epoch+": "+(err/(step*bat_siz)));
    graph.flush();
    err=0d;
    
  }*/
  void setData(double[][]a,double[][]b){
    neu[0]=a;
    des_out=b;
  }
  void randomizeLayer(int a){
    //for(int i=1;i<tot_lay_amo;i++){
      if(!act_fun[a].equals("Max_Pool")&&!act_fun[a].equals("Avg_Pool")){
        int x=ker_wid[a-1]*ker_hei[a-1];
        if(type[a].equals("c")){
          for(int j=0;j<map_amo[a];j++){
            for(int k=0;k<map_amo[a-1];k++){
              for(int l=0;l<x;l++){
                if(wei_ini[a].equals("g")){
                  wei[a][k][l][j][0]=ran.nextGaussian()*thr[a];
                }else if(wei_ini[a].equals("r")){
                  wei[a][k][l][j][0]=thr[a]*2d*(ran.nextDouble()-0.5d);
                }
              }
            }
            bia[a][j][0]=0d;
          }
        }else if(type[a].equals("h")){
          for(int j=0,y=neu_wid[a]*neu_hei[a];j<map_amo[a];j++){
            for(int k=0;k<y;k++){
              for(int l=0;l<map_amo[a-1];l++){
                for(int m=0;m<x;m++){
                  if(wei_ini[a].equals("g")){
                    wei[a][l][m][j][k]=ran.nextGaussian()*thr[a];
                  }else if(wei_ini[a].equals("r")){
                    wei[a][l][m][j][k]=thr[a]*(ran.nextDouble()-0.5d);
                  }
                }
              }
              bia[a][j][k]=0d;
            }
          }
        }
      }
    //}
  }
  void LoadNetworkS(){
    String[]a=loadStrings(dat_pat+"/"+fil_nam+"/Settings.txt");
    map_amo=int(split(a[0],","));
    stride_wid=int(split(a[1],","));
    stride_hei=int(split(a[2],","));
    ker_wid=int(split(a[3],","));
    ker_hei=int(split(a[4],","));
    pad_wid=int(split(a[5],","));
    pad_hei=int(split(a[6],","));
    neu_wid=int(split(a[7],","));
    neu_hei=int(split(a[8],","));
    thr=B(split(a[9],","));
    wei_ini=split(a[10],",");
    type=split(a[11],",");
    act_fun=split(a[12],",");
    /*wei_c=B(split(a[13],","));
    pix_norm=int(split(a[14],","));*/
    bat_siz=int(a[13]);
    ite_gap=int(a[14]);
    tot_ite=int(a[15]);
    at_epoch=int(a[16]);
    opt=a[17];
    lea_rat=Double.parseDouble(a[18]);
    beta1=Double.parseDouble(a[19]);
    beta2=Double.parseDouble(a[20]);
    epsilon=Double.parseDouble(a[21]);
    
    tot_lay_amo=map_amo.length;
    /*
    String[]a=loadStrings(data_path+"/"+fil_nam+"/Settings.txt");
    map_amo=int(split(a[0],","));
    stride_wid=int(split(a[1],","));
    stride_hei=int(split(a[2],","));
    ker_wid=int(split(a[3],","));
    ker_hei=int(split(a[4],","));
    neu_wid=int(split(a[5],","));
    neu_hei=int(split(a[6],","));
    type=int(split(a[7],","));
    act_fun=int(split(a[8],","));
    bat_siz=int(a[9]);
    lea_rat=int(a[10]);
    at_epoch=int(a[11]);
    tot_lay_amo=map_amo.length;*/
  }
  void SaveNetworkS(){
    PrintWriter tem_pwr;
    tem_pwr=createWriter(dat_pat+"/"+fil_nam+"/Settings.txt");
    tem_pwr.println(A(map_amo)+
    "\n"+A(stride_wid)+"\n"+A(stride_hei)+
    "\n"+A(ker_wid)+"\n"+A(ker_hei)+
    "\n"+A(pad_wid)+"\n"+A(pad_hei)+
    "\n"+A(neu_wid)+"\n"+A(neu_hei)+
    "\n"+A(thr)+"\n"+A(wei_ini)+
    "\n"+A(type)+"\n"+A(act_fun)+"\n"+
    bat_siz+"\n"+ite_gap+"\n"+tot_ite+"\n"+at_epoch+"\n"+opt+"\n"+lea_rat+"\n"+beta1+"\n"+beta2+"\n"+epsilon);
    tem_pwr.flush();
    tem_pwr.close();
  }
  void LoadNetworkP(){
    for(int i=1;i<tot_lay_amo;i++){
      String[]tem_str3={},tem_str4={};
      if(!act_fun[i].equals("Max_Pool")&&!act_fun[i].equals("Avg_Pool")){
        String[]tem_str2=loadStrings(dat_pat+"/"+fil_nam+"/Network_epoch_"+at_epoch+"/WeightsAndBiases/"+i+".txt");
        if(opt.equals("Adam")){
          tem_str3=loadStrings(dat_pat+"/"+fil_nam+"/Network_epoch_"+at_epoch+"/Adam/V/"+i+".txt");
          tem_str4=loadStrings(dat_pat+"/"+fil_nam+"/Network_epoch_"+at_epoch+"/Adam/S/"+i+".txt");
        }
        int x=ker_wid[i-1]*ker_hei[i-1];
        if(type[i].equals("c")){
          for(int j=0;j<map_amo[i];j++){
            tem_str2=Search_In_Array(tem_str2,"Next map "+j+":");
            if(opt.equals("Adam")){
              tem_str3=Search_In_Array(tem_str3,"Next map "+j+":");
              tem_str4=Search_In_Array(tem_str4,"Next map "+j+":");
            }
            for(int k=0;k<map_amo[i-1];k++){
              tem_str2=Search_In_Array(tem_str2,"Prev map "+k+":");
              if(opt.equals("Adam")){
                tem_str3=Search_In_Array(tem_str3,"Prev map "+k+":");
                tem_str4=Search_In_Array(tem_str4,"Prev map "+k+":");
              }
              for(int l=0;l<x;l++){
                wei[i][k][l][j][0]=Double.parseDouble(tem_str2[l]);
                if(opt.equals("Adam")){
                  vdw[i][k][l][j][0]=Double.parseDouble(tem_str3[l]);
                  sdw[i][k][l][j][0]=Double.parseDouble(tem_str4[l]);
                }
              }
            }
          }
          tem_str2=Search_In_Array(tem_str2,"Shared biases:");
          if(opt.equals("Adam")){
            tem_str3=Search_In_Array(tem_str3,"Shared biases:");
            tem_str4=Search_In_Array(tem_str4,"Shared biases:");
          }
          for(int j=0;j<map_amo[i];j++){
            bia[i][j][0]=Double.parseDouble(tem_str2[j]);
            if(opt.equals("Adam")){
              vdb[i][j][0]=Double.parseDouble(tem_str3[j]);
              sdb[i][j][0]=Double.parseDouble(tem_str4[j]);
            }
          }
        }else if(type[i].equals("h")){
          int y=neu_wid[i]*neu_hei[i];
          for(int j=0;j<map_amo[i];j++){
            tem_str2=Search_In_Array(tem_str2,"Next map "+j+":");
            if(opt.equals("Adam")){
              tem_str3=Search_In_Array(tem_str3,"Next map "+j+":");
              tem_str4=Search_In_Array(tem_str4,"Next map "+j+":");
            }
            for(int k=0;k<y;k++){
              tem_str2=Search_In_Array(tem_str2,"Next neu "+k+":");
              if(opt.equals("Adam")){
                tem_str3=Search_In_Array(tem_str3,"Prev map "+k+":");
                tem_str4=Search_In_Array(tem_str4,"Prev map "+k+":");
              }
              for(int l=0;l<map_amo[i-1];l++){
                tem_str2=Search_In_Array(tem_str2,"Prev map "+l+":");
                if(opt.equals("Adam")){
                  tem_str3=Search_In_Array(tem_str3,"Prev map "+l+":");
                  tem_str4=Search_In_Array(tem_str4,"Prev map "+l+":");
                }
                for(int m=0;m<x;m++){
                  wei[i][l][m][j][k]=Double.parseDouble(tem_str2[m]);
                  if(opt.equals("Adam")){
                    vdw[i][l][m][j][k]=Double.parseDouble(tem_str3[m]);
                    sdw[i][l][m][j][k]=Double.parseDouble(tem_str4[m]);
                  }
                }
              }
            }
          }
          tem_str2=Search_In_Array(tem_str2,"Unshared biases:");
          if(opt.equals("Adam")){
            tem_str3=Search_In_Array(tem_str3,"Unshared biases:");
            tem_str4=Search_In_Array(tem_str4,"Unshared biases:");
          }
          for(int j=0;j<map_amo[i];j++){
            tem_str2=Search_In_Array(tem_str2,"Next map "+j+":");
            if(opt.equals("Adam")){
              tem_str3=Search_In_Array(tem_str3,"Next map "+j+":");
              tem_str4=Search_In_Array(tem_str4,"Next map "+j+":");
            }
            for(int k=0;k<y;k++){
              bia[i][j][k]=Double.parseDouble(tem_str2[k]);
              if(opt.equals("Adam")){
                vdb[i][j][k]=Double.parseDouble(tem_str3[k]);
                sdb[i][j][k]=Double.parseDouble(tem_str4[k]);
              }
            }
          }
        }
      }
    }
  }
  void SavePar(int a,String b,double[][][][][]c,double[][][]d){
    int x=ker_wid[a-1]*ker_hei[a-1];
    if(!act_fun[a].equals("Max_Pool")&&!act_fun[a].equals("Avg_Pool")){
      PrintWriter tem_pwr=createWriter(dat_pat+"/"+fil_nam+"/Network_epoch_"+at_epoch+"/"+b+"/"+a+".txt");
      if(type[a].equals("c")){
        tem_pwr.println("Shared weights:");
        for(int j=0;j<map_amo[a];j++){
          tem_pwr.println("Next map "+j+":");
          for(int k=0;k<map_amo[a-1];k++){
            tem_pwr.println("Prev map "+k+":");
            for(int l=0;l<x;l++){
              tem_pwr.println(c[a][k][l][j][0]);
            }
          }
        }
        tem_pwr.println("\nShared biases:");
        for(int j=0;j<map_amo[a];j++){
          tem_pwr.println(d[a][j][0]);
        }
      }else if(type[a].equals("h")){
        int y=neu_wid[a]*neu_hei[a];
        tem_pwr.println("Unshared weights:");
        for(int j=0;j<map_amo[a];j++){
          tem_pwr.println("Next map "+j+":");
          for(int k=0;k<y;k++){
            tem_pwr.println("Next neu "+k+":");
            for(int l=0;l<map_amo[a-1];l++){
              tem_pwr.println("Prev map "+l+":");
              for(int m=0;m<x;m++){
                tem_pwr.println(c[a][l][m][j][k]);
              }
            }
          }
        }
        tem_pwr.println("\nUnshared biases:");
        for(int j=0;j<map_amo[a];j++){
          tem_pwr.println("Next map "+j+":");
          for(int k=0;k<y;k++){
            tem_pwr.println(d[a][j][k]);
          }
        }
      }
      tem_pwr.flush();
      tem_pwr.close();
    }
  }
  void SaveNetworkP(int a){
    SavePar(a,"WeightsAndBiases",wei,bia);
    if(opt.equals("Adam")){
      SavePar(a,"Adam/V",vdw,vdb);
      SavePar(a,"Adam/S",sdw,sdb);
    }
  }
  void SetLayer(int a,double[][]b){
    for(int j=0;j<map_amo[a];j++){
      for(int k=0,v=0;k<neu_hei[a]-pad_hei[a]*2;k++){
        for(int l=0,w=neu_wid[a]*(k+pad_hei[a])+pad_wid[a];l<neu_wid[a]-pad_wid[a]*2;l++){
          neu[a][j][w]=b[j][v];
          v++;
          w++;
        }
      }
    }
  }
  void Feedforward(int a){
    double tem;
    //double[]std_neu;
    //double[][]tem_neu2;
    for(int i=a;i<tot_lay_amo;i++){
      if(type[i].equals("c")){
        double[][]tem_neu=new double[map_amo[i]][(neu_wid[i]-pad_wid[i]*2)*(neu_hei[i]-pad_hei[i]*2)];
        if(act_fun[i].equals("Max_Pool")){
          for(int j=0,tem3;j<map_amo[i];j++){
            for(int k=0,w=0;k<neu_hei[i]-pad_hei[i]*2;k++){
              for(int l=0,x=stride_hei[i-1]*k;l<neu_wid[i]-pad_wid[i]*2;l++){
                tem=neu[i-1][j][stride_wid[i-1]*l+neu_wid[i-1]*x];
                win_neu[i][j][w]=stride_wid[i-1]*l+neu_wid[i-1]*x;
                for(int m=0,y=stride_wid[i-1]*l;m<ker_hei[i-1];m++){
                  for(int n=0,z=(x+m)*neu_wid[i-1]+y;n<ker_wid[i-1];n++){
                    tem3=n+z;
                    double tem2=neu[i-1][j][tem3];
                    if(tem2>tem){
                      tem=tem2;
                      win_neu[i][j][w]=tem3;
                    }
                  }
                }
                tem_neu[j][w]=tem;
                w++;
              }
            }
          }
        }else if(act_fun[i].equals("Avg_Pool")){
          for(int j=0,v=ker_wid[i-1]*ker_hei[i-1];j<map_amo[i];j++){
            for(int k=0,w=0;k<neu_hei[i]-pad_hei[i]*2;k++){
              for(int l=0,x=stride_hei[i-1]*k;l<neu_wid[i]-pad_wid[i]*2;l++){
                tem=0d;
                for(int m=0,y=stride_wid[i-1]*l;m<ker_hei[i-1];m++){
                  for(int n=0,z=(x+m)*neu_wid[i-1]+y;n<ker_wid[i-1];n++){
                    //double tem2=;
                    tem+=neu[i-1][j][n+z];
                  }
                }
                tem_neu[j][w]=tem/v;
                w++;
              }
            }
          }
        }else{
          /*int x1=ker_wid[i-1]*ker_hei[i-1];
          double[][][][]tem_wei=new double[map_amo[i-1]][x1][map_amo[i]][1];
          for(int j=0;j<map_amo[i];j++){
            for(int k=0;k<map_amo[i-1];k++){
              for(int l=0;l<x1;l++){
                tem_wei[k][l][j][0]=wei[i][k][l][j][0]*wei_c[i-1];
              }
            }
          }*/
          //int x2=neu_wid[i-1]*neu_hei[i-1];
          //tem_neu2=new double[map_amo[i-1]][x2];
          for(int j=0;j<map_amo[i];j++){
            for(int k=0,v=0;k<neu_hei[i]-pad_hei[i]*2;k++){
              for(int l=0,w=stride_hei[i-1]*k;l<neu_wid[i]-pad_wid[i]*2;l++){
                tem_neu[j][v]=bia[i][j][0];
                for(int m=0,x=stride_wid[i-1]*l;m<map_amo[i-1];m++){
                  for(int n=0,y=0;n<ker_hei[i-1];n++){
                    for(int o=0,z=(w+n)*neu_wid[i-1]+x;o<ker_wid[i-1];o++){
                      tem_neu[j][v]+=neu[i-1][m][o+z]*wei[i][m][y][j][0];
                      y++;
                    }
                  }
                }
                v++;
              }
            }
          }
        }
        if(pad_wid[i]!=0||pad_hei[i]!=0){
          for(int j=0;j<map_amo[i];j++){
            for(int k=0,v=0;k<neu_hei[i]-pad_hei[i]*2;k++){
              for(int l=0,w=neu_wid[i]*(k+pad_hei[i])+pad_wid[i];l<neu_wid[i]-pad_wid[i]*2;l++){
                neu[i][j][w]=tem_neu[j][v];
                v++;
                w++;
              }
            }
          }
        }else{
          neu[i]=tem_neu;
        }
      }/*else if(type[i].equals("h")){
        int x1=ker_wid[i-1]*ker_hei[i-1];
        int y1=neu_wid[i]*neu_hei[i];
        double[][][][]tem_wei=new double[map_amo[i-1]][x1][map_amo[i]][y1];
        for(int j=0;j<map_amo[i];j++){
          for(int k=0;k<y1;k++){
            for(int l=0;l<map_amo[i-1];l++){
              for(int m=0;m<x1;m++){
                tem_wei[l][m][j][k]=wei[i][l][m][j][k]*wei_c[i-1];
              }
            }
          }
        }
        for(int j=0;j<map_amo[i];j++){
          for(int k=0,x=0;k<neu_hei[i];k++){
            for(int l=0;l<neu_wid[i];l++){
              neu[i][j][x]=bia[i][j][x];
              for(int m=0;m<map_amo[i-1];m++){
                for(int n=0,y=0;n<ker_hei[i-1];n++){
                  for(int o=0,z=n*neu_wid[i-1];o<ker_wid[i-1];o++){
                    neu[i][j][x]+=neu[i-1][m][o+z]*wei[i][m][y][j][x];
                    y++;
                  }
                }
              }
              x++;
            }
          }
        }
      }*/
      if(!act_fun[i].equals("Max_Pool")&&!act_fun[i].equals("Avg_Pool")){
        int x=neu_wid[i]*neu_hei[i];
        if(act_fun[i].equals("Softmax")){
          tem=0d;
          double tem2=0d;
          for(int j=0;j<map_amo[i];j++){
            for(int k=0;k<x;k++){
              if(neu[i][j][k]>tem2){
                tem2=neu[i][j][k];
              }
            }
          }
          for(int j=0;j<map_amo[i];j++){
            for(int k=0;k<x;k++){
              neu[i][j][k]=Math.exp(neu[i][j][k]-tem2);
              tem+=neu[i][j][k];
            }
          }
          for(int j=0;j<map_amo[i];j++){
            for(int k=0;k<x;k++){
              neu[i][j][k]/=tem;
            }
          }
        }else if(act_fun[i].equals("Sigmoid")){
          for(int j=0;j<map_amo[i];j++){
            for(int k=0;k<x;k++){
              neu[i][j][k]=1d/(1d+Math.exp(-neu[i][j][k]));
            }
          }
        }else if(act_fun[i].equals("ReLU")){
          for(int j=0;j<map_amo[i];j++){
            for(int k=0;k<x;k++){
              neu[i][j][k]=(neu[i][j][k]>0d)?neu[i][j][k]:0d;
            }
          }
        }else if(act_fun[i].equals("LReLU")){
          for(int j=0;j<map_amo[i];j++){
            for(int k=0;k<x;k++){
              neu[i][j][k]=(neu[i][j][k]>0d)?neu[i][j][k]:0.2d*neu[i][j][k];
            }
          }
        }else if(act_fun[i].equals("TanH")){
          for(int j=0;j<map_amo[i];j++){
            for(int k=0;k<x;k++){
              neu[i][j][k]=Math.tanh(neu[i][j][k]);
            }
          }
        }
      }
    }
    
    /*double tem_dou;
    for(int i=0;i<tot_lay_amo;i++){
      for(int j=0;j<map_amo[i];j++){
      min_neu[i][j]=max_neu[i]=neu[i][j][0];
      for(int k=0,x=neu_wid[i]*neu_hei[i];k<x;k++){
        tem_dou=neu[i][j][k];
        if(tem_dou<min_neu[i]){
          min_neu[i]=tem_dou;
        }
        if(tem_dou>max_neu[i]){
          max_neu[i]=tem_dou;
        }
      }
      if(i!=0){
        min_wei[i]=max_wei[i]=wei[i][0][0];
        min_bia[i]=max_bia[i]=bia[i][0];
        for(int j=0;j<neu_amo[i];j++){
          tem_dou=bia[i][j];
          if(tem_dou<min_bia[i]){
            min_bia[i]=tem_dou;
          }
          if(tem_dou>max_bia[i]){
            max_bia[i]=tem_dou;
          }
          for(int k=0;k<neu_amo[i-1];k++){
            tem_dou=wei[i][k][j];
            if(tem_dou<min_wei[i]){
              min_wei[i]=tem_dou;
            }
            if(tem_dou>max_wei[i]){
              max_wei[i]=tem_dou;
            }
          }
        }
      }
      }
    }*/
  }
  double He(int a){
    //if(!act_fun[i+1].equals("Max_Pool")&&!act_fun[i+1].equals("Avg_Pool")){
    return Math.sqrt(2d/(ker_wid[a]*ker_hei[a]*map_amo[a]));
    //}
  }
  double Xavier(int a){
    return 1/Math.sqrt(ker_wid[a]*ker_hei[a]*map_amo[a]);
  }
  void Backpropagate(int a,int b,double[][]c){
    double[][][]delta=new double[tot_lay_amo][][];
    for(int i=a;i<tot_lay_amo;i++){
      delta[i]=new double[map_amo[i]][neu_wid[i]*neu_hei[i]];
    }
    delta[tot_lay_amo-1]=c;
    for(int i=tot_lay_amo-2;i>a-1;i--){
      if(type[i+1].equals("c")){
        double[][]tem_delta=new double[map_amo[i+1]][(neu_wid[i+1]-pad_wid[i+1]*2)*(neu_hei[i+1]-pad_hei[i+1]*2)];
        if(pad_wid[i+1]!=0||pad_hei[i+1]!=0){
          for(int j=0;j<map_amo[i+1];j++){
            for(int k=0,v=0;k<neu_hei[i+1]-pad_hei[i+1]*2;k++){
              for(int l=0,w=neu_wid[i+1]*(k+pad_hei[i+1])+pad_wid[i+1];l<neu_wid[i+1]-pad_wid[i+1]*2;l++){
                //tem_delta[j][v]=delta[i+1][j][w]*wei_c[i];
                tem_delta[j][v]=delta[i+1][j][w];
                v++;
                w++;
              }
            }
          }
        }else{
          for(int j=0,x=neu_wid[i+1]*neu_hei[i+1];j<map_amo[i+1];j++){
            for(int k=0;k<x;k++){
              //tem_delta[j][k]=delta[i+1][j][k]*wei_c[i];
              tem_delta[j][k]=delta[i+1][j][k];
            }
          }
        }
        if(act_fun[i+1].equals("Max_Pool")){
          for(int j=0;j<map_amo[i+1];j++){
            for(int k=0;k<(neu_wid[i+1]-pad_wid[i+1]*2)*(neu_hei[i+1]-pad_hei[i+1]*2);k++){
              delta[i][j][win_neu[i+1][j][k]]+=tem_delta[j][k];
            }
          }
          /*for(int j=0;j<map_amo[i+1];j++){
            for(int k=0,v=0,w;k<neu_hei[i+1];k++){
              for(int l=0,x=stride_hei[i]*k;l<neu_wid[i+1];l++){
                boolean brk=false;
                for(int m=0,y=stride_wid[i]*l;m<ker_hei[i];m++){
                  for(int n=0,z=neu_wid[i]*(x+m)+y;n<ker_wid[i];n++){
                    w=n+z;
                    if(neu[i][j][w]==neu[i+1][j][v]){
                      delta[i][j][w]=delta[i+1][j][v];
                      brk=true;
                      break;
                    }
                  }
                  if(brk){
                    break;
                  }
                }
                v++;
              }
            }
          }*/
        }else if(act_fun[i+1].equals("Avg_Pool")){
          for(int j=0;j<map_amo[i+1];j++){
            for(int k=0,v=ker_wid[i]*ker_hei[i],w=0;k<neu_hei[i+1]-pad_hei[i+1]*2;k++){
              for(int l=0,x=stride_hei[i]*k;l<neu_wid[i+1]-pad_wid[i+1]*2;l++){
                for(int m=0,y=stride_wid[i]*l;m<ker_hei[i];m++){
                  for(int n=0,z=neu_wid[i]*(x+m)+y;n<ker_wid[i];n++){
                    delta[i][j][n+z]=tem_delta[j][w]/v;
                  }
                }
                w++;
              }
            }
          }
        }else{
          for(int j=0;j<map_amo[i+1];j++){
            for(int k=0,v=0;k<neu_hei[i+1]-pad_hei[i+1]*2;k++){
              for(int l=0,w=k*stride_hei[i];l<neu_wid[i+1]-pad_wid[i+1]*2;l++){
                for(int m=0,x=l*stride_wid[i];m<map_amo[i];m++){
                  for(int n=0,y=0;n<ker_hei[i];n++){
                    for(int o=0,z=neu_wid[i]*(w+n)+x;o<ker_wid[i];o++){
                      delta[i][m][o+z]+=tem_delta[j][v]*wei[i+1][m][y][j][0];
                      y++;
                    }
                  }
                }
                v++;
              }
            }
          }
        }
      }
      if(!act_fun[i].equals("Max_Pool")&&!act_fun[i].equals("Avg_Pool")){
        int x=neu_wid[i]*neu_hei[i];
        if(act_fun[i].equals("Sigmoid")){
          for(int j=0;j<map_amo[i];j++){
            for(int k=0;k<x;k++){
              delta[i][j][k]*=neu[i][j][k]*(1d-neu[i][j][k]);
            }
          }
        }else if(act_fun[i].equals("ReLU")){
          for(int j=0;j<map_amo[i];j++){
            for(int k=0;k<x;k++){
              delta[i][j][k]*=(neu[i][j][k]==0d)?0d:1d;
            }
          }
        }else if(act_fun[i].equals("LReLU")){
          for(int j=0;j<map_amo[i];j++){
            for(int k=0;k<x;k++){
              delta[i][j][k]*=(neu[i][j][k]>0d)?1d:0.2d;
            }
          }
        }else if(act_fun[i].equals("TanH")){
          for(int j=0;j<map_amo[i];j++){
            for(int k=0;k<x;k++){
              delta[i][j][k]*=1d-Math.pow(neu[i][j][k],2d);
            }
          }
        }
      }
      
      /*
        print("Layer "+i+":\n\n");
        for(int j=0;j<map_amo[i];j++){
          
          print("Map "+j+":\n");
          for(int k=0,v=0;k<neu_hei[i];k++){
            
            for(int l=0,w=neu_wid[i]*(k+pad_hei[i])+pad_wid[i];l<neu_wid[i];l++){
              print(Math.round(delta[i][j][l+k*neu_wid[i]]*1000d)/1000d+", ");
            }
            
            print("\n");
          }
        }
        delay(3000);
        */
    }
    for(int i=a;i<b;i++){
      if(!act_fun[i].equals("Max_Pool")&&!act_fun[i].equals("Avg_Pool")){
        if(type[i].equals("c")){
          for(int j=0;j<map_amo[i];j++){
            for(int k=0;k<neu_hei[i]-pad_hei[i]*2;k++){
              for(int l=0,w=neu_wid[i]*(k+pad_hei[i])+pad_wid[i];l<neu_wid[i]-pad_wid[i]*2;l++){
                dbia[i][j][0]+=delta[i][j][w];
                w++;
              }
            }
          }
          for(int j=0;j<map_amo[i-1];j++){
            for(int k=0,v=0;k<ker_hei[i-1];k++){
              for(int l=0,w=stride_hei[i-1]*k;l<ker_wid[i-1];l++){
                for(int m=0,x=stride_wid[i-1]*l;m<map_amo[i];m++){
                  for(int n=0,y=0;n<neu_hei[i]-pad_hei[i]*2;n++){
                    for(int o=0,z=neu_wid[i-1]*(w+n)+x;o<neu_wid[i]-pad_wid[i]*2;o++){
                      dwei[i][j][v][m][0]+=delta[i][m][y]*neu[i-1][j][o+z];
                      y++;
                    }
                  }
                }
                v++;
              }
            }
          }
        }
      }
    }
  }
  void Adjust_All(int a,int b){
    //double par=lea_rat/bat_siz;
    for(int i=a;i<b;i++){
      if(!act_fun[i].equals("Max_Pool")&&!act_fun[i].equals("Avg_Pool")){
        if(type[i].equals("c")){
          for(int j=0,x=ker_wid[i-1]*ker_hei[i-1];j<map_amo[i];j++){
            dbia[i][j][0]/=bat_siz;
            if(opt.equals("Adam")){
              vdb[i][j][0]=beta1*vdb[i][j][0]+(1d-beta1)*dbia[i][j][0];
              sdb[i][j][0]=beta2*sdb[i][j][0]+(1d-beta2)*Math.pow(dbia[i][j][0],2d);
              bia[i][j][0]-=lea_rat*
              (vdb[i][j][0]/(1d-Math.pow(beta1,tot_ite)))
              /
              (epsilon+Math.sqrt(
              sdb[i][j][0]/(1d-Math.pow(beta2,tot_ite)))
              );
            }else{
              bia[i][j][0]-=lea_rat*dbia[i][j][0];
            }
            dbia[i][j][0]=0d;
            for(int k=0;k<map_amo[i-1];k++){
              for(int l=0;l<x;l++){
                dwei[i][k][l][j][0]/=bat_siz;
                if(opt.equals("Adam")){
                  vdw[i][k][l][j][0]=beta1*vdw[i][k][l][j][0]+(1d-beta1)*dwei[i][k][l][j][0];
                  sdw[i][k][l][j][0]=beta2*sdw[i][k][l][j][0]+(1d-beta2)*Math.pow(dwei[i][k][l][j][0],2d);
                  wei[i][k][l][j][0]-=lea_rat*
                  (vdw[i][k][l][j][0]/(1d-Math.pow(beta1,tot_ite)))
                  /
                  (epsilon+Math.sqrt(
                  sdw[i][k][l][j][0]/(1d-Math.pow(beta2,tot_ite)))
                  );
                }else{
                  wei[i][k][l][j][0]-=lea_rat*dwei[i][k][l][j][0];
                }
                dwei[i][k][l][j][0]=0d;
              }
            }
          }
        }
      }
    }
  }
}
