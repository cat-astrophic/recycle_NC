# This script parses recycling data frokm pdfs for a small project on recycling in NC

# Importing required modules

import pandas as pd
from glob import glob
import PyPDF2

# Where the pdfs are stored

username = ''
direc = 'C:/Users/' + username + '/Documents/Data/recycle_nc/'

# Using glob.glob to create a list of all pdfs

pdfs = glob(direc + 'pdfs/*')

# Data storage

df_total = pd.DataFrame()
df_common = pd.DataFrame()

# Extracting the county level recycling data from the pdfs

for p in pdfs:
    
    # Creating the pdf object
    
    pdfobj = open(p, 'rb')
    
    # Creating pdf reader objects with PyPDF2
    
    pdfReader = PyPDF2.PdfFileReader(pdfobj)
    
    # Specifying document page count
    
    if p[-11:] == '2020-21.pdf':
        
        k = 4
        
    else:
        
        k = 3
    
    # Raw data from document storage list
    
    extracted_text = ['1']
    
    # Extracting text from each page
    
    for page in range(k):
        
        # Getting the text off of the pdf
        
        pageObj = pdfReader.getPage(page)
        text = pageObj.extractText()
        
        # Formatting trick
        
        text = text.replace('2\n \n \n19','19').replace('3\n \n \n55','55').replace('4\n \n \n90','90').replace('\n \n \n','\n \n').replace('\nGATES\n \nCOUNTY','\nGATES COUNTY')
        
        # Actual extraction process
        
        if page == 0:
            
            idx = text.find('\n1\n ')
            text = text[idx+5:]
            
            while idx > 0:
                
                idx = text.find('\n \n')
                extracted_text.append(text[:idx].replace('\n','').upper())
                text = text[idx+3:]
                
            if extracted_text[-1] == '':
                
                extracted_text = extracted_text[:-1]
                
        else:
            
            idx = 12
            
            while idx > 0:
                
                idx = text.find('\n \n')
                extracted_text.append(text[:idx].replace('\n','').upper())
                text = text[idx+3:]
                
            if extracted_text[-1] == '':
                
                extracted_text = extracted_text[:-1]
                
    # Organized data storage lists
    
    if p[-11:] == '2016-17.pdf':
        
        counties_total = [extracted_text[t] for t in range(len(extracted_text)) if t%6 == 1]
        counties_common = [extracted_text[t] for t in range(len(extracted_text)) if t%6 == 4]
        values_total = [extracted_text[t] for t in range(len(extracted_text)) if t%6 == 2]
        values_common = [extracted_text[t] for t in range(len(extracted_text)) if t%6 == 5]
        
    else:
        
        counties_total = [extracted_text[t] for t in range(len(extracted_text)) if t%6 == 4]
        counties_common = [extracted_text[t] for t in range(len(extracted_text)) if t%6 == 1]
        values_total = [extracted_text[t] for t in range(len(extracted_text)) if t%6 == 5]
        values_common = [extracted_text[t] for t in range(len(extracted_text)) if t%6 == 2]
    
    # Appending parsed data to df
    
    year = pd.Series([p[-11:-4]]*len(counties_total), name = 'Year')
    counties_total = pd.Series(counties_total, name = 'County')
    counties_common = pd.Series(counties_common, name = 'County')
    values_total = pd.Series(values_total, name = 'Total')
    values_common = pd.Series(values_total, name = 'Common')
    
    tmp_total = pd.concat([counties_total,year,values_total], axis = 1)
    tmp_common = pd.concat([counties_common,year,values_common], axis = 1)
    
    df_total = pd.concat([df_total,tmp_total], axis = 0).reset_index(drop = True)
    df_common = pd.concat([df_common,tmp_common], axis = 0).reset_index(drop = True)
    
# Create a final dataframe

df = pd.merge(df_total, df_common, on = ['County','Year']).reset_index(drop = True)

# Write df to file

df.to_csv(direc + 'data/recycling_data.csv', index = False)

