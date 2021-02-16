#!bin/bash
# readonly extension='.txt'

readonly input_src_filename="x${1}"

# filename argument is empty:
if [ $input_src_filename = 'x' ]; then
    echo 'error: Empty filename'
    exit 0
fi

# filenames
readonly src_file="${input_src_filename#x}"
# readonly output_file="scroll2_${src_file}"

readonly ext="${src_file#*.}"
readonly filename_without_ext="${src_file%.${ext}}"
readonly output_file="${filename_without_ext}_scrollx2.${ext}"

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
    # if [[ ${line} =~ ^(\#SCROLL\ )([0-9]+(\.[0-9]+)?)$ ]]; then
    if [[ ${line} =~ ^(\#SCROLL\ )([0-9]+(\.[0-9]+)?) ]]; then
        # if not installed bc
        # in terminal msys2 do:
        # $ packman -S bc
        speed2=`echo "${BASH_REMATCH[2]}*2.0" | bc`

        output_line="${BASH_REMATCH[1]}${speed2}"
        # echo $line
        # echo $output_line
    fi

    if "${is_firstline}"; then
        echo $output_line > $output_file

        is_firstline=false
        continue
    fi

    echo $output_line >> $output_file
done

# remove source file
# rm $src_file

# echo 'success!'
exit 0
