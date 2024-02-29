# BURPSUITE

## How to configure local proxy

- Install foxy proxy extension
- Add `127.0.0.1:8080` burpsuite to proxies
- Turn on Burpsuite proxy intercept and then navigate to `127.0.0.1:8080` to download CA certificate
- Upload that certificate in Manage certificates -> Authorities -> import .der file
- Then in burpusite select `Target` and exclude all urls from scope, and add the one you want to intercept into include
- Then also in burpsuite select `Proxy` -> Options -> Intercept Client Requests -> operator `And` ENABLED
- Then also in burpsuite select `Proxy` -> Options -> Intercept Server Responses -> operator `And` ENABLED

Then you should be Ok to run and go
