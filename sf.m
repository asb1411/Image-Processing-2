function [per,sfv,ml,fv,id,cen,ds] = sf(numVar,numImg)
c=1;
p=1;
cls=zeros(numVar*numImg,1);
ln=zeros(9,numVar*numImg,1);
cc=cell([9,1]);
sm=zeros(9,1);

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

p=p-1;
c=c-1;
cen=cell([1,9]);
ml=cell([1,9]);

for k=1:9
[id,cen{k},~,ds]=kmeans(cc{k},200);
fv=zeros(numVar*numImg,200);
t=1;

for op=1:numVar*numImg
    temp=id(t:(t+ln(k,op,1)-1));
    tik=zeros(1,200);
    for po=1:length(temp)
        tik(temp(po))=tik(temp(po))+1;
        fv(op,temp(po))=fv(op,temp(po))+ds(po+t-1,temp(po));
    end
    for poo=1:200
        if tik(poo)~=0
            fv(op,poo)=fv(op,poo)/tik(poo);
        end
    end
    t=t+ln(k,op,1);
end

%ml{k}=fitcecoc(fv, cls, 'Coding', 'onevsall', 'Learners', 'svm');
ml{k}=fitcknn(fv, cls);

end

nc=0;
crt=0;
tcc=cell([9,1]);
labelIdx=zeros(9,1);
score=zeros(9,1);

for in=1:numVar
    for ii=5
        if(in<10)
            apa="00"+in+"_"+ii+".bmp";
        end
        if(in>9 && in<100)
            apa="0"+in+"_"+ii+".bmp";
        end
        if(in>99)
            apa=""+in+"_"+ii+".bmp";
        end
    %ap=newRoi(apa);
        
    try
    ap=imread(apa);
    
    catch
        continue
    end
    [dt,mt,crdt]=sift(ap);
    
    dmt=zeros(length(mt),131);
    dmt(:,1)=mt;
    dmt(:,2:129)=dt;
    dmt(:,130:131)=crdt;
    
    dm=sortrows(dmt);
    
    dtt=dm(:,2:129);
    mtt=dm(:,1);
    crdtt=dm(:,130:131);
    
    h=mtt(1:(floor(length(mtt)*0.8)));
    j=dtt(1:(floor((size(dtt,1))*0.8)),1:128);
    hh=crdtt(1:(floor((size(crdtt,1))*0.8)),1:2);
    
    for k=1:length(h)
    for q=1:3
        if hh(k,1)<=50*q
            for w=1:3
                if hh(k,2)<=50*w
                    tcc{(q-1)*3+w}(end+1,:)=j(k,:);
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
    tmp=zeros(200,1);
    p=zeros(1,200);
    sfv=zeros(1,200);
    for rt=1:size(tcc{k},1)
        for tr=1:200
            tmp(tr)=norm(tcc{k}(rt,:)-cen{k}(tr,:));
        end
        [mnv,mind]=min(tmp);
        
        sfv(mind)=sfv(mind)+mnv;
        p(mind)=p(mind)+1;
    end
    for tt=1:200
            if p(tt)~=0
                sfv(tt)=sfv(tt)/p(tt);
            end
    end
    
    labelIdx(k) = predict(ml{k},sfv);
    
    end
    
    [qqqq,~,eeee]=mode(labelIdx);
    an=qqqq;
%     amb=ones(size(eeee{1},1),2);
%     if size(eeee{1},1)~=1
%         for tyu=1:size(eeee{1},1)
%             amb(tyu,1)=eeee{1}(tyu);
%             for uyt=1:9
%                 if labelIdx(uyt)==eeee{1}(tyu)
%                     amb(tyu,2)=amb(tyu,2)*score(uyt);
%                 end
%             end
%         end
%         [~,index]=max(amb(:,2));
%         an=amb(index,1);
%     end
     
                    
    if an==in
        crt=crt+1;
    end
    nc=nc+1;
%     try
%     app=divImg(ap);
%     appd=gmf(app);
%     aan=predict(ml, appd);
%     if str2num(aan{1})==in
%         crt=crt+1;
%     end
% %     if aan==in
% %         crt=crt+1;
% %     end
%     nc=nc+1;
%     catch
%         err=[err; nc-1];
%     end
    per=(crt/nc)*100;
    %t="s"+apa;
    %imwrite(ap, t);
    end
    
end



end

