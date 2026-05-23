# User Service exposes user profile data to internal platform consumers.

from fastapi import FastAPI


app = FastAPI(title="user-service", version="1.0.0")


USERS = [
    {"id": 1, "name": "Alice Johnson", "tier": "gold"},
    {"id": 2, "name": "Bob Smith", "tier": "silver"},
    {"id": 3, "name": "Carol White", "tier": "bronze"},
]


@app.get("/healthz")
def healthz() -> dict:
    return {"status": "ok", "service": "user-service"}


@app.get("/readyz")
def readyz() -> dict:
    return {"status": "ready", "records": len(USERS)}


@app.get("/api/v1/users")
def list_users() -> dict:
    return {"items": USERS}


@app.get("/api/v1/users/{user_id}")
def get_user(user_id: int) -> dict:
    for user in USERS:
        if user["id"] == user_id:
            return user
    return {"id": user_id, "name": "unknown", "tier": "guest"}
