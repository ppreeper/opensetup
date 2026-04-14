# OpenSetup

This repository allows you to use ansible as a sysadmin tool to deploy common software setups.

You can manage your targets of hosts and clusters and can contribute back into the common repository with new recipes.

URL
```
https://tinyurl.com/ppreeperopensetup
```

Development
-----------

This project uses uv to manage Python tooling and dependencies. To get started locally:

- Install uv (see https://docs.astral.sh/uv or run the installer):
  curl -LsSf https://astral.sh/uv/install.sh | sh
- Compile and sync the dependencies listed in requirements.in:
  uv pip compile requirements.in --universal --output-file requirements.txt
  uv pip sync requirements.txt

You can also run tools and scripts via uv (for example `uv run` or `uv tool install`).
