clear all
close all

dirloc = 'D:\CU_Boulder\Research\Fields\7CatchBondNetworks\Data\crack\crack300x150\slip\300x150_slipdamage';

hmdir = pwd;

cd(dirloc)


    listing = dir(pwd);
    kk = 0;
    for jj = 1:length(listing)
        
        if contains(listing(jj).name,'frame')
            kk = kk + 1;
            names{kk} = listing(jj).name;
            D{kk} = imread(names{kk});
            %imshow(D{kk})
        end
     end


for ii = [1 50]
    %get frame
    frame = im2gray(D{ii});

    %convert to binary
    BW = imbinarize(frame);

    %remove edge
    if ii == 1
        mask = ~bwareafilt(BW,[1e5 1e10]);
        %imshow(mask)
    end
    
    maskedBW = logical(mask.*BW);
    %imshow(maskedBW)
    % Get region properites
    % CC = bwconncomp(BWfilt1);
    % p = regionprops(CC);
    % histogram([p.Area])
    
    %remove small voids (1-50)
    BWfilt2 = bwareafilt(maskedBW,[300 1e10]);

    out = bwskel(BWfilt2);
    outdil = imdilate(out,strel('disk',5));
    
    %imshow(outdil)
    %imshow(labeloverlay(frame,outdil,'Transparency',0,'Colormap','autumn'))

    if ii == length(D)
        figure(99)
        imshow(labeloverlay(frame,bwareafilt(outdil,[3000 1e10]),'Transparency',0,'Colormap','autumn'))
        
       cd(hmdir)
       im = bwareafilt(outdil,[3000 1e10]);
       %fractal dimension of percolating crack
       dim_val = BoxCountfracDim(im);
    end
end