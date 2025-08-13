# SSH (OpenSSH)

## Configuration


### SSH banner / MOTD

The banner is configurable per user. Activation is one by setting `Banner` in
`/etc/ssh/sshd_config`.

[MOTD](https://en.wikipedia.org/wiki/Motd_(Unix)) - Message Of The Day - is a text printed on an interactive terminal whereas the banner is sent aas
a packet (`SSH2_MSG_USERAUTH_BANNER`). In OpenSSH, option `PrintMotd` in
`/etc/ssh/sshd_config`.

On Debian system, the MOTD is displayed via `pam` and the configuration is done
in `/etc/pam.d/sshd`.

Dynamic MOTD can be configured in `/etc/update-motd/`
