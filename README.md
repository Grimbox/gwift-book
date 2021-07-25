# Installation

[![Build Status](https://drone.grimbox.be/api/badges/fred/gwift-book/status.svg)](https://drone.grimbox.be/fred/gwift-book)

Ce livre peut être compilé avec [AsciiDoctor](https://asciidoctor.org/).


## Dépendances

```bash
$ gem install asciidoctor-pdf --pre
$ gem install rouge
$ gem install asciidoctor-diagram
```

## Conversion en PDF

```bash
asciidoctor -a rouge-style=monokai -a pdf-themesdir=resources/themes -a pdf-theme=gwift main.adoc -t -r asciidoctor-diagram

asciidoctor-pdf -a pdf-themesdir=resources/themes -a pdf-theme=gwift main.adoc -t -r asciidoctor-diagram
```

## Erreurs connues

Si `asciidoctor` n'est pas dans le PATH malgré son installation, on peut le trouver grâce à la commande `gem env`, puis à réutiliser (ou à modifier le fichier `.bash_profile` ou `.profile`).
