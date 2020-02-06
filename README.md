# Installation

Ce livre peut être compilé avec [Sphinx](...).

Les lexers Pygments disponibles se trouvent sur cette page: http://pygments.org/docs/lexers/. Les principaux utilisés seront: 

 * `shell`
 * `python`


## Dépendances

```bash
apt install texlive-latex-base latexmk texlive-latex-extra texlive-xetex
apt install plantuml ruby-asciidoctor-plantuml
```

## Sortie en PDF

```bash
pandoc -s --toc gwift.rst -o output.pdf --pdf-engine=xelatex
```

## Environnement

```bash
cd ~/
python3 -m venv .venvs/gwift-book
source .venvs/gwift-book/bin/activate
pip install -r requirements/base.txt

$ gem install asciidoctor-pdf --pre
$ gem install rouge
$ gem install asciidoctor-diagram
```

## Conversion en PDF

```bash
asciidoctor -a rouge-style=monokai -a pdf-themesdir=resources/themes -a pdf-theme=gwift main.adoc -t -r asciidoctor-diagram

asciidoctor-pdf -a rouge-style=monokai -a pdf-themesdir=resources/themes -a pdf-theme=gwift main.adoc -t -r asciidoctor-diagram
```

## Configuration de l'espace utilisateur 

```bash
source /usr/share/powerline/bindings/bash/powerline.sh
```