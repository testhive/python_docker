import requests
from behave import *
from selenium import webdriver
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.support.ui import WebDriverWait


@step('I test things')
def step_impl(context):
    chrome_options = webdriver.ChromeOptions()
    chrome_options.add_argument("--no-sandbox")
    chrome_options.add_argument("--headless")
    chrome_options.add_argument("--disable-gpu")
    chrome_options.add_argument("--disable-dev-shm-usage")

    driver = webdriver.Chrome(ChromeDriverManager().install(), chrome_options=chrome_options)
    driver.maximize_window()
    global_wait_time = 5

    driver.get("http://en.wikipedia.org/wiki/Main_Page")
    el = WebDriverWait(driver,global_wait_time).until(lambda d: d.find_element_by_id("searchInput"))
    el.send_keys("Albert Einstein")
    WebDriverWait(driver,global_wait_time).until(lambda d: d.find_element_by_id("searchButton")).click()
    WebDriverWait(driver,global_wait_time).until(lambda d: d.find_element_by_link_text("theory of relativity"))

    driver.close()
    driver.quit()


@given("I call petstore")
def step_impl(context):
    requests.get("https://petstore.swagger.io/v2/pet/1")