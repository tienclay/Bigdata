import requests
import pandas as pd
from datetime import datetime
import os

def fetch_top_coins():
    url = "https://api.coingecko.com/api/v3/coins/markets"
    params = {
        "vs_currency": "usd",
        "order": "market_cap_desc",
        "per_page": 50,
        "page": 1,
        "sparkline": False,
        "price_change_percentage": "1h,24h,7d"
    }

    response = requests.get(url, params=params)
    data = response.json()

    df = pd.DataFrame(data)

    # Lưu dữ liệu kèm timestamp
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    filename = f"crypto_data_{timestamp}.csv"
    folder = "../data_crawl"
    os.makedirs(folder, exist_ok=True)

    df.to_csv(f"{folder}/{filename}", index=False)
    print(f"[✔] Saved {filename} ✅")

if __name__ == "__main__":
    fetch_top_coins()
