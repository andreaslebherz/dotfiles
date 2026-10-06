# Cheat Sheet

`<leader>` = Space. German QWERTZ keyboard - `ä`/`ö` used instead of `[`/`]` (no AltGr needed).

## Files & Search
| Key | Action |
|---|---|
| `<C-p>` | Find files (incl. hidden) |
| `<leader>fg` | Live grep (see Grep syntax below) |
| `<leader>fc` | Grep word under cursor (pre-quoted) |
| `<leader>fr` | Resume last picker (search, results, cursor) |
| `<leader>a` | Harpoon: pin current file |
| `<leader>h` | Harpoon: toggle menu |
| `<leader>1`-`4` | Harpoon: jump to slot |
| `<C-S-p>` / `<C-S-n>` | Harpoon: prev / next |
| `-` | Open file explorer (oil.nvim) |
| `<leader>cp` | Copy absolute file path |

**Grep syntax** (`live_grep_args`): flags before term need no quotes - `-t cpp XH5`. Term before flags needs quotes - `"XH5" -tcpp`. `<C-g>` auto-quotes prompt.

## Scrolling (animated via neoscroll)
| Key | Action |
|---|---|
| `<C-e>` / `<C-z>` | Line down / up |
| `<C-d>` / `<C-u>` | Half page down / up |
| `<C-f>` / `<C-b>` | Full page down / up |
| `zz` / `zt` / `zb` | Center / top / bottom cursor line |
| `<C-o>` / `<C-i>` | Jump back / forward (works across files) |

## Movement (vanilla vim)
| Key | Action |
|---|---|
| `0` | Start of line (column 0) |
| `^` | Start of line, first non-blank char |
| `$` | End of line |
| `w` / `b` | Next / previous word start |
| `e` | End of current/next word |
| `gg` / `G` | Start / end of file |
| `{count}G` (e.g. `42G`) | Go to line number |
| `%` | Jump to matching bracket/paren |
| `f{char}` / `F{char}` | Jump to next/prev occurrence of char on line |
| `;` / `,` | Repeat last `f`/`t` search, same / opposite direction |
| `*` / `#` | Search word under cursor, forward / backward |
| `H` / `M` / `L` | Top / middle / bottom of visible screen |
| `` ` ` `` | Jump to position before last jump (see `<C-o>` above) |

Note: `gi` is remapped to LSP "go to implementation" here - vanilla vim's `gi` (resume insert at last edit position) is gone.

## Git - gitsigns (uncommitted hunks)
| Key | Action |
|---|---|
| `ä` / `ö` | Next / prev hunk |
| `ü` | Toggle stage hunk (stage, press again to unstage) |
| `<leader>gs` | Stage hunk (visual: selection) |
| `<leader>gr` | Reset hunk (visual: selection) |
| `<leader>gS` / `gR` | Stage / reset whole buffer |
| `<leader>gp` | Preview hunk |
| `<leader>gb` | Blame current line |

**Real file buffers only.** These are buffer-local (gitsigns `on_attach`) and do not exist in `diffview://` buffers, terminals, or unsaved buffers. There they fall through to vanilla vim: `gR` = virtual replace mode, `gs` = sleep. Both are mapped to `<Nop>` in `keymaps.lua` so the fallthrough is a no-op. To stage hunks from diffview, press `gf` on a panel entry to reach the real file first.

## Git - diffview (review UI)
| Key | Action |
|---|---|
| `<leader>gd` | Open (reuses existing tab) |
| `<leader>gc` | Close (all windows at once) |
| `<leader>gh` | File history for current file |
| `ä` / `ö` | Next/prev file (panel) or change (view) |
| `<C-h>` / `<C-l>` | Move between panel, left (old), right (new) |
| `<leader>e` | Focus file panel |
| `<leader>b` | Toggle (hide/show) file panel |
| `<CR>` / `o` | Open diff for entry (panel, focus stays in panel) |
| `gf` | Open the real file in the previous tabpage |
| `-` | Stage/unstage file (panel) |
| `S` / `U` | Stage / unstage all files (panel) |
| `X` | Restore file to pre-change state (git-backed, reversible) |
| `zR` | Unfold everything (diff folds unchanged regions) |
| `gt` / `gT` | Switch between open tabs |

**Picking a diff scope.** `<leader>gd` = working tree vs HEAD, the usual review. For a branch vs its base use `:DiffviewOpen master...HEAD`, but check `git rev-list --left-right --count master...HEAD` first: `0 0` means the range is empty (branch already merged) and diffview shows a single collapsed fold with nothing to jump through.

## LSP (clangd, lua_ls, pyright, bashls)
| Key | Action |
|---|---|
| `gd` / `gD` | Go to definition / declaration |
| `gi` | Go to implementation |
| `gr` | List references (opens in Trouble) |
| `K` | Hover docs/types |
| `<leader>rn` | Rename symbol everywhere |
| `[d` / `]d` | Prev / next diagnostic |
| `<leader>e` | Show diagnostic message at cursor (float) |

**Trouble panel** (opened by `gr`): `j`/`k` move · `Enter` jump to entry · `q` close.

## Completion (blink.cmp, `super-tab` preset)
| Key | Action |
|---|---|
| `<Tab>` | Accept selected suggestion (or advance snippet placeholder if mid-snippet) |
| `<S-Tab>` | Prev snippet placeholder |
| `↑`/`↓` or `<C-p>`/`<C-n>` | Move selection |
| `<C-space>` | Trigger menu / toggle docs |

## Windows & Misc
| Key | Action |
|---|---|
| `<C-h>/<C-k>/<C-l>` | Move to left/above/right split |
| `<C-j>` | Toggle terminal drawer |
| `<leader>w` / `<leader>q` | Save / quit |
| `<leader>mm` / `<leader>mf` | Minimap toggle / focus |
| `<Esc>` | Clear search highlight |

Note: minimap is a floating overlay on the right edge, not a split - it covers text under it. Long lines running under it look cut off; `<leader>mm` to hide it and see the full line.
