class TestExample(fake_filesystem_unittest.TestCase):

    def setUp(self):
        self.setUpPyfakefs()

    def tearDown(self):
        # It is no longer necessary to add self.tearDownPyfakefs()
        pass

    def test_create_file(self):
        '''Test example.create_file()'''
        # The os module has been replaced with the fake os module so all of the
        # following occurs in the fake filesystem.
        self.assertFalse(os.path.isdir('/test'))
        os.mkdir('/test')
        self.assertTrue(os.path.isdir('/test'))

        self.assertFalse(os.path.exists('/test/honey.txt'))
        example.create_file('/test/file.txt')
        self.assertTrue(os.path.exists('/test/honey.txt'))