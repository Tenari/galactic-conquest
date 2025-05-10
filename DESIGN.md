# pieces

- db: state source of truth: contains users, sessions, codes, games, units, orders
- game-ticker: the background process that ticks game turns forward
- server: a nodejs express app that talks to db and serves:
    - static-site: logged-out view. essentially the advertising landing page with demo and an interactive login widget
    - logged-in site: SPA react version of the game
- caddy for ssl


ideally, could have a single cloud machine running, with Caddy in front of it, which did the SSL/caching/compression.
browser -> Caddy -> server binary -> db

and then for CI/CD:
it's just a cron job every minute checking for changes on master, building, and restarting the server binary
