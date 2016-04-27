OUT=pages.sh pages.echo

all: pages.sh

pages.sh: pages.in.sh
	groff -ms -t -Tascii pages.ms | col -bx | cat -s > pages.echo; \
	sed -e '/@USAGE@/r pages.echo' -e '/@USAGE@/d' ${?} > ${@}; \
	chmod u+x ${@}

clean:
	rm -fv ${OUT}

