Si on veut propager les logs entre applications, il faut bien spécifier l'attribut `propagate`, sans quoi on s'arrêtera au module sans prendre en considération les sous-modules.

```python
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'handlers': {
        'console': {
            'level': 'DEBUG',
            'class': 'logging.StreamHandler',
        },
        'file': {
            'level': 'DEBUG',
            'class': 'logging.FileHandler',
            'filename': os.path.join(SRC_DIR, 'log', 'log.txt'),
        },
    },
    'loggers': {
        'mv': {
            'handlers': ['file'],
            'level': 'DEBUG',
            'propagate': True,
        },
    },
}
```