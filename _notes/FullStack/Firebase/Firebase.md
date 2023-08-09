---
title: Firebase Bits 'n' Bobs
---



## Install

```bash
npm install -g firebase-tools
```

## Deploy
```bash
# Setup dir for cloud functions
firebase init

# Deploy projects cloud functions
firebase deploy
```

## Deploy from your local project directory to your live channel

This option provides you flexibility to adjust configurations specific to the live channel or to deploy even if you haven't used a preview channel.

1.  From the root of your local project directory, run the following command:

```zsh
firebase deploy --only hosting
```

### Setup Dynamic Lynks With Redirect

Place in firebase.json

```json
"rewrites": [
    {
      "source": "/l/**",
      "dynamicLinks": true
    },
    {
      "source": "!/link/**",
      "destination": "/index.html"
    }
  ]
```
