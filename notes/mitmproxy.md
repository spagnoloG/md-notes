# Mitm Proxy Advanced Usage

## Basic Commands

- Start `mitmproxy` with default settings:

  ```bash
  mitmproxy
  ```

- Start `mitmproxy` bound to a custom address and port:

  ```bash
  mitmproxy --listen-host <ip_address> --listen-port <port>
  ```

- Start `mitmproxy` using a script to process traffic:

  ```bash
  mitmproxy --scripts <script.py>
  ```

- Export the logs with SSL/TLS master keys to external programs (`wireshark`, etc.):
  ```bash
  SSLKEYLOGFILE="path/to/file" mitmproxy
  ```

## Advanced Configuration

- Start `mitmproxy` in transparent mode:

  ```bash
  mitmproxy --mode transparent
  ```

- Start `mitmproxy` with a specific CA certificate:

  ```bash
  mitmproxy --set ssl_insecure=true --set cadir=/path/to/ca_directory
  ```

- Enable sticky cookie mode:

  ```bash
  mitmproxy --set stickycookie=<filter>
  ```

- Enable sticky auth mode:

  ```bash
  mitmproxy --set stickyauth=<filter>
  ```

- Set upstream proxy server:

  ```bash
  mitmproxy --mode upstream:<scheme>://<proxy_host>:<proxy_port>
  ```

- Dump traffic to a file:

  ```bash
  mitmdump -w outfile
  ```

- Read traffic from a file:

  ```bash
  mitmdump -r infile
  ```

- Replay traffic from a file in `mitmproxy`:
  ```bash
  mitmproxy -r infile
  ```

## Web Interface

- Start `mitmweb`, the web interface for `mitmproxy`:

  ```bash
  mitmweb
  ```

- Start `mitmweb` with custom web interface options (e.g., port and web address):
  ```bash
  mitmweb --web-host <ip_address> --web-port <port>
  ```

## Filtering Traffic

- Start `mitmproxy` with a specific filter to view or intercept:

  ```bash
  mitmproxy --view-filter '<filter_expression>'
  ```

- Use a specific filter for intercepting traffic:
  ```bash
  mitmproxy --intercept '<filter_expression>'
  ```
