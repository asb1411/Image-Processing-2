% [imds,imgs,cls,c,fv,nc,per3]=rungmf(230,4,250,0.25); [imds,imgs,cls,c,fv,nc,per4]=rungmf(230,4,250,0.4); 
% [imds,imgs,cls,c,fv,nc,per5]=rungmf(230,4,250,0.6); [imds,imgs,cls,c,fv,nc,per6]=rungmf(230,4,350,0.3);
% [imds,imgs,cls,c,fv,nc,per7]=rungmf(230,4,350,0.5); [imds,imgs,cls,c,fv,nc,per8]=rungmf(230,4,350,0.7);
% [imds,imgs,cls,c,fv,nc,per9]=rungmf(230,4,500,0.3); [imds,imgs,cls,c,fv,nc,per10]=rungmf(230,4,500,0.5);
% [imds,imgs,cls,c,fv,nc,per11]=rungmf(230,4,500,0.75); [imds,imgs,cls,c,fv,nc,per12]=rungmf(230,4,500,0.25);
% [imds,imgs,cls,c,fv,nc,per13]=rungmf(230,4,600,0.35); [imds,imgs,cls,c,fv,nc,per14]=rungmf(230,4,600,0.55);
[imds,imgs,cls,c,fv,nc,per16]=rungmf(230,4,750,0.4);[imds,imgs,cls,c,fv,nc,per17]=rungmf(230,4,750,0.5);
[imds,imgs,cls,c,fv,nc,per18]=rungmf(230,4,750,0.7);[imds,imgs,cls,c,fv,nc,per15]=rungmf(230,4,750,0.8);


c=1;
p=1;
cls=zeros(230*4,1);
ln=zeros(9,230*4,1);
sm=zeros(9,1);
cc=cell([9,1]);

for in=1:230
for ii=1:4
    
    if(in<10)
        apa="00"+in+"_"+ii+".bmp";
    end
    
    if(in>9 && in<100)
        apa="0"+in+"_"+ii+".bmp";
    end
    
    if(in>99)
        apa=""+in+"_"+ii+".bmp";
    end
    cls(p)=in;
    ap=imread(apa);
    [dt,mt,crdt]=sift(ap);
    dmt=zeros(length(mt),131);
    dmt(:,1)=mt;
    dmt(:,2:129)=dt;
    dmt(:,130:131)=crdt;
    dm=sortrows(dmt);
    dtt=dm(:,2:129);
    mtt=dm(:,1);
    crdtt=dm(:,130:131);
    m=mtt(1:(floor(length(mtt)*0.8)));
    d=dtt(1:(floor((size(dtt,1))*0.8)),1:128);
    crd=crdtt(1:(floor((size(crdtt,1))*0.8)),1:2);
    
    for k=1:length(m)
    for q=1:3
        if crd(k,1)<=50*q
            for w=1:3
                if crd(k,2)<=50*w
                    cc{(q-1)*3+w}(end+1,:)=d(k,:);
                    c=2;
                    continue
                end
            end
        end
            if c==2
                c=c-1;
                continue
            end
    end
    end
    
    for k=1:9
        ln(k,p,1)=size(cc{k},1)-sm(k);
        sm(k)=size(cc{k},1);
    end
    
            
       
%     ln(p)=length(m);
%     for k=1:length(m)
%         cd(c+k-1,:)=d(k,1:128);
%     end
%     c=c+length(m);
     p=p+1;
    
end
end






addpath('C:\Users\ameya\Documents\MATLAB\PRoiN');
msmat=zeros(numVar*numImg,100);
cls=zeros(numVar*numImg,1);
c=1;
err=[];
%ca=cell([numVar*numImg,1]);
for in=1:numVar
for ii=1:numImg
%     if(in<10)
%         apa="00"+in+"_"+ii+".bmp";
%     end
%     if(in>9 && in<100)
%         apa="0"+in+"_"+ii+".bmp";
%     end
%     if(in>99)
%         apa=""+in+"_"+ii+".bmp";
%     end

    if(in<10)
        apa="00"+in+"_"+"F"+"_"+"0"+ii+".bmp";
    end
    
    if(in>9 && in<100)
        apa="0"+in+"_"+"F"+"_"+"0"+ii+".bmp";
    end
    
    if(in>99)
        apa=""+in+"_"+"F"+"_"+"0"+ii+".bmp";
    end
    
    apa="ROI-"+apa;
    
      try
    ty=imread(apa);
    catch
        continue
    end 
    if ty==0
        continue
    end
    try
     app=divImg(ty);
     appd=meanStd(app);
     msmat(c,:)=appd;
    cls(c)=in;
    c=c+1;
    catch
        err=[err; c-1];
    end
    
end
end

ml=fitcecoc(msmat, cls, 'Coding', 'onevsall', 'Learners', 'svm');







msmat=zeros(numVar*numImg,100);
cls=zeros(numVar*numImg,1);
c=1;
err=[];

for in=1:numVar
for ii=1:numImg

        if(in<10)
        apa="00"+in+"_"+ii+".bmp";
    end
    if(in>9 && in<100)
        apa="0"+in+"_"+ii+".bmp";
    end
    if(in>99)
        apa=""+in+"_"+ii+".bmp";
    end
try
    ty=imread(apa);
    catch
        continue
    end 
    if ty==0
        continue
    end
    try
     app=divImg(ty);
     appd=meanStd(app);
     msmat(c,:)=appd;
    cls(c)=in;
    c=c+1;
    catch
        err=[err; c-1];
    end
    
end
end

clss=[];
clss(1:4)=1;
clss(5:230*4)=0;
ml=fitcsvm(msmat,clss,'Nu',0.2);
ml2=fitcsvm(msmat,clss,'Nu',0.8);

crt=0;crt2=0;
fr=0;fr2=0;
c=1;
sc=[];sc2=[];
for in=1:numVar
 for  ii=1:5
        if(in<10)
            apa="00"+in+"_"+ii+".bmp";
        end
        if(in>9 && in<100)
            apa="0"+in+"_"+ii+".bmp";
        end
        if(in>99)
            apa=""+in+"_"+ii+".bmp";
        end
     ap=imread(apa);
     app=divImg(ap);
     appd=meanStd(app);
     [aan,s]=predict(ml, appd);
     [aan2,s2]=predict(ml2, appd);
     sc(c,:)=s;sc2(c,:)=s2;
     c=c+1;
     if in==1
         if aan==1
             crt=crt+1;
         end
         if aan2==1
             crt2=crt2+1;
         end
     end
            
     if in~=1
         if aan==1
             fr=fr+1;
         end
         if aan2==1
             fr2=fr2+1;
         end
     end
 end
end





