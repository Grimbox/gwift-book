The CRUD views themselves are simple enough to be self-explanatory, as shown in
the following code:

```python
# views.py
from django.core.urlresolvers import reverse_lazy
from . import forms

class ImpDateDetail(generic.DetailView):
    model = models.ImportantDate

    class ImpDateCreate(generic.CreateView):
        model = models.ImportantDate
        form_class = forms.ImportantDateForm

    class ImpDateUpdate(generic.UpdateView):
        model = models.ImportantDate
        form_class = forms.ImportantDateForm

    class ImpDateDelete(generic.DeleteView):
        model = models.ImportantDate
        success_url = reverse_lazy("impdate_list")
```
