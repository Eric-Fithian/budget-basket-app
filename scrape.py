import requests
from bs4 import BeautifulSoup
import pandas as pd

def search_costco(search_term):
    print(f"Searching for '{search_term}' on Costco...")
    url = f"https://www.costco.com//CatalogSearch?keyword={search_term}"
    response = requests.get(url)
    print(f"Status code: {response.status_code}")
    soup = BeautifulSoup(response.text, 'html.parser')
    
    # Example: Find elements containing item names and prices
    prices = soup.find_all('div', class_='price')
    
    # print prices that aren't null or empty
    results = []
    for price in prices:
        if price.text:
            results.append(price.text)
    return results

# Example usage
search_term = 'tomatoes'
results = search_costco(search_term)
print(results)
