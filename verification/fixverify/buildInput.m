function buildInput(HomeDir,RunDirectory,RunName)

cd(HomeDir)

%Read
InputFilename = 'verify.in';
fid = fopen(InputFilename,'r');
i = 1;
tline = fgetl(fid);
A{i} = tline;
while ischar(tline)
    i = i+1;
    tline = fgetl(fid);
    A{i} = tline;
end
fclose(fid);


A(86) = strcat('fix             dynamics all bond/dynamic 1 1 1 ${ka} ${kd} ${Lmax} seed ',{' '},num2str(ceil(10000*rand(1))),{' '},'catch',{' '},num2str(0.05),{' '},num2str(0.3),{' '},num2str(10));
%Write
cd(strcat(RunDirectory,'\',RunName))
fid = fopen(InputFilename, 'w');
for i = 1:numel(A)
    if A{i+1} == -1
        fprintf(fid,'%s', A{i});
        break
    else
        fprintf(fid,'%s\n', A{i});
    end
end
fclose(fid);

cd(HomeDir)

end