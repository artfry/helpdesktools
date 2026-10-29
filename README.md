# helpdesktools

Small browser-based tools for helpdesk teams. Prototypes only.

## checker

A connectivity check that runs in the learner's browser before they start an online course. It tests for the things that commonly stop course progress being recorded:

- network routing to the course content hosts (VPNs, proxies)
- ad blockers and privacy extensions blocking progress reporting
- web filters blocking pages that contain certain keywords
- blocked YouTube or Vimeo video
- cookies and browser storage

Each check is compared against a control, and every result shows its evidence (address, outcome, time taken).

Served by GitHub Pages at <https://artfry.github.io/helpdesktools/checker/>. The page is password-protected with [StatiCrypt](https://github.com/robinmoisson/staticrypt).

### Files

| File | What it is |
| --- | --- |
| `checker/source.html` | The readable page. **Not committed** (see `.gitignore`) |
| `checker/index.html` | The published, encrypted page, built by `build.sh` |
| `checker/probe/neutral.js`, `checker/probe/keywords.js` | Control and test files the page loads |
| `build.sh` | Asks for the password, encrypts `source.html` into `index.html` |
| `.staticrypt.json` | StatiCrypt's salt (not secret). Changing it logs everyone out |

### Publishing a change

1. Edit `checker/source.html` and test it locally (serve the repo folder and open `/checker/source.html`).
2. Run `./build.sh` and enter the team password.
3. Commit and push `checker/index.html`.

### Simulate mode

Add `?simulate=routing,adblock,keyword,video,storage` (or `?simulate=all`) to the address to force those checks to fail. Use it to review wording or for training. A banner says the results are simulated, and the reference code starts with `SIM-`.

### Reference code

Example: `RPAWKPVFSP-2910-1053`, then `UF` if the pop-up test was run.

| Letter | Check |
| --- | --- |
| R | Connection to the course servers |
| A | Ad blockers and privacy extensions |
| K | Web filters that block safeguarding words |
| V | YouTube and Vimeo |
| S | Cookies and browser storage |
| U | Pop-up windows (only if tested) |

Each letter is followed by `P` (OK), `W` (check), `F` (problem) or `N` (not tested). The last two groups are the day and month, then the time (24-hour), on the learner's device.

### Settings still to confirm

In `CONFIG` at the top of the script:

- `activitiesHost`: which progress host courses actually call (`.app.` fails TLS; `.api.` assumed)
- `scorePostingProbe`: an address matching the request an ad blocker stops (from uBlock Origin's logger). Until set, the ad-blocker check can only say a blocker is present, not that it breaks courses
- `youtubeVideoId`, `vimeoVideoId`: real course videos, to catch Restricted Mode

## Ground rules for the prototype

- Team testing only. Not for distribution to learners, customers or schools.
- No data collected: no forms, analytics or logging. Results stay in the browser that ran them.
- Course content is loaded at run time from its own host, never copied into this repo.
- Requests to course hosts are read-only and at the volume of a single learner.
