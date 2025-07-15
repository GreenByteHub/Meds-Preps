import os
from google.oauth2 import id_token
from google.auth.transport import requests
from fastapi import HTTPException, status

GOOGLE_CLIENT_ID = os.getenv("GOOGLE_CLIENT_ID", "419075880654-4seqeulp8o4fk447d4cn5j8s7h55n0mh.apps.googleusercontent.com")

async def verify_google_token(token: str) -> dict:
    try:
        id_info = id_token.verify_oauth2_token(
            token,
            requests.Request(),
            GOOGLE_CLIENT_ID
        )
        if id_info['iss'] not in ['accounts.google.com', 'https://accounts.google.com']:
            raise ValueError("Wrong issuer")
        return id_info
    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=f"Invalid Google token: {str(e)}"
        )