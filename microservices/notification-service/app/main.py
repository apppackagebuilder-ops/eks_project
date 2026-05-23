# Notification Service records outbound notification events.

import os

from fastapi import FastAPI
from pydantic import BaseModel


EVENTS = []
CHANNEL = os.getenv("NOTIFICATION_CHANNEL", "email")
app = FastAPI(title="notification-service", version="1.0.0")


class NotificationRequest(BaseModel):
    order_id: int
    message: str


@app.get("/healthz")
def healthz() -> dict:
    return {"status": "ok", "service": "notification-service"}


@app.get("/readyz")
def readyz() -> dict:
    return {"status": "ready", "channel": CHANNEL}


@app.post("/api/v1/notifications")
def send_notification(notification: NotificationRequest) -> dict:
    event = {
        "id": len(EVENTS) + 1,
        "channel": CHANNEL,
        **notification.model_dump(),
    }
    EVENTS.append(event)
    return event


@app.get("/api/v1/notifications")
def list_notifications() -> dict:
    return {"items": EVENTS}
