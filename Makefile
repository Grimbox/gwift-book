
.PHONY: help pdf pdflatex

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  pdf        to make standalone PDF files"

clean:
	rm -rf $(BUILDDIR)/*

html:
	$(SPHINXBUILD) -b html $(ALLSPHINXOPTS) $(BUILDDIR)/html
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/html."

pdf:
	asciidoctor-pdf -a pdf-themesdir=resources/themes -a pdf-theme=book.yml source/main.adoc -t

pdflatex:
	docker run --rm -ti   -v miktex:/miktex/.miktex   -v $(shell pwd)/source/tex:/miktex/work   -e MIKTEX_GID=$(id -g)   -e MIKTEX_UID=$(id -u)   miktex/miktex   pdflatex main.tex
