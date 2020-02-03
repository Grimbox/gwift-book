# Installation

Ce livre peut être compilé avec [Sphinx](...).

Les lexers Pygments disponibles se trouvent sur cette page: http://pygments.org/docs/lexers/. Les principaux utilisés seront: 

 * `shell`
 * `python`


## Dépendances

```bash
apt install texlive-latex-base latexmk texlive-latex-extra texlive-xetex
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
```
