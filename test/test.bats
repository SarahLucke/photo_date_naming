
setup() {
    load 'test_helper/common-setup'
    _common_setup
}

teardown() {
    unset get_destination
    unset get_prefix
    unset get_startdate
    unset get_enddate
    unset get_destination_extension
    unset get_delete_originals
	cd ../
	rm -r new
	rm -r original
}

@test "positive file copying without delete" {
    # source user input functions to be able to mock them
	source user_input.sh
    function get_destination() { echo "../new"; }
	export -f get_destination
    function get_prefix() { echo ""; }
	export -f get_prefix
    function get_startdate() { echo $(date +"%Y%m%d"); }
	export -f get_startdate
    function get_enddate() { echo $(date +"%Y%m%d"); }
	export -f get_enddate
    function get_destination_extension() { echo "jpg"; }
	export -f get_destination_extension
    function get_delete_originals() { echo "N"; }
	export -f get_delete_originals
	
    # As we added src/ to $PATH, we can omit the relative path.
    run photo_date_naming.sh
    # check status
    [[ "$status" == 0 ]]
    
    # check that originals are still there
    cd ../original
    echo "$(ls | wc -l)"
    [[ "$(ls | wc -l)" == "2" ]]
    
    # check that the new files are there
    cd ../new
    echo "$(ls | wc -l)"
    [[ "$(ls | wc -l)" == "2" ]]
    
    # run the script again
    run photo_date_naming.sh
    # check status
    [[ "$status" == 0 ]]
    
    # check that originals are still there
    cd ../original
    [[ "$(ls | wc -l)" == "2" ]]
    
    # check that the new files are there
    cd ../new
    [[ "$(ls | wc -l)" == "4" ]]
    
    # check that they are named correctly
    fileNameRegex="^[0-9]{8}_(0|1|2|3)\.(jpg|png)$"
    for filename in *; do 
    	[[ $filename =~ $fileNameRegex ]]
    done
    
}

@test "positive file copying with delete" {
    # source user input functions to be able to mock them
	source user_input.sh
    function get_destination() { echo "../new"; }
	export -f get_destination
    function get_prefix() { echo ""; }
	export -f get_prefix
    function get_startdate() { echo $(date +"%Y%m%d"); }
	export -f get_startdate
    function get_enddate() { echo $(date +"%Y%m%d"); }
	export -f get_enddate
    function get_destination_extension() { echo "PNG"; }
	export -f get_destination_extension
    function get_delete_originals() { echo "Y"; }
	export -f get_delete_originals
	
    # As we added src/ to $PATH, we can omit the relative path.
    run photo_date_naming.sh
    # check status
    [[ "$status" == 0 ]]
    
    # check that originals are still there
    cd ../original
    [[ "$(ls | wc -l)" == "0" ]]
    
    # check that the new files are there
    cd ../new
    [[ "$(ls | wc -l)" == "2" ]]
    
    # check that they are named correctly
    fileNameRegex="^[0-9]{8}_(0|1)\.(jpeg|png)$"
    for filename in *; do 
    	[[ $filename =~ $fileNameRegex ]]
    done
}

@test "positive with prefix" {
    # source user input functions to be able to mock them
	source user_input.sh
    function get_destination() { echo "../new"; }
	export -f get_destination
    function get_prefix() { echo "test_"; }
	export -f get_prefix
    function get_startdate() { echo $(date +"%Y%m%d"); }
	export -f get_startdate
    function get_enddate() { echo $(date +"%Y%m%d"); }
	export -f get_enddate
    function get_destination_extension() { echo "PNG"; }
	export -f get_destination_extension
    function get_delete_originals() { echo ""; }
	export -f get_delete_originals
	
    # As we added src/ to $PATH, we can omit the relative path.
    run photo_date_naming.sh
    # check status
    [[ "$status" == 0 ]]
    
    # check that the new files are there
    cd ../new
    [[ "$(ls | wc -l)" == "2" ]]
    
    # check that they are named correctly
    fileNameRegex="^test_[0-9]{8}_(0|1)\.(jpeg|png)$"
    for filename in *; do 
    	[[ $filename =~ $fileNameRegex ]]
    done
}

@test "nonexistent time period" {
    # source user input functions to be able to mock them
	source user_input.sh
    function get_destination() { echo "../new"; }
	export -f get_destination
    function get_prefix() { echo ""; }
	export -f get_prefix
    function get_startdate() { echo "20220101"; }
	export -f get_startdate
    function get_enddate() { echo "20220303"; }
	export -f get_enddate
    function get_destination_extension() { echo "jpg"; }
	export -f get_destination_extension
    function get_delete_originals() { echo ""; }
	export -f get_delete_originals
	
    # As we added src/ to $PATH, we can omit the relative path.
    run photo_date_naming.sh
    # check status
    [[ "$status" == 0 ]]
    
    # check that the new files are there
    cd ../new
    [[ "$(ls | wc -l)" == "0" ]]
}
