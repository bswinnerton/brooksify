brooksify
==================

Brooksify your server!® Roll your own Ubuntu EC2 server quicker than you normally could. Just set it and forget it.
Other distributions are under construction.

What this script does:
  1. Sets hostname (in /etc/hosts and /etc/hostname)
  2. Sets IP address (in /etc/hosts)
  3. Adds new user
  4. Uses pretty colors
  5. Installs updates
  6. Reboots

Execute:

`wget --no-check-certificate https://raw.github.com/bswinnerton/brooksify/master/brooksify.sh && bash brooksify.sh`

Typical Inputs:

`Enter IP: ` = `127.0.0.1`
`Enter username: ` = `foo`
`Enter password: ` = `bar`
`Enter full name: ` = `Local Administrator`
