#!/bin/bash
load 'user_input.sh'

echo -n "Please enter a destination folder: "
destination_folder=$(get_destination)
if ! [[ -d $destination_folder ]]; then
	echo "This folder does not exist... exiting"
	exit 1
fi

echo -n "Please enter a prefix if you wish to use one: "
prefix=$(get_prefix)

echo -n "Please enter a start date (format YYYYMMDD): "
startdate=$(get_startdate)
while ! [[ $startdate =~ ^[0-9]{8}$ ]]; do
	echo -n "Format is wrong... try again: "
	startdate=$(get_startdate)
done

echo -n "If applicable, please enter an end date (format YYYYMMDD): "
enddate=$(get_enddate)
if [[ $enddate == "" ]]; then
	enddate=$(date +"%Y%m%d")
	echo "-> setting to " $enddate
fi

echo -n "Please enter the destination extension: "
destination_extension=$(get_destination_extension)
if [[ $destination_extension == "" ]]; then
	destination_extension="jpg"
	echo "-> setting to "$destination_extension
fi

echo -n "Do you wish to delete the original files? (Y/N): "
delete_originals=$(get_delete_originals)

echo "### START"
source_path=$(pwd)
echo "scanning folder: " $source_path

# counter for file names
counter=0
# last change:
last_change=0
# find all pictures in directory:
find * -maxdepth 0 -type f -name "*" -exec file --mime-type {} \+ | awk -F: '{if ($2 ~/image\//) print $1}' | while IFS= read -r original_file; do 
 	# grab string containing change date from stat command:
 	# also: remove - and only grab date from date time string
 	change="$(stat --format=%y $original_file | sed -e 's/-//g' | sed -E 's|[^0-9]*([0-9]{8}).*|\1|')"
 	
 	# set parsing delimiter to space and parse change date to array:
 	IFS=" "
 	tmp_change_array=($change)
	unset IFS
	
	# only process pictures in the specific time range:
	if [[ $change -ge $startdate ]] && [[ $change -le $enddate ]]; then
		echo "... found file: " $original_file " (" $change ")"
		# different change date than before -> start at counter=0 again:
		if [ $change -ne $last_change ]; then
			last_change=$change
			counter=0
		fi
		
		# check if desired extension is allowed, if not, change it
		possible_extensions=$(file --extension $original_file | sed -E 's|.*: ([a-zA-Z/0-9]*)|\1|')
		local_dest_extension="${destination_extension,,}"
		if ! grep "$local_dest_extension" <<< "$possible_extensions"; then
			local_dest_extension="$(echo $possible_extensions | sed -E 's|^([^/]*).*|\1|')"
			echo "setting extension to "$local_dest_extension
		fi
		

		# check if new_filename exists, if yes, increment counter:
		while test -e "$destination_folder"/"$change"_"$counter"."$local_dest_extension"; do
			((counter=counter+1))
		done
		
		new_filename=$prefix$change"_"$counter"."$local_dest_extension
		echo "renaming: "$original_file" -> "$new_filename
		# move source file to destination file name:
		cp -i $original_file $destination_folder/$new_filename
		
		# catching copy error:
		if [ $? -ne 0 ]; then
			echo "a copy error occured - exiting"
			exit 1
		fi
		
		# delete file if selected:
		if [[ $delete_originals  == "Y" ]]; then 
			echo "deleting "$original_file
			rm $original_file
		fi
		
		# increment counter:
		((counter=counter+1))
	fi
	
done
echo "### END"
