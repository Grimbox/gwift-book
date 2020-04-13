
.PHONY: help pdf

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
	asciidoctor-pdf -a pdf-themesdir=resources/themes -a pdf-theme=gwift-theme source/main.adoc -t -r asciidoctor-diagram
