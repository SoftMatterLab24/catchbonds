function buildData(HomeDir,RunDirectory,RunName,del)

cd(HomeDir)

%Read
InputFilename = 'verify_nobonds.dat';
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

%Edit
%strcat('2 1 1 ',num2str(del),' 0 0')
%num2str(del)
%strcat('2 1 1',{' '},num2str(del),' 0 0')
A(14) = strcat('2 1 1 ',{' '},num2str(del),' 0 0');

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

cd(RunDirectory)

end