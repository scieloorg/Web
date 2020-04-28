from unittest import TestCase
from unittest.mock import patch
from datetime import datetime

from app import cisis


class TestCisis(TestCase):

    def test_update_command(self):
        db = "base"
        mfn = 100
        count = 5
        proc = '@a.proc'
        result = cisis.update_command(db, mfn, count, proc)
        self.assertEqual(
            result,
            "cisis/mx base from=100 count=5 \"proc=@a.proc\" copy=base now -all"
        )

    def test_proc_update_doi(self):
        file_path = "xml/abc/v1n1/a.xml"
        doi = "DOI"
        doi_items = [
            ("pt", "doi_PT"),
            ("en", "doi-en"),
            ("es", "doi_es"),
        ]
        result = cisis.proc_update_doi(file_path, doi, doi_items)
        expected = ("if 'hf':v706 and v702='xml/abc/v1n1/a.xml' then"
                    " 'd337d237a237~DOI~','a337~^lpt^ddoi_PT~',"
                    "'a337~^len^ddoi-en~','a337~^les^ddoi_es~' fi")
        self.assertEqual(result, expected)

    @patch("app.cisis.datetime")
    def test_proc_update_datetime(self, mock_dt):
        file_path = "xml/abc/v1n1/a.xml"
        mock_dt.now.return_value = datetime(2010, 5, 1, 19, 3, 17)
        result = cisis.proc_update_datetime(file_path)
        expected = ("if v706='o' and v702='xml/abc/v1n1/a.xml' then"
                    " 'd91d92a91~20100501~a92~1903~' fi")
        self.assertEqual(result, expected)

    @patch("app.cisis.datetime")
    def test_get_commands_to_update_ohf_records_of_a_doc(self, mock_dt):
        mock_dt.now.return_value = datetime(2010, 5, 1, 19, 3, 17)
        db = "base"
        file_path = "xml/a.xml"
        h_mfn = "4"
        doi = "DOI"
        doi_items = [
            ("pt", "doi_PT"),
            ("en", "doi-en"),
            ("es", "doi_es"),
        ]
        result = cisis.get_commands_to_update_ohf_records_of_a_doc(
            db, file_path, h_mfn, doi, doi_items)

        self.assertEqual(
            result[0],
            (
                "cisis/mx base from=3 count=1 \"proc="
                "if v706='o' and v702='xml/a.xml' then"
                " 'd91d92a91~20100501~a92~1903~' fi\" "
                "copy=base now -all"
            )
        )
        self.assertEqual(
            result[1],
            (
                "cisis/mx base from=4 count=2 \"proc="
                "if 'hf':v706 and v702='xml/a.xml' then"
                " 'd337d237a237~DOI~','a337~^lpt^ddoi_PT~',"
                "'a337~^len^ddoi-en~','a337~^les^ddoi_es~' fi\" "
                "copy=base now -all"
            )
        )
