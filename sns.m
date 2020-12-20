
vscs1(1:772,:)=vscs(1:772,:);
vscs2(1:2316,:)=vscs(773:3088,:);
for i=1:386
    vscso(((i-1)*8+1):((i-1)*8+2),:)=vscs1(((i-1)*2+1):((i-1)*2+2),:);
    vscso(((i-1)*8+3):((i-1)*8+8),:)=vscs2(((i-1)*6+1):((i-1)*6+6),:);
end
c=387;
    for i=1:230
        vscso1(i*5-3:i*5,:)=vscs1(c:c+3,:);
        vscso2(i*5-3:i*5,:)=vscs2(c:c+3,:);
        c=c+4;
    end
    c=1;
for i=1:10:2291
    vscso(i:i+4,:)=vscso1(c:c+4,:);
    vscso(i+5:i+9,:)=vscso1(c:c+4,:);
    c=c+5;
end