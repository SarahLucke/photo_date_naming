
setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "can run our script" {
    function get_destination() { echo "../new"; }
	export -f get_destination
    function get_prefix() { echo ""; }
	export -f get_prefix
    function get_startdate() { echo "20220101"; }
	export -f get_startdate
    function get_enddate() { echo "20221212"; }
	export -f get_enddate
    function get_destination_extension() { echo "jpg"; }
	export -f get_destination_extension
    function get_delete_originals() { echo "N"; }
	export -f get_delete_originals
	
    # As we added src/ to $PATH, we can omit the relative path.
    run photo_date_naming.sh -f test.file
    #echo $output
    echo ${lines[@]}
    assert_output --partial 'Please enter a destination folder: '
    #assert_output --partial 'Please enter a prefix if you wish to use one: '
    #[[ "${lines[0]}" == 'Please enter a destination folder: ' ]]
    #[[ "${lines[1]}" == 'Please enter a prefix if you wish to use one: ' ]]
    [[ "$status" == 0 ]]
    
    unset get_destination
    unset get_prefix
    unset get_startdate
    unset get_enddate
    unset get_destination_extension
    unset get_delete_originals
}
