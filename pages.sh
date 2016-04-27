#!/usr/bin/env bash
declare -r THIS="${0}"
declare -ri START=1
declare -ri PAGES=100
declare -r TMP=$(mktemp -d) || \
    fail "Nicht workin' of tempdir, dude."
declare -i pages
declare -i start
declare getopt
declare outfile

function usage()
{
    cat 1>&2 <<-'EOF'

Usage: pages [-p PAGES] [-o NAME] START
Output numbered pages starting from START.

     -p PAGES, --pages=PAGES   print PAGES pages     [100]
     -o NAME                   output to file NAME

     `pages' outputs blank pages numbered from START in two-
sided book form; id est: alternating right and left, respec-
tively recto and verso.

EOF
    fail
}

function fail()
{
    [ -n "${1}" ] || echo "${1}" 1>&2
    exit 1
}

[ ${#} -ne 0 ] || usage

getopt=$(getopt -o p:o: -l help,pages: -n "${THIS}" -- "${@}") || \
    fail "Try \`${THIS} --help' for more information."
eval set -- "${getopt}"

while :
do
    case "${1}" in
        --help) usage;;
        -p|--pages) pages="${2}"; shift 2;;
        -o) outfile="${2}"; shift 2;;
        --) shift; break;;
        *) fail "parse failure";;
    esac
done

start=${1}
: ${pages:=$PAGES}
: ${start:=$START}

sed -e "s/@PAGES@/$pages/" -e "s/@START@/$start/" pages.in.tex > \
    "${TMP}/pages.tex" && \
    latexmk -lualatex -g "${TMP}/pages.tex"
