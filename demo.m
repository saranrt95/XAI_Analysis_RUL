
clear;
train=load('train_FD001.txt');
RUL=load('RUL_FD001.txt');
fid = fopen('tr1.txt','wt');
%%%%%%%%%%%%%%%%%%%%%%%
fprintf(fid,'m_os1\tv_os1\ts_os1\tk_os1\t');
fprintf(fid,'m_os2\tv_os2\ts_os2\tk_os2\t');
fprintf(fid,'m_os3\tv_os3\ts_os3\tk_os3\t');
fprintf(fid,'m_T2\tv_T2\ts_T2\tk_T2\t');
fprintf(fid,'m_T24\tv_T24\ts_T24\tk_T24\t');
fprintf(fid,'m_T30\tv_T30\ts_T30\tk_T30\t');
fprintf(fid,'m_T50\tv_T50\ts_T50\tk_T50\t');
fprintf(fid,'m_P2\tv_P2\ts_P2\tk_P2\t');
fprintf(fid,'m_P15\tv_P15\ts_P15\tk_P15\t');
fprintf(fid,'m_P30\tv_P30\ts_P30\tk_P30\t');
fprintf(fid,'m_Nf\tv_Nf\ts_Nf\tk_Nf\t');
fprintf(fid,'m_Nc\tv_Nc\ts_Nc\tk_Nc\t');
fprintf(fid,'m_epr\tv_epr\ts_epr\tk_epr\t');
fprintf(fid,'m_Ps30\tv_Ps30\ts_Ps30\tk_Ps30\t');
fprintf(fid,'m_phi\tv_phi\ts_phi\tk_phi\t');
fprintf(fid,'m_NRf\tv_NRf\ts_NRf\tk_NRf\t');
fprintf(fid,'m_NRc\tv_NRc\ts_NRc\tk_NRc\t');
fprintf(fid,'m_BPR\tv_BPR\ts_BPR\tk_BPR\t');
fprintf(fid,'m_farB\tv_farB\ts_farB\tk_farB\t');
fprintf(fid,'m_htBleed\tv_htBleed\ts_htBleed\tk_htBleed\t');
fprintf(fid,'m_Nf_dmd\tv_Nf_dmd\ts_Nf_dmd\tk_Nf_dmd\t');
fprintf(fid,'m_PCNfR_dmd\tv_PCNfR_dmd\ts_PCNfR_dmd\tk_PCNfR_dmd\t');
fprintf(fid,'m_W31\tv_W31\ts_W31\tk_W31\t');
fprintf(fid,'m_W32\tv_W32\ts_W32\tk_W32\t');
fprintf(fid,'RUL\t');
fprintf(fid,'RULclass\n');
%%%%%%%%%%%%%%%%%%%%%%%

s=size(RUL(:,1)); MaxRUL=s(1,1);
for indexRUL = 1:MaxRUL

    tt=train(train(:,1)==indexRUL,:); ttT=tt'; s=size(ttT(1,:)); dim=s(1,2);
    
    if(0) 
        dim=floor(dim/4); 
        tt=hampel(tt);
    end

    for indexfeature = 1:24

        out(indexRUL,(1+4*(indexfeature-1)))=mean(tt(1:dim,2+indexfeature)); 
        out(indexRUL,(2+4*(indexfeature-1)))=var(tt(1:dim,2+indexfeature)); 
        out(indexRUL,(3+4*(indexfeature-1)))=skewness(tt(1:dim,2+indexfeature)); 
        out(indexRUL,(4+4*(indexfeature-1)))=kurtosis(tt(1:dim,2+indexfeature));     

    end % for indexfeature
    
    RRUL=RUL(tt(1,1),1);
    out(indexRUL,24*4+1)=RRUL;
    if(RRUL>125) 
        RULclass=1;%'healthy';
    elseif(RRUL<125 && RRUL>50) 
        RULclass=0;%'critical';
    else
        RULclass=-1;%'fault';
    end
    out(indexRUL,24*4+1+1)=RULclass;

end %for indexRUL

for ii = 1:size(out,1)
    fprintf(fid,'%g\t',out(ii,:));
    fprintf(fid,'\n');
end
fclose(fid);

%%%% END here %%%%

if(0)
    dimQuater=dim/4; dimQuater=round(dimQuater)-1;
    for i = 1:4 out(i)=mean(tt((1+dimQuater*(i-1)):dimQuater*i,3)); end
    for i = 1:4 out(i+4)=var(tt((1+dimQuater*(i-1)):dimQuater*i,3)); end
    for i = 1:4 out(i+8)=skewness(tt((1+dimQuater*(i-1)):dimQuater*i,3)); end
    for i = 1:4 out(i+12)=kurtosis(tt((1+dimQuater*(i-1)):dimQuater*i,3)); end
end