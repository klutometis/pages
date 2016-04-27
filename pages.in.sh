#!/usr/bin/env bash
declare -r THIS="${0}"
declare -ri START=1
declare -ri PAGES=100
declare -r TMP=$(mktemp -d)
declare -i pages
declare -i start
declare getopt
declare outfile

function usage()
{
    cat 1>&2 <<-'EOF'
@USAGE@
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
