clear;close all;clc;
folderread = 'E:\datasets\03 MSR Daily Activity 3D dataset\Depth';
folderwrite = 'C:\Users\doufu\Desktop\MyDailyBin';

count = 0;

for ai = 1:16
    for si = 1:10
        for ei = 1:2
            [acsr,susr,exsr]=getsr(ai,si,ei);

            pathread = [folderread,'\a',acsr,'_s',susr,'_e',exsr,'_depth.bin'];
            pathwrite = [folderwrite,'\a',acsr,'_s',susr,'_e',exsr,'_sdepth.bin'];
            
            if ~exist(pathread,'file');
                disp('error');
                continue;
            end;
            if ~exist(folderwrite, 'dir');
                mkdir(folderwrite);
            end
            disp(pathread);
            
            fileread = fopen(pathread);
            filewrite = fopen(pathwrite, 'wb');       
            if fileread<0 || filewrite<0
                disp('no such file or create file fail.');
                return;
            end
            
            header = fread(fileread,3,'uint=>uint');
            nnof = header(1); ncols = header(2); nrows = header(3);
            fwrite(filewrite,[nnof, ncols, nrows],'uint');
            
            for f = 1:nnof
                frame = zeros( ncols, nrows);
                for row = 1:nrows
                    tempRow = fread(fileread, ncols, 'uint=>uint');
                    tempRowID = fread(fileread, ncols, 'uint8');
                    frame(:,row) = tempRow;
                end
                fwrite(filewrite, frame, 'uint');
                clear tempRow tempRowID;
            end
            
            fclose(fileread);
            fclose(filewrite);
            count = count+1;
            clear fileread filewrite pathread pathwrite; 
        end
    end
end
disp(['converted ', count, ' files.']);