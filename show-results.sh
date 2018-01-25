#!/bin/bash

disas_columns=100

disassemble_func_in_file () {
    func="$1"
    file="$2"
    COLUMNS=$disas_columns objdump -rd "$file" | sed -n "/<$func>:$/,/^\$/ p"
}

isolate_between_first_ud2_pair () {
    sed "/.*ud2[[:blank:]]*$/,/.*ud2[[:blank:]]*$/! d" | head -n-1 | tail -n+2 | sed -n '/.*ud2[[:blank:]]*$/ q; /.*/ p'
}

alltools=${TOOLS:-$(find -maxdepth 1 -type d -name '[a-z]*' ! -name 'programs')}
echo "alltools is $alltools" 1>&2

find_output_binaries () {
    while true; do
        d="$1"
        find $d -perm +001 -type f -regex '\'"$d/[^\.]*\$"
        shift || break
    done
}

print_f_symbol_size () {
    fname="$1"
    readelf -W --dyn-syms "$fname" | grep '[[:blank:]]f$' | sed 's/\t/        /g' | \
        while read symndx addr sz tp bnd vis shndx name; do
            printf "${fname}\\tsymbol $name size $sz\\n"
        done
}

print_disas_between_first_ud2_pair () {
    fname="$1"
    echo -e "\fIsolated instructions in $fname":
    echo "------------------------"
    # We also want the ud2->ud2 distance
    disas="$( COLUMNS=$disas_columns disassemble_func_in_file f "$fname" )"
    echo "$disas" | isolate_between_first_ud2_pair | sed 's/\t/        /g'
    echo "------------------------"
}

#find_output_binaries $alltools | \
#while read fname; do
#    print_f_symbol_size "$fname"
#done | column -s$'\t' -t
#
#find_output_binaries $alltools | \
#while read fname; do
#    print_disas_between_first_ud2_pair "$fname"
#done

# To get vertically aligned outputs for each, in two cases,
# I did
# pr -w172 -m \
#  <( TOOLS=crunchb ./show-results.sh ) \
#  <( TOOLS=asan ./show-results.sh ) | sed '/^[[:blank:]]*$/ d' 
# ... remembering that "pr -m" prints all files in parallel, page-by-page.
# So we want one "file" per directory.
# So how do I show it for all tools?
# find_output_binaries gives us binary-by-binary

all_output_for_t () {
    t="$1"
    find_output_binaries "$t" | \
    while read fname; do
        print_f_symbol_size "$fname"
    done | column -s$'\t' -t
    find_output_binaries "$t" | \
    while read fname; do
        print_disas_between_first_ud2_pair "$fname"
    done
}

cmdargs=""
ctr=0
for t in $alltools; do
    ctr=$(( $ctr + 1 ))
    cmdargs="${cmdargs:+${cmdargs} }<( all_output_for_t $t )"
done
#echo "cmdargs is $cmdargs"

eval "pr --output-tabs=' '1 -w$(( $disas_columns * $ctr )) -m $cmdargs" | sed '/^[[:blank:]]*$/ d'  | sed 's/\t/        /g'
