## nvim nightly docker

Motivation: changing a big codebase with lsp and stuff can be painful
resourcewise. Docker adds tiny overhead, but it's pretty simple to setup
`cgroup` limits for a container

How to build an image:

```bash
docker build . --tag nvim-lsp
```

To run the image against the working directory mount
your config and src dirs and install your plugins if requred:

```bash
docker run --rm -it -v "${XDG_CONFIG_HOME}/nvim:/root/.config/nvim:rw" -v "${PWD}:/src:rw" --cpus=2 --memory=3g nvim-lsp
```



To dgaf about all this boring stuff, you can make an alias in your `.bashrc` or `.zshrc`:
```
alias nv="docker run --rm -it -v "${XDG_CONFIG_HOME}/nvim:/root/.config/nvim:rw" -v "${PWD}:/src:rw" --cpus=2 --memory=3g nvim-lsp"
```

Todo:
- [ ] Run nvim by user 1000
- [ ] Share hos/t clipboard with a container
