function [] = buildRun(RunDirectory,inputdir)

cd(RunDirectory)

BatchFilename = 'run.sh';
fid = fopen(BatchFilename,'w');
%fprintf(fid,'#!/bin/bash\n');
for ii = 1:length(inputdir)
    fprintf(fid,char(strcat('cd',{' '},inputdir{ii},'/')));
    fprintf(fid,'\n mpirun -np 8 /home/zwhite/lammps/build/lmp -in verify.in\n');
    fprintf(fid,'cd ../ \n');
end
fclose(fid);


end