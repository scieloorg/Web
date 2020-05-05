from unittest import TestCase


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
        doi = "10.1590/1809-4392201902421"
        doi_items = [
            ("pt", "10.1590/1809-4392201902421.1"),
            ("en", "10.1590/1809-4392201902421.2"),
            ("es", "10.1590/1809-4392201902421.3"),
        ]
        result = cisis.proc_update_doi(file_path, doi, doi_items)
        expected = ("if 'hf':v706 and v702='xml/abc/v1n1/a.xml' then "
                    "'d337d237a237~10.1590/1809-4392201902421.1~',"
                    "'a337~^lpt^d10.1590/1809-4392201902421.1~',"
                    "'a337~^len^d10.1590/1809-4392201902421.2~',"
                    "'a337~^les^d10.1590/1809-4392201902421.3~' fi")
        self.assertEqual(result, expected)

    def test_proc_update_datetime(self):
        file_path = "xml/abc/v1n1/a.xml"
        result = cisis.proc_update_datetime(file_path, '20100501', '1903')
        expected = ("if v706='o' and v702='xml/abc/v1n1/a.xml' then"
                    " 'd91d92a91~20100501~a92~1903~' fi")
        self.assertEqual(result, expected)

    def test_get_commands_to_update_ohf_records_of_a_doc(self):
        db = "base"
        file_path = "xml/a.xml"
        h_mfn = "4"
        doi = "10.1590/1809-4392201902421.1"
        doi_items = [
            ("pt", "10.1590/1809-4392201902421.1"),
            ("en", "10.1590/1809-4392201902421.2"),
            ("es", "10.1590/1809-4392201902421.3"),
        ]
        upd_date = '20100501'
        upd_time = '1903'
        result = cisis.get_commands_to_update_ohf_records_of_a_doc(
            db, file_path, h_mfn, doi, doi_items, upd_date, upd_time)

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
                "if 'hf':v706 and v702='xml/a.xml' then "
                "'d337d237a237~10.1590/1809-4392201902421.1~',"
                "'a337~^lpt^d10.1590/1809-4392201902421.1~',"
                "'a337~^len^d10.1590/1809-4392201902421.2~',"
                "'a337~^les^d10.1590/1809-4392201902421.3~' fi\" "
                "copy=base now -all"
            )
        )
