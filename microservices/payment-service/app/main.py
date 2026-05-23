# Payment Service simulates transaction storage using a SQLite database on a mounted volume.

import os
import sqlite3
from contextlib import closing

from fastapi import FastAPI
from pydantic import BaseModel


DB_PATH = os.getenv("PAYMENT_DB_PATH", "/data/payments.db")
app = FastAPI(title="payment-service", version="1.0.0")


class PaymentRequest(BaseModel):
    order_id: int
    amount: float
    currency: str = "USD"


def initialize_database() -> None:
    os.makedirs(os.path.dirname(DB_PATH), exist_ok=True)
    with closing(sqlite3.connect(DB_PATH)) as connection:
        connection.execute(
            """
            CREATE TABLE IF NOT EXISTS payments (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                order_id INTEGER NOT NULL,
                amount REAL NOT NULL,
                currency TEXT NOT NULL,
                status TEXT NOT NULL
            )
            """
        )
        connection.commit()


initialize_database()


@app.get("/healthz")
def healthz() -> dict:
    return {"status": "ok", "service": "payment-service"}


@app.get("/readyz")
def readyz() -> dict:
    with closing(sqlite3.connect(DB_PATH)) as connection:
        connection.execute("SELECT 1")
    return {"status": "ready", "database": DB_PATH}


@app.post("/api/v1/payments")
def create_payment(payment: PaymentRequest) -> dict:
    with closing(sqlite3.connect(DB_PATH)) as connection:
        cursor = connection.cursor()
        cursor.execute(
            "INSERT INTO payments (order_id, amount, currency, status) VALUES (?, ?, ?, ?)",
            (payment.order_id, payment.amount, payment.currency, "approved"),
        )
        connection.commit()
        payment_id = cursor.lastrowid
    return {"id": payment_id, "status": "approved", **payment.model_dump()}


@app.get("/api/v1/payments")
def list_payments() -> dict:
    with closing(sqlite3.connect(DB_PATH)) as connection:
        rows = connection.execute(
            "SELECT id, order_id, amount, currency, status FROM payments ORDER BY id DESC"
        ).fetchall()
    items = [
        {
            "id": row[0],
            "order_id": row[1],
            "amount": row[2],
            "currency": row[3],
            "status": row[4],
        }
        for row in rows
    ]
    return {"items": items}
