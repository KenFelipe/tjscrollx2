#!bin/bash

readonly input_src_filename="x${1}"

# filename argument is empty:
if [ $input_src_filename = 'x' ]; then
    echo 'error: Empty filename'
    exit 0
fi

# filenames
readonly src_file="${input_src_filename#x}"
readonly output_file="scroll2_${src_file}"

# file does not exist:
if [ ! -f $src_file ]; then
    echo "error: No such file ${src_file}"
    exit 0
fi

is_firstline=true

cat $src_file | while read line || [ -n "${line}" ]
do
    output_line=$line

    # if contain #SCROLL X.XXX
    if [[ ${line} =~ ^(\#SCROLL\ )([0-9]+(\.[0-9]+)?)$ ]]; then
        scroll="${BASH_REMATCH[1]}"
        speed2=`echo "${BASH_REMATCH[2]}*2.0" | bc`

        output_line="${scroll}${speed2}"
    fi

    if "${is_firstline}"; then
        echo $output_line > $output_file

        is_firstline=false
        continue
    fi

    echo $output_line >> $output_file
done

# echo `pwd`
# echo 'success!'
exit 0
