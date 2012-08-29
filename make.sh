#!/bin/bash
## ########################################################################## ##
## Project: Ocsigen Quick Howto                                               ##
## Description: Script to generate Makefile and configuration file then       ##
##              compile and launch to test the Quick Howto examples           ##
## Author: db0 (db0company@gmail.com, http://db0.fr/)                         ##
## Latest Version is on GitHub: http://goo.gl/sfvvq                           ##
## ########################################################################## ##

generated_files="src"

function	usage() {
    echo "usage: $0 example_directory" >&2
    exit 1
}

function	install_file() {
    filename="$1/.install.sh"
    if [ -e $filename ]
    then
	chmod +x $filename
	$filename
	return $?
    fi
    return 0
}

function	init() {
    generated_files=$1
    project_name=$2
    mkdir -p $generated_files && \
	mkdir -p tmp && \
	cp .make/Makefile $generated_files/ && \
	cp .make/example.conf $generated_files/ && \
	cp $project_name/*.eliom $generated_files/ && \
	return 0
    return 1
}

function	generate_makefile() {
    generated_files=$1
    file=$2
    files=`\ls -1 $generated_files/ \
	| \grep '.eliom$' \
	| xargs \
	| sed 's# #\$SPACE\$#' \
	| sed 's#\/#\\\/#g'`
    echo "Generating Makefile... " && \
	sed -i".bak" 's#\$FILES\$#'$files'#' $file && \
	sed -i".bak" 's/\$SPACE\$/ /g' $file && \
	echo "Done." && \
	return 0
    return 1
}

function	generate_conf_file() {
    generated_files=$1
    file=$2
    default_port=8080
    pwd=`pwd | sed 's#\/#\\\/#g'`
    files=`\ls -1 $generated_files/ \
	| \grep '.eliom$' \
	| sed 's#\.eliom$#\.cmo#' \
	| sed 's#^#<eliom\$SPACE\$module=\\\"_server\\\/#' \
	| sed 's#$#\\\"\$SPACE\$\\\/>#' \
	| sed 's#\/#\\\/#g' \
	| xargs \
	| sed 's#\ ##'`
    echo "Generating Configuration file... "
    echo -n "Port number ("$default_port")? " && \
	read port && \
	if [ -z $port ]
         then sed -i".tmp" 's/\$PORT\$/'$default_port'/' $file
         else sed -i".tmp" 's/\$PORT\$/'$port'/' $file
        fi && \
	sed -i".bak" 's/\$PWD\$/'$pwd'/' $file && \
	sed -i".bak" 's/\$FILES\$/'$files'/' $file && \
	sed -i".bak" 's/\$SPACE\$/ /g' $file && \
	echo "Done." && \
	return 0
    return 1
}

function	compile() {
    generated_files=$1
    echo "Compile..." && \
	cd $generated_files && \
	make && \
	echo "Done." && \
	return 0
    return 1
}

function	launch() {
    echo -n "Launch server with generated files (Y/n)? "
    read answer
    if [ -z "$answer" ]||[ $answer == "y" ]||[ $answer == 'Y' ]
    then
	type ocsigenserver > /dev/null
	if [ $? -ne 0 ]
	then
	    echo >&2 "OcsigenServer is not installed!"
	else
	    trap "echo 'Server killed.'" SIGINT SIGTERM
	    echo "Launch server..." && \
		sh -c "sh -c 'ocsigenserver -c example.conf'" && \
		echo "Done."
	fi
    fi
}

function	clean() {
    generated_files=$1
    rm -f *.bak
    make clean > /dev/null
    cd - > /dev/null
    rm -rf tmp
    echo -n "Remove generated files (Y/n)? "
    read answer
    if [ -z "$answer" ]||[ $answer == "y" ]||[ $answer == 'Y' ]
    then
	rm -rf $generated_files
	rm -rf static
	echo "Done"
    else
	echo "Generated files are in \"$generated_files\" folder and in \"static\" folder."
	ls $generated_files static
    fi
}

if [ $# -ne 1 ]||[ ! -d $1 ]
then usage
fi

init $generated_files $1 && \
    install_file $project_name && \
    generate_makefile $generated_files "$generated_files/Makefile" && \
    generate_conf_file $generated_files "$generated_files/example.conf" && \
    compile $generated_files && \
    launch
clean $generated_files


