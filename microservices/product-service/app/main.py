# Product Service exposes catalog information to the rest of the platform.

from fastapi import FastAPI


app = FastAPI(title="product-service", version="1.0.0")


PRODUCTS = [
    {"id": 101, "name": "Laptop", "price": 1199.00},
    {"id": 102, "name": "Headphones", "price": 199.00},
    {"id": 103, "name": "Monitor", "price": 349.00},
]


@app.get("/healthz")
def healthz() -> dict:
    return {"status": "ok", "service": "product-service"}


@app.get("/readyz")
def readyz() -> dict:
    return {"status": "ready", "records": len(PRODUCTS)}


@app.get("/api/v1/products")
def list_products() -> dict:
    return {"items": PRODUCTS}


@app.get("/api/v1/products/{product_id}")
def get_product(product_id: int) -> dict:
    for product in PRODUCTS:
      if product["id"] == product_id:
          return product
    return {"id": product_id, "name": "unknown", "price": 0}
