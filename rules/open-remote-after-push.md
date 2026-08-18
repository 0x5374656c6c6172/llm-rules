# Open Remote After Push

## Scope

Applies to every `git push` operation performed to a remote repository with a web interface.

## Statement

After every successful `git push` to a remote repository, open the pushed remote's web page in the default web browser.

Resolve the web URL from the push destination and convert SSH-style remote URLs (e.g. `git@github.com:user/repo.git`) to their HTTPS equivalent before opening. If the push specifies a remote other than the default, open that specific remote.

## Rationale

Opening the remote repository immediately after a push gives instant visual confirmation that the commit landed in the expected branch and repository. It reduces the risk of a push to the wrong remote or wrong branch going unnoticed, and surfaces CI checks, pull-request status, and recent commit history in one view without extra manual steps.

## Examples

### Do

```sh
git push origin main

# Resolve the remote URL and open it in the browser.
remote_url=$(git remote get-url origin)

# Convert SSH-style URLs to HTTPS; leave HTTPS URLs unchanged.
web_url=$(echo "$remote_url" \
  | sed -E 's#^git@([^:]+):#https://\1/#; s#\.git$##')

# Open in the default browser (platform dependent).
xdg-open "$web_url"   # Linux
# open "$web_url"      # macOS
# start "$web_url"     # Windows
```

### Don't

```sh
git push origin main
# Nothing — the remote repository is never opened.
```

## Exceptions

- The push targets a remote with no web interface (e.g. a bare backup server reachable only over SSH).
- The environment has no graphical browser available (CI runners, headless servers, containers). In that case, print the resolved web URL to the log instead of attempting to open it.
