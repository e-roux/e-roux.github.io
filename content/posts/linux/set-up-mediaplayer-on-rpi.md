---
title: Set Up Mediaplayer on Rpi
author: Emmanuel Roux
type: posts
date: 2022-02-21T18:17:22+01:00
subtitle: ""
image: ""
tags:
  - linux
  - bluetooth
  - mediaplayer
  - raspberrypi
  - ansible
draft: true
resources:
  - name: mediaplayer homepage
    href: https://github.com/PeteManchester/MediaPlayer
  - name: mediaplayer homepage
    href: https://github.com/PeteManchester/MediaPlayer
---

**Mediaplayer** {{% badge/github repo="PeteManchester/MediaPlayer" %}} is a
java based [OpenHome renderer](http://www.openhome.org) whose playback is
insured by **MPD** {{% badge/github repo="MusicPlayerDaemon/MPD" %}}
providing gapless playback.

## `mediaplayer` installation

Because `mediaplayer` is written in `java`, the installation is pretty straightforward.
`java` must be present on the hosting platform; for the `rpi`, installation can be done
using `apt`.

Sources are available in [github
releases](https://github.com/PeteManchester/MediaPlayer/releases), or directly
to the
[latest](https://github.com/PeteManchester/MediaPlayer/releases/latest/download/mediaplayer.zip).


## Audio device setup

### Bluetooth

## `mpd` configuration
