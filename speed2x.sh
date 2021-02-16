#!bin/bash
# readonly extension='.txt'

readonly input_src_filename="x${1}"

# filename argument is empty:
if [ $input_src_filename = 'x' ]; then
    echo 'error: Empty filename'
    sleep 5; exit 0
fi

# filenames
readonly src_file="${input_src_filename#x}"

# show in terminal
# echo '-------------------------'
echo "src: ${src_file}"

readonly ext="${src_file#*.}"
readonly src_file_without_ext="${src_file%.${ext}}"
readonly output_file="${src_file_without_ext}_scroll2x.${ext}"

# show in terminal
# echo '-------------------------'
# echo "out: ${output_file}"

# file does not exist:
if [ ! -f $src_file ]; then
    echo "error: No such file ${src_file}"
    sleep 5; exit 0
fi

# ----------------------------------------------------
i=1
is_firstline=true

cat $src_file | while read line || [ -n "${line}" ]
do
    output_line=$line

    if "${is_firstline}"; then
        echo $output_line > $output_file

        i=`expr $i + 1`
        is_firstline=false
        continue
    fi

    # if contain #SCROLL X.XXX
    # if [[ ${line} =~ ^(\#SCROLL\ )([0-9]+(\.[0-9]+)?)$ ]]; then
    if [[ ${line} =~ ^(\#SCROLL\ )([0-9]+(\.[0-9]+)?) ]]; then
        # if not installed bc
        # in terminal msys2 do:
        # $ packman -S bc
        speed2=`echo "${BASH_REMATCH[2]}*2.0" | bc`

        output_line="${BASH_REMATCH[1]}${speed2}"

        # show in terminal
        echo "Line ${i}: ${BASH_REMATCH[0]} -> ${output_line}"
    fi

    echo $output_line >> $output_file

    # insert #SCROLL 2.0 at the beginning(after the #START)
    if [[ ${line} =~ ^\#START ]]; then
        echo '#SCROLL 2.0' >> $output_file

        # show in terminal
        echo '------------------------------------------'
        echo "Line ${i}: insert #SCROLL 2.0 after ${BASH_REMATCH[0]}"
    fi

    i=`expr $i + 1`
done

# remove source file
echo '------------------------------------------'
echo "created \"${output_file##*\\}\""
echo '------------------------------------------'
rm $src_file
# show in terminal
echo '------------------------------------------'
# echo "removed ${src_file##*\\}"
# echo "created ${output_file##*\\}"
# echo "removed \"${src_file##*\\}\""

echo ''

echo 'Success!!!'
read -p ""

exit 0
