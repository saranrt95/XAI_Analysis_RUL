
clear;
train=load('train_FD001.txt');
RUL=load('RUL_FD001.txt');
fid = fopen('tr1.txt','wt');

%%%%%%%%%%%%%%%%%%%%%%%
fprintf(fid,'Traj_ID\tWindow_ID\t');
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

WindowLength = 40;

MaxRUL = size(RUL,1);

row_global = 1;   

for indexRUL = 1:MaxRUL
    
    tt = train(train(:,1)==indexRUL,:);
    rowtt = size(tt,1);
    columntt = size(tt,2);

    RefRUL = RUL(indexRUL,1);

   
    tt(:,columntt+1) = 0;
    for ii = 0:rowtt-1
        tt(rowtt-ii,columntt+1) = RefRUL + ii + 1;
    end

    
    for shift = 1:(rowtt - WindowLength + 1)

        out(row_global,1) = indexRUL;   % traj_id
        out(row_global,2) = shift;      % sample_id
    
        for indexfeature = 1:24
            
            col_base = 3 + 4*(indexfeature-1);
    
            window_data = tt(shift:shift+WindowLength-1,2+indexfeature);
    
            out(row_global,col_base)   = mean(window_data);
            out(row_global,col_base+1) = var(window_data);
            out(row_global,col_base+2) = skewness(window_data);
            out(row_global,col_base+3) = kurtosis(window_data);
    
        end
        
        RULL = mean(tt(shift:shift+WindowLength-1,columntt+1));
        out(row_global,24*4+3) = RULL;
    
        if(RULL>150) 
            RULclass=1;
        elseif(RULL>50) 
            RULclass=0;
        else
            RULclass=-1;
        end
    
        out(row_global,24*4+4) = RULclass;
    
        row_global = row_global + 1;
    end
    
end


for ii = 1:size(out,1)
    fprintf(fid,'%g\t',out(ii,:));
    fprintf(fid,'\n');
end

fclose(fid);