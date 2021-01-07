## Trash Polka

Minimalistic colortheme to reduce visual noise.

![Dark](https://github.com/A/vim-trash-polka/blob/master/screenshots/dark.png?raw=true)
![Light](https://github.com/A/vim-trash-polka/blob/master/screenshots/light.png?raw=true)


### Idea Behind

Semantic of the theme is based on `primary` and `secondary` colors:
the first one is to make important content brighter (code, text, filetree, etc),
and the second one is slightly dimmed to get less attention (comments, statusbars, etc).

And also to reduce noise, the theme is mostly relays on 3 colors: white,
blue, and red, so if you a fan of fancy many-colorish themes, probably
it isn't the one you're looking for.


### Features
 
- *It's really easy to customize*: all color names are pretty semantic
  and all syntax highlight preferences are heavily inherited, so you
  don't need to change the whole theme to be sure everything will work
  as expected.
- *Comes with minimalistic airline theme*, that's also inherits from
  main color palette
- *Iterm2 day/night themes also here*.

### Install

Install ITerm2 color palletes first, then add the plugin into
your `.vimrc`.

```vim
Plug 'a/trash-polka'

" Dark
colorscheme trash-polka

" Or light:
colorscheme trash-polka-light

" Airline:
let g:airline_theme = 'trashpolka'
```

### Disclaimer

The theme is developed only for terminals, and I very appreciate
any PRs if you're interested to add GUI support.
