# About this script
This bash script renames image files according to their last modified date.  
When starting the script, you will be asked a few questions.  
1. Please enter a destination folder
2. Please enter a prefix if you wish to use one
3. Please enter a start date (format YYYYMMDD)
4. If applicable, please enter an end date (format YYYYMMDD)
5. Please enter the destination extension
6. Do you wish to delete the original files? (Y/N)

The script has to be started in the folder the pictures lie in. It is important to note, that it will run through all pictures in the folder reading their modification date and only processing the ones in a specific time range. So this might not be as performant as it could be.  
For question 1, enter the absolute or relative path to the destination folder, in which the renamed pictures should be saved.  
Question 2 asks for a prefix that you might use in the desired file names. If you do not need it, just press enter to continue.  
The 3rd question asks for a start date. You will have to specify it in the provided format.  
The same applies for the end date. If it is not provided, it will be the current date.  
In the fourth question, you may specify a certain extension to use for the files. But please note, that all extensions will be in lower case letters. The script will also check, if the extension can be applied to the file. If not, the first default extension for the file will be used. If not specified, the parameter will be set to "jpg".  
Finally, the last question asks if the old files should be deleted. A "Y" will result in deletion. Any other input will be considered as a "no".  

As a result, you will end up with a file name along this line: ```<prefix><YYYYMMDD>_<counter>.<extension>```

![image](https://user-images.githubusercontent.com/72335980/170147597-25b33dee-ee59-4acb-88d1-7e4e527e1a91.png)
