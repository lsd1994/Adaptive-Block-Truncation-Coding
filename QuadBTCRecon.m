function y=QuadBTCRecon(c,row,col)
global pos;
if(c(pos)=='0')%inactive
    tmp=c(pos+1:pos+8);
    y=bin2dec(tmp);
    y=repmat(y,row,col);
    pos=pos+9;
elseif(row==4&&col==4)
    pos=pos+1;
    y=zeros(4,4);
    if(c(pos)=='1')
        xh=bin2dec(c(pos+17:pos+24));
        xl=bin2dec(c(pos+25:pos+32));
        k=1;
        for i=1:4
            for j=1:4
                if(c(pos+k)=='1')y(i,j)=xh;
                else y(i,j)=xl;
                end
                k=k+1;
            end
        end
        pos=pos+33;
    else
        quan=bin2dec(c(pos+1:pos+8));
        l=bin2dec(c(pos+9:pos+15));
        for i=1:4
            for j=1:4
                str=c(pos+8*i+2*j+6:pos+8*i+2*j+7);
                if(str=='00')y(i,j)=quan;
                elseif(str=='01')y(i,j)=quan+l;
                elseif(str=='10')y(i,j)=quan+2*l;
                else y(i,j)=quan+3*l;
                end
            end
        end
        pos=pos+48;
    end
elseif((row==16&&col==16)||(row==8&&col==8))
    pos=pos+1;
    if(c(pos)=='1')
        pos=pos+1;
        y=[QuadBTCRecon(c,row/2,col);QuadBTCRecon(c,row/2,col)];
    else
        pos=pos+1;
        y=[QuadBTCRecon(c,row,col/2),QuadBTCRecon(c,row,col/2)];
    end
else
    pos=pos+1;
    if(row>col)y=[QuadBTCRecon(c,row/2,col);QuadBTCRecon(c,row/2,col)];
    else y=[QuadBTCRecon(c,row,col/2),QuadBTCRecon(c,row,col/2)];
    end
end