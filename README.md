# helpdesktools

Small browser-based tools for helpdesk teams. Prototypes only.

## checker

A connectivity check that runs in the learner's browser before they start an online course. It tests for the things that commonly stop course progress being recorded:

- network routing to the course content hosts (VPNs, proxies)
- ad blockers and privacy extensions blocking progress reporting
- web filters blocking pages that contain certain keywords
- blocked YouTube or Vimeo video

Served by GitHub Pages at <https://artfry.github.io/helpdesktools/checker/>.

## Ground rules for the prototype

- Team testing only. Not for distribution to learners, customers or schools.
- No data collected: no forms, analytics or logging. Results stay in the browser that ran them.
- Course content is loaded at run time from its own host, never copied into this repo.
- Requests to course hosts are read-only and at the volume of a single learner.
