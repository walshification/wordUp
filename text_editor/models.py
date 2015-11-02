from django.db import models


class TextWork(models.Model):

    def __repr__(self):
        return str(self)

    def __str__(self):
        return 'Work #{}'.format(self.id)
