*******
Annexes
*******

Django-Admin-honeypot
=====================

`django-admin-honeypot <https://django-admin-honeypot.readthedocs.io/en/latest/>`_ is a fake Django admin login screen to log and notify admins of attempted unauthorized access. This app was inspired by discussion in and around Paul McMillan’s security talk at DjangoCon 2011. Cette librairie est surtout utile si elle est couplée avec les *loggers*: 

.. code-block:: python

    # Taken directly from core Django code.
    # Used here to illustrate an example only, so don't
    # copy this into your project.
    logger.warning("Forbidden (%s): %s",
                    REASON_NO_CSRF_COOKIE, request.path,
        extra={
            "status_code": 403,
            "request": request,
        }
    )
