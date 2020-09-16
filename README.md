# Installation

[![Build Status](https://drone.grimbox.be/api/badges/fred/gwift-book/status.svg)](https://drone.grimbox.be/fred/gwift-book)

Ce livre peut être compilé avec [AsciiDoctor](...).


## Dépendances

```bash
$ apt install plantuml ruby-asciidoctor-plantuml
$ gem install asciidoctor-pdf --pre
$ gem install rouge
$ gem install asciidoctor-diagram
```

## Conversion en PDF

```bash
asciidoctor -a rouge-style=monokai -a pdf-themesdir=resources/themes -a pdf-theme=gwift main.adoc -t -r asciidoctor-diagram

asciidoctor-pdf -a pdf-themesdir=resources/themes -a pdf-theme=gwift main.adoc -t -r asciidoctor-diagram
```

## Configuration de l'espace utilisateur 

```bash
source /usr/share/powerline/bindings/bash/powerline.sh
```
