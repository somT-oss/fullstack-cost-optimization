import requests as r
from faker import Faker
import logging
import random


class TestServerEndpoints:
    
    def __init__(self, dns: str) -> None:
        self.dns = dns
    
    def _get_one_book_id_id(self) -> int:
        logging.info("getting book random id")
        all_data = r.get(
            url=self.dns,
            headers={"Connection": "close"},
            timeout=10,
        )
        logging.info(all_data)
        random_id = random.choice(all_data.json())['id'] 
        logging.info(f"book with id {random_id} selected")
        return random_id


    def test_post_endpoint(self, author: str, title: str, published_date: str) -> None:
        logging.info("test_post_endpoint called")
        r.post(
            url = self.dns,
            json = {
                "title": title,
                "author": author,
                "publishedDate": published_date
            },
            headers={"Connection": "close"},
            timeout=10,
        )
        logging.info("Request sent\n")
    
    def test_put_endpoint_for_author(self, author: str) -> None:
        logging.info("test_put_endpoint_for_author called")
        random_object_id = self._get_one_book_id_id() 
        r.put(
            url=self.dns + f"/{random_object_id}",
            json = {
                "author": author,
            },
            headers={"Connection": "close"},
            timeout=10,
        )
        logging.info("Request sent\n")

    def test_put_endpoint_for_title(self, title: str) -> None:
        logging.info("test_put_endpoint_for_title called")
        random_object_id = self._get_one_book_id_id() 
        r.put(
            url=self.dns + f"/{random_object_id}",
            json = {
                "title": title,
            },
            headers={"Connection": "close"},
            timeout=10,
        )
        logging.info("Request sent\n")


    def test_put_endpoint_for_published_date(self, published_date: str) -> None:
        logging.info("test_put_endpoint_for_published_date called")
        random_object_id = self._get_one_book_id_id() 
        r.put(
            url=self.dns + f"/{random_object_id}",
            json = {
                "published_date": published_date
            },
            headers={"Connection": "close"},
            timeout=10,
        )
        logging.info("Request sent\n")
    

if __name__ == "__main__":
    dns = ""
    logging.basicConfig(
        level=logging.INFO,  # show INFO and above
        format="%(asctime)s - %(levelname)s - %(message)s"
    )
    
    logging.info("Starting the test client and initializing Faker object.")
    ts = TestServerEndpoints(dns)
    fake = Faker()
    logging.info("Test client and Faker have been initialized \n")

    for i in range(1, 101):
        logging.info("Generating fake title, author and published_date...")
        title = f"{fake.name_male()} {fake.name_female()}"
        author = random.choice([fake.name_male(), fake.name_female()])
        published_date = fake.date()
        logging.info("Done generating fake info for this request. \n")


        if i < 5: # To be sure we have data we can perform UPDATE actions on
            ts.test_post_endpoint(
                title=title,
                author=author,
                published_date=published_date
            )

        elif i % 3 == 0 and i % 5 == 0:
            ts.test_post_endpoint(
                title=title,
                author=author,
                published_date=published_date
            )
        elif i % 3 == 0:
            ts.test_put_endpoint_for_author(
                author
            )
        elif i % 5 == 0:
            ts.test_put_endpoint_for_published_date(
                published_date
            ) 
        else:
            ts.test_put_endpoint_for_title(
                title
            )
        
