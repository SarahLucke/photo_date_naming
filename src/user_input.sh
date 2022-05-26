#!/bin/bash

function get_destination(){
	read destination_folder
	echo $destination_folder
}

function get_prefix(){
	read prefix
	echo $prefix
}

function get_startdate(){
	read startdate
	echo $startdate
}

function get_enddate(){
	read enddate
	echo $enddate
}

function get_destination_extension(){
	read destination_extension
	echo $destination_extension
}

function get_delete_originals(){
	read delete_originals
	echo delete_originals
}
