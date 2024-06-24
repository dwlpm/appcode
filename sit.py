import sys
import unittest
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By

options = Options()
options.headless = True

# initializing webdriver for Chrome with options
driver = webdriver.Chrome(options=options)

class PythonTestHomepage(unittest.TestCase):

    def setUp(self):
        self.driver = webdriver.Chrome(options=options)

    def test_home_page(self):
        driver = self.driver

        url='http://' + website
        driver.get(url)
        print(url)

        print(driver.title)
        self.assertIn("appcode title", driver.title)  # match http://localhost/index.php page title

    def tearDown(self):
        self.driver.close()

if __name__ == "__main__":
    if len(sys.argv) > 1:
        website = sys.argv.pop()
        unittest.main()
    else:
        print('usage: sit.py www.lpm.hk')

