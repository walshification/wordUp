from django.test import TestCase

from text_editor.models import TextWork


class TextEditorTests(TestCase):

    def test_repr_returns_work_number(self):
        work = TextWork.objects.create()
        self.assertEqual(work.__repr__(), 'Work #{}'.format(work.id))
