function QuadBTCDecom(t,prethre,postthre,m,n)
global output;
avg=mean2(t);
tmp=repmat(avg,m,n);
if(immse(tmp,t)<=prethre)%inactive
    fprintf(output,'%s','0');
    fprintf(output,'%s',dec2bin(round(avg),8));
elseif(m==4&&n==4)%can not divide
    fprintf(output,'%s','1');
    q=0;p=0;xh=0;xl=0;
    for i=1:4
        for j=1:4
            if(t(i,j)>=avg)
                xh=xh+t(i,j);
                q=q+1;
            else
                xl=xl+t(i,j);
                p=p+1;
            end
        end
    end
    xh=round(xh/q);
    xl=round(xl/p);
    high=(t>=avg)*xh;%attempt to decode
    low=(t<avg)*xl;
    recon=high+low;
    if(immse(recon,t)<=postthre)%using AMBTC to encode
        fprintf(output,'%s','1');
        for i=1:4
            for j=1:4
                if(t(i,j)>=avg)fprintf(output,'%s','1');
                else fprintf(output,'%s','0');
                end
            end
        end
        fprintf(output,'%s',dec2bin(xh,8));
        fprintf(output,'%s',dec2bin(xl,8));
    else %using 2-bit-plane to encode
        fprintf(output,'%s','0');
        pix=sort(t(:));
        quan(4)=sum(pix(13:16))/4;
        quan(1)=sum(pix(1:4))/4;
        quan(2)=quan(1)*2/3+quan(4)/3;
        quan(3)=quan(1)/3+quan(4)*2/3;
        fprintf(output,'%s',dec2bin(round(quan(1)),8));
        fprintf(output,'%s',dec2bin(round(quan(2)-quan(1)),7));
        for i=1:4
            for j=1:4
                x=abs(t(i,j)-quan);
                ind=find(x==min(x));
                if(ind==1)fprintf(output,'%s','00');
                elseif(ind==2)fprintf(output,'%s','01');
                elseif(ind==3)fprintf(output,'%s','10');
                else fprintf(output,'%s','11');
                end
            end
        end
    end
elseif((m==16&&n==16)||(m==8&&n==8))
    fprintf(output,'%s','1');
    global sob_hor;global sob_ver;
    hor=filter2(sob_hor,t,'valid');
    ver=filter2(sob_ver,t,'valid');
    edge_hor=sum(abs(hor(:)));
    edge_ver=sum(abs(ver(:)));
    if(edge_hor>=edge_ver)
        fprintf(output,'%s','1');%divide vertically
        QuadBTCDecom(t(1:m/2,:),prethre,postthre,m/2,n);
        QuadBTCDecom(t(m/2+1:m,:),prethre,postthre,m/2,n);
    else
        fprintf(output,'%s','0');%divide horizontally
        QuadBTCDecom(t(:,1:n/2),prethre,postthre,m,n/2);
        QuadBTCDecom(t(:,n/2+1:n),prethre,postthre,m,n/2);
    end
else %m is not equal to n
    fprintf(output,'%s','1');
    if(m>n)
        QuadBTCDecom(t(1:m/2,:),prethre,postthre,m/2,n);
        QuadBTCDecom(t(m/2+1:m,:),prethre,postthre,m/2,n);
    else
        QuadBTCDecom(t(:,1:n/2),prethre,postthre,m,n/2);
        QuadBTCDecom(t(:,n/2+1:n),prethre,postthre,m,n/2);
    end
end