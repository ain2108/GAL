files="tests/*fail_*"

GAL="./src/gal"

globallog=testall.log

Usage() {
    echo "Usage: testall.sh [options] [.gal files]"
    echo "-h    Print this help"
    exit 1
}

SignalError() {
    if [ $error -eq 0 ] ; then
    echo "FAILED"
    error=1
    fi
    echo "  $1"
}

Run() {
    echo $* 1>&2
    eval $* || {
    SignalError "$1 failed on $*"
    return 1
    }
}

Compare() {
    generatedfiles="$generatedfiles $3"
    #echo diff -b $1 $2 ">" $3 1>&2
    diff -b "$1" "$2" > "$3" 2>&1 || {
    SignalError "$1 differs"
    cat "$3"
    echo "FAILED $1 differs from $2" 1>&2
    }
}

while getopts kdpsh c; do
    case $c in
    h) # Help
        Usage
        ;;
    esac
done

rm -f $globallog
error=0
globalerror=0

keep=0

RunFail() {
    echo $* 1>&2
    eval $* && {
    SignalError "failed: $* did not report an error"
    return 1
    }
    return 0
}

Check() {
    error=0
    basename=`echo $1 | sed 's/.*\\///
                             s/.mc//'`
    reffile=`echo $1 | sed 's/.mc$//'`
    basedir="`echo $1 | sed 's/\/[^\/]*$//'`/."

    echo -n "$basename..."

    echo 1>&2
    echo "###### Testing $basename" 1>&2

    generatedfiles=""

    generatedfiles="$generatedfiles ${basename}.ll ${basename}.out" &&
    Run "$MICROC" "<" $1 ">" "${basename}.ll" &&
    Run "$LLI" "${basename}.ll" ">" "${basename}.out" &&
    Compare ${basename}.out ${reffile}.out ${basename}.diff

    # Report the status and clean up the generated files

    if [ $error -eq 0 ] ; then
    if [ $keep -eq 0 ] ; then
        rm -f $generatedfiles
    fi
    echo "OK"
    echo "###### SUCCESS" 1>&2
    else
    echo "###### FAILED" 1>&2
    globalerror=$error
    fi
}

CheckFail()
{
    error=0
    basename_first=`echo $1 | sed 's/.*\\///'`
    y=${basename_first%.*}
    basename=`echo ${y##*/}`
    reffile=`echo $1 | sed 's/.gal$//'`
    basedir="`echo $1 | sed 's/\/[^\/]*$//'`/"

    echo -n "basename: $basename..."
    #echo -n "reffile: $reffile..."
    #echo -n "basedir: $basedir..."

    echo 1>&2
    echo "###### Testing $basename" 1>&2

    generatedfiles="$generatedfiles ${basename}.out ${basename}.diff" &&
    $GAL < $1 2> "${basename}.out" ">>" $globallog &&
    Compare "${basename}.out" "$basedir$basename.err" ${basename}.diff

    if [ $error -eq 0 ] ; then
    if [ $keep -eq 0 ] ; then
        rm -f $generatedfiles
    fi
    echo "OK"
    echo "###### SUCCESS" 1>&2
    else
    echo "###### FAILED" 1>&2
    globalerror=$error
    fi

}

if [ $# -ge 1 ]
then
    files=$@
else
    files="tests/test_*.gal tests/fail_*.gal"
fi

for file in $files
do
    case $file in
    *test_*)
        Check $file 2>> $globallog
        ;;
    *fail_*)
        CheckFail $file 2>> $globallog
        ;;
    *)
        echo "unknown file type $file"
        globalerror=1
        ;;
    esac
    
done

cat $globallog