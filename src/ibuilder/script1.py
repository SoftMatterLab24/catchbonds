import re
import os 
import shutil
import csv
import pandas as pd
import argparse


#creating new folders
def createFolder(src,dest):
    shutil.copytree(src,dest)


#replace text
def replace(search_text,replace_text,infile): 

    #print('Replace Specs:')
    #print('search_text: ' + search_text)
    #print('replace_text: ' + replace_text)
    #print('in_file: ' + infile)
  
    # Opening the file in read and write mode 
    with open(infile,'r+') as f: 
  
        # Reading the file data and store 
        # it in a file variable 
        file = f.read() 

        '''
        if search_text in f.read():
            print("Yes, in the file.")
        else: 
            print('No, not in the file.')
        '''
          
        # Replacing the pattern with the string 
        # in the file data 
        new_file = file.replace(search_text, replace_text) 
  
        # Setting the position to the top 
        # of the page to insert data 
        f.seek(0) 
          
        # Writing replaced data in the file 
        f.write(new_file) 
  
        # Truncating the file size 
        f.truncate() 
  
    # Return "Text replaced" string 
    return "Text replaced"


#create list of files to ignore
def ignore_files(dir,files,id,flag):

    ignored_files = []
    dat_file_to_keep = flag + '_' + id + ".dat"
    #print('to keep: ' + dat_file_to_keep)

    for f in files:
        if f.endswith('.dat') and f!= dat_file_to_keep:
            ignored_files.append(f)

    return ignored_files


#parameters



def main():


    if __name__ == "__main__":
        parser = argparse.ArgumentParser(
            description="Script that ..."
        )
        parser.add_argument("--NumRows", required=False, type=int)
        parser.add_argument("--NumDatFiles", required=False, type=int)
        parser.add_argument("--params", required=False, type=str)
        parser.add_argument("--template", required=False, type=str)
        parser.add_argument("--folder", required=False, type=str)
        parser.add_argument("--e_path", required=False, type=str)
        parser.add_argument("--lammps_path", required=False, type=str)
        parser.add_argument("--number_nodes", required=False, type=int)
        parser.add_argument("--number_processor", required=False, type=int)
        parser.add_argument("--time", required=False, type=str)
        args = parser.parse_args()

        numRowsInCSV= args.NumRows
        numDatFiles = args.NumDatFiles
        params = args.params
        template = args.template
        folder = args.folder
        e_path = args.e_path
        l_path = args.lammps_path
        number_nodes = args.number_nodes
        number_processor = args.number_processor
        run_time = args.time
    

    
    #get template file names 
    file_pbs = ''
    file_dat = ''
    file_in = ''


    # Loop through the files in the folder
    for file in os.listdir(template):
        if file.endswith('.pbs'):  
            file_pbs = file
        if file.endswith('.dat'):  
            file_dat = file
        if file.endswith('.in'):  
            file_in = file


    #delete id from dat file 
    file_dat_base = re.sub(r'_\d{3}\.dat$', '.dat', file_dat)

    # Print or store file names
    #print('file names no cat' + file_pbs + file_dat + file_in)
    #print(params)



    #variables
    src = template
    cwd = os.getcwd()

    

    #load csv into dict
    df = pd.read_csv(params, header=None)
    csv_data = df.to_dict(orient='records')

    #print(df)
    #print(csv_data)

    #store column types
    val_1 = str(df.iloc[0,0])
    val_2 = str(df.iloc[0,1])

    #print('vals ' + val_1+ ' ' + val_2)

    match = re.search(r'_(\d{3})\.dat$', file_dat)

    #Extract the digits if found
    if match:
        last_three_digits = match.group(1)  
        #print(last_three_digits)  
    else:
        print("No match found.")

    numDatFiles = int(last_three_digits)
    sweepID = template
    flag = file_dat[:-8]


    
    #loop through csv values 
    for index, row in df.iloc[1:].iterrows():

        #if (index >= numRowsInCSV):
            #break
       
        #one row of params
        params_id = '00' + str(index)

        #one dat file
        for i in range(1, numDatFiles + 1):
            
            #define destintation for directory 
            dat_id = '00' + str(i)
            batchID = sweepID + '___' + params_id
            jobID = batchID + '_' + dat_id
            dst = folder + '/' + batchID + '/'  + jobID
            
            #create folder 
            shutil.copytree(src,dst,ignore=lambda dir, files: ignore_files(dir,files,dat_id,flag))

            #edit contents of in file 
            dat_name_reg = file_dat_base
            
            val_1_rep = re.sub(r'(\d*\.?\d+)', row[0], val_1)
            val_2_rep = re.sub(r'(\d*\.?\d+)', row[1], val_2)
            dat_name_rep = flag + '_' + dat_id + '.dat'
            

            in_path = dst + '/' + file_in

            replace(val_1,val_1_rep,in_path)
            replace(val_2,val_2_rep,in_path)
            replace(dat_name_reg,dat_name_rep,in_path)

         

            #edit contents of pbs file 
            pbs_path = dst + '/sub.pbs'

            #Replace FLAG_E_PATH with executable path
            reg_e_path = 'FLAG_E_PATH'
            rep_e_path = e_path + '/' + folder + '/' + batchID + '/' + jobID + '/' + file_in

            replace(reg_e_path,rep_e_path,pbs_path)

            # Replace FLAG_LAMMPS_PATH with l_path
            reg_lammps_path = 'FLAG_LAMMPS_PATH'
            rep_lammps_path = l_path
            replace(reg_lammps_path, rep_lammps_path, pbs_path)

            # Replace FLAG_NUMBER_NODES with number_nodes
            reg_number_nodes = 'FLAG_NUMBER_NODES'
            rep_number_nodes = str(number_nodes)  # Convert to string if needed
            replace(reg_number_nodes, rep_number_nodes, pbs_path)

            # Replace FLAG_NUMBER_PROCESSORS with number_processor
            reg_number_processors = 'FLAG_NUMBER_PROCESSORS'
            rep_number_processors = str(number_processor)  # Convert to string if needed
            replace(reg_number_processors, rep_number_processors, pbs_path)

            # Replace FLAG_TIME with run_time
            reg_time = 'FLAG_TIME'
            rep_time = run_time
            replace(reg_time, rep_time, pbs_path)
            






main()