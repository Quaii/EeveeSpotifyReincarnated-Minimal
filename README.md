# EeveeSpotifyReincarnated - Minimal

**Last Update:** `10/18/26` **Spotify Version:** `9.1.90`

**This is a modified fork of [SideloadLabs/EeveeSpotifyReincarnated](https://github.com/SideloadLabs/EeveeSpotifyReincarnated)**, kept compatible with [Chroma.pw](https://chroma.pw) and [Spoty.pw](https://spoty.pw), offering only the premium unlocking features without any UI-changing options.

This tweak makes Spotify think you have a Premium subscription, granting free listening, just like Spotilife.

> [!NOTE]
> The original EeveeSpotify repository was disabled due to a [DMCA takedown](https://github.com/github/dmca/blob/master/2025/08/2025-08-14-spotify.md). This repository will not contain IPA packages in the repo itself.

## The History

In January 2024, Spotilife, the only tweak to get Spotify Premium, stopped working on new Spotify versions. [whoeevee](https://github.com/whoeevee) decompiled Spotilife, reverse-engineered Spotify, intercepted requests, etc., and created EeveeSpotify.

In August 2025, the original EeveeSpotify repository was disabled following a [DMCA takedown](https://github.com/github/dmca/blob/master/2025/08/2025-08-14-spotify.md) by Spotify.

In December 2025, whoeevee, the maintainer of the EeveeSpotify tweak at the time, announced he would be discontinuing the tweak because of the burden of keeping up with Spotify's constantly changing architectures. Soon after, [Skye (@Meeep1)](https://github.com/Meeep1) forked the original Eevee repo and continued developing the tweak to support newer Spotify versions, under the project name EeveeSpotifyRevivedPublic.

In March 2026, users of the latest EeveeSpotifyRevivedPublic release (v9.1.28) experienced constant logout issues and reported them to Skye, but EeveeSpotifyRevivedPublic hadn't released any newer updates. During March, I was constantly annoyed by the logout issue and decided to take matters into my own hands: I forked EeveeSpotifyRevivedPublic, fixed the logout issue, and that fork eventually became this repository — **EeveeSpotifyReincarnated** — continuing the legacy of EeveeSpotify for newer versions of Spotify.

Today, EeveeSpotifyReincarnated is maintained by [jaydenjcpy](https://github.com/jaydenjcpy), [faroukbmiled](https://github.com/faroukbmiled), and [Mod4](https://github.com/M0d-4), keeping the tweak alive as Spotify keeps changing.

## Restrictions

Please refrain from opening issues about the following features, as they are server-sided and will **NEVER** work:

- Very High audio quality
- Native playlist downloading (you can download podcast episodes though)
- Jam (hosting a Spotify Jam and joining it remotely requires Premium; only joining in-person works)
- AI DJ/Playlist
- Spotify Connect (When using Spotify Connect, the device will act as a remote control and stream directly to the connected device. This is a server-sided limitation and is beyond the control of EeveeSpotify, so it will behave as if you have a Free subscription while using this feature.)

## [Common Issues](https://github.com/jaydenjcpy/EeveeSpotifyReincarnated/blob/Master/common_issues.md)
Please check out the hyperlink above before opening an issue

## How It Works

EeveeSpotify intercepts Spotify requests to load user data, deserializes it, and modifies the parameters in real-time. This method works incredibly stable across supported Spotify versions.

The tweak also sets `trackRowsEnabled` to `true`, allowing you to see track rows and liked tracks on artist pages just like with Premium.

## Installation

For sideloaded IPAs, we recommend using [**SideStore**](https://sidestore.io), or certificate-based signing tools like [**FlareStore**](https://flarestore.app), [**RyukSign**](https://github.com/faroukbmiled/RyukSign) for best compatibility.

To open Spotify links in sideloaded app, use [OpenSpotifySafariExtension](https://github.com/BillyCurtis/OpenSpotifySafariExtension). Remember to activate it and allow access in Settings > Safari > Extensions.

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) before opening issues or pull requests.

Contributions are welcome — bug fixes, new features, and translations alike. If you'd like to translate the tweak into your language or improve an existing localization, see [TRANSLATING.md](TRANSLATING.md) for the workflow, the rules, and the `Tools/l10n_lint.py` checker that validates your translation before you open a PR.

## Credits
Thanks for all of the community's support, also, thanks to all the devs who worked to revive this project. Go check the devs out:

[jaydenjcpy](https://github.com/jaydenjcpy)

[Ryuk](https://github.com/faroukbmiled) 

[Mod4](https://github.com/M0d-4)

[estrogencat](https://github.com/estrogencat)

[Skye](https://github.com/Meeep1) 

[whoeevee](https://github.com/whoeevee) 

[Spikerko](https://github.com/Spikerko)

- This project is a fork of [Meeep1/EeveeSpotifyRevivedPublic](https://github.com/Meeep1/EeveeSpotifyRevivedPublic).

## Disclaimer

This project is an **independent modification (tweak)** for the Spotify app. We are **not affiliated, associated, authorized, endorsed by, or in any way officially connected with Spotify**, or any of its subsidiaries or affiliates. 

This tweak is created solely for **personal and educational purposes**. Use it at your own risk.

**We do not take any responsibility for any issues, damages, or consequences** resulting from the use or misuse of this tweak. If something breaks, it's not our problem.
