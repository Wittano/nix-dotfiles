from selenium.webdriver import Firefox
from configparser import ConfigParser
from selenium.common.exceptions import NoSuchElementException
import time
import operator


def login(driver: Firefox):
    config = ConfigParser()
    config.read("/home/wittano/.config/facebook.ini")

    driver.find_element_by_id("email").send_keys(config.get("default", "email"))
    driver.find_element_by_id("pass").send_keys(config.get("default", "password"))
    driver.find_element_by_id("u_0_d").click()


def main():
    with Firefox() as driver:
        driver.get("https://www.facebook.com/")

        login(driver)

        try:

            notification = driver.find_element_by_xpath(
                "/html/body/div[1]/div/div[1]/div[1]/div[2]/div[4]/div[1]/div[1]/span/div/div[2]/div/span/span"
            )

            print(f"You have {notification.text()} notification")

            driver.find_element_by_xpath(
                "/html/body/div[1]/div/div[1]/div[1]/div[2]/div[4]/div[1]/div[1]/span/div/div[1]",
            ).click()

            driver.find_element_by_xpath(
                "/html/body/div[1]/div/div[1]/div[1]/div[2]/div[4]/div[2]/div/div/div[1]/div[1]/div/div/div/div/div/div/div[1]/div[3]/div/div/div/div[2]/div[1]/div/a"
            ).click()

            time.sleep(30)
        except NoSuchElementException:
            print("You haven't any notifitactons")

        try:
            notification = driver.find_element_by_xpath(
                "/html/body/div[1]/div/div[1]/div[1]/div[2]/div[4]/div[1]/div[2]/span/div/div[2]/span/span"
            )

            print(f"You have {notification.text()} message")

            driver.find_element_by_xpath(
                "/html/body/div[1]/div/div[1]/div[1]/div[2]/div[4]/div[1]/div[2]/span/div/div[1]",
            ).click()
            driver.find_element_by_xpath(
                "/html/body/div[1]/div/div[1]/div[1]/div[2]/div[4]/div[2]/div/div/div[1]/div[1]/div/div/div/div/div/div/div[1]/div/div[1]/div[1]/div[2]/div[2]/div[1]/div/a"
            ).click()

            time.sleep(30)
        except NoSuchElementException:
            print("You haven't any messages")


if __name__ == "__main__":
    main()
