from selenium import webdriver
from selenium.webdriver.chrome.options import Options

# instance of Options class to configure Headless Chrome
options = Options()

# run without UI (Headless)
options.headless = True

# initializing webdriver for Chrome with options
driver = webdriver.Chrome(options=options)

# getting home page 
driver.get('https://containerBuild:80')

# output webpage title
print(driver.title)

# close browser
driver.close()
