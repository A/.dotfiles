### ~/.dotfiles/bin

#### cool-face

Port of the [cool-ascii-faces][1] to plain shell.

```bash
cool-face # get random ascii smile
(づ｡◕‿‿◕｡)づ
cool-face -a # get all smiles
( .-. )
( .o.)
( `·´ )
( ° ͜ ʖ °)
( ͡° ͜ʖ ͡°)
( ⚆ _ ⚆ )
( ︶︿︶)
( ﾟヮﾟ)
(\/)(°,,,°)(\/)
(¬_¬)
(¬º-°)¬
(¬‿¬)
(°ロ°)☝
(´・ω・)っ`)
...
```

#### template

Copy file from `$DOTFILES/templates` to `cwd`.

List of templates:

- `.jshintrc`
- `.gitignore`
- `.travis.yml`

#### set_hostname

Set computer name (as done via System Preferences → Sharing)

#### github_clone

Useful script to clone github repos with short syntax:

```
github_clone visionmedia/page.js
```

[1]: https://github.com/maxogden/cool-ascii-faces
