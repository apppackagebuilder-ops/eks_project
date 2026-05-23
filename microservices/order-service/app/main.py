# Order Service orchestrates calls to the user, product, payment, and notification services.

import os

import requests
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel


app = FastAPI(title="order-service", version="1.0.0")

USER_SERVICE_URL = os.getenv("USER_SERVICE_URL", "http://user-service:8080")
PRODUCT_SERVICE_URL = os.getenv("PRODUCT_SERVICE_URL", "http://product-service:8080")
PAYMENT_SERVICE_URL = os.getenv("PAYMENT_SERVICE_URL", "http://payment-service:8080")
NOTIFICATION_SERVICE_URL = os.getenv("NOTIFICATION_SERVICE_URL", "http://notification-service:8080")
ORDERS = []


class OrderRequest(BaseModel):
    user_id: int
    product_id: int
    quantity: int = 1


@app.get("/healthz")
def healthz() -> dict:
    return {"status": "ok", "service": "order-service"}


@app.get("/readyz")
def readyz() -> dict:
    return {"status": "ready", "dependencies": 4}


@app.post("/api/v1/orders")
def create_order(order: OrderRequest) -> dict:
    user_response = requests.get(f"{USER_SERVICE_URL}/api/v1/users/{order.user_id}", timeout=5)
    product_response = requests.get(
        f"{PRODUCT_SERVICE_URL}/api/v1/products/{order.product_id}", timeout=5
    )

    if user_response.status_code >= 400 or product_response.status_code >= 400:
        raise HTTPException(status_code=502, detail="Dependent services failed")

    user = user_response.json()
    product = product_response.json()
    amount = float(product["price"]) * order.quantity

    payment_response = requests.post(
        f"{PAYMENT_SERVICE_URL}/api/v1/payments",
        json={"order_id": len(ORDERS) + 1, "amount": amount, "currency": "USD"},
        timeout=5,
    )
    payment_response.raise_for_status()

    notification_response = requests.post(
        f"{NOTIFICATION_SERVICE_URL}/api/v1/notifications",
        json={
            "order_id": len(ORDERS) + 1,
            "message": f"Order created for {user['name']} with total ${amount}",
        },
        timeout=5,
    )
    notification_response.raise_for_status()

    created_order = {
        "id": len(ORDERS) + 1,
        "user": user,
        "product": product,
        "quantity": order.quantity,
        "total": amount,
        "payment": payment_response.json(),
        "notification": notification_response.json(),
    }
    ORDERS.append(created_order)
    return created_order


@app.get("/api/v1/orders")
def list_orders() -> dict:
    return {"items": ORDERS}
