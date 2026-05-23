# Frontend UI provides a simple training dashboard that aggregates data from the backend services.

import os

import requests
from fastapi import FastAPI
from fastapi.responses import HTMLResponse


app = FastAPI(title="frontend-ui", version="1.0.0")
USER_SERVICE_URL = os.getenv("USER_SERVICE_URL", "http://user-service:8080")
PRODUCT_SERVICE_URL = os.getenv("PRODUCT_SERVICE_URL", "http://product-service:8080")
ORDER_SERVICE_URL = os.getenv("ORDER_SERVICE_URL", "http://order-service:8080")
PAYMENT_SERVICE_URL = os.getenv("PAYMENT_SERVICE_URL", "http://payment-service:8080")
NOTIFICATION_SERVICE_URL = os.getenv("NOTIFICATION_SERVICE_URL", "http://notification-service:8080")


def fetch_json(url: str) -> dict:
    response = requests.get(url, timeout=5)
    response.raise_for_status()
    return response.json()


@app.get("/healthz")
def healthz() -> dict:
    return {"status": "ok", "service": "frontend-ui"}


@app.get("/readyz")
def readyz() -> dict:
    return {"status": "ready", "dependencies": 5}


@app.get("/", response_class=HTMLResponse)
def index() -> str:
    users = fetch_json(f"{USER_SERVICE_URL}/api/v1/users").get("items", [])
    products = fetch_json(f"{PRODUCT_SERVICE_URL}/api/v1/products").get("items", [])
    orders = fetch_json(f"{ORDER_SERVICE_URL}/api/v1/orders").get("items", [])
    payments = fetch_json(f"{PAYMENT_SERVICE_URL}/api/v1/payments").get("items", [])
    notifications = fetch_json(f"{NOTIFICATION_SERVICE_URL}/api/v1/notifications").get("items", [])

    return f"""
    <!DOCTYPE html>
    <html lang=\"en\">
    <head>
      <meta charset=\"UTF-8\" />
      <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" />
      <title>ACME EKS Demo Platform</title>
      <style>
        body {{ font-family: Segoe UI, sans-serif; margin: 0; background: linear-gradient(135deg, #06283d, #1363df); color: #fff; }}
        header {{ padding: 32px; }}
        main {{ display: grid; gap: 16px; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); padding: 24px; }}
        section {{ background: rgba(255,255,255,0.12); border-radius: 16px; padding: 20px; backdrop-filter: blur(6px); }}
        h1, h2 {{ margin-top: 0; }}
        li {{ margin-bottom: 8px; }}
      </style>
    </head>
    <body>
      <header>
        <h1>ACME Enterprise EKS Platform</h1>
        <p>This frontend demonstrates service discovery and internal microservice communication inside Kubernetes.</p>
      </header>
      <main>
        <section><h2>Users</h2><pre>{users}</pre></section>
        <section><h2>Products</h2><pre>{products}</pre></section>
        <section><h2>Orders</h2><pre>{orders}</pre></section>
        <section><h2>Payments</h2><pre>{payments}</pre></section>
        <section><h2>Notifications</h2><pre>{notifications}</pre></section>
      </main>
    </body>
    </html>
    """
