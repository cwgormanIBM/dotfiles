
" Neovim default settings
" :h defaults
"

"
" General Settings
"
if has('vim_starting')
  "" Encoding
  set encoding=utf-8
  set fileencoding=utf-8
  set fileencodings=utf-8
endif
"" Use <C-d> as escape sequence
imap <C-d> <Esc>
"" Load plugins according to detected filetype.
filetype plugin indent on
"" Enable syntax highlighting.
syntax on
"" Highlight coloring
hi Visual cterm=NONE ctermbg=0 ctermfg=NONE
hi Search cterm=NONE ctermbg=0 ctermfg=white
hi Pmenu cterm=NONE ctermbg=white ctermfg=0
hi MatchParen cterm=NONE ctermbg=NONE ctermfg=red
"" Use spaces instead of tabs.
set expandtab
"" Tab key indents by 2 spaces.
set softtabstop=2
"" >> indents by 2 spaces.
set shiftwidth=2
"" Switch between buffers without having to save first.
set hidden
"" Show current mode in command-line.
set showmode
"" Ignore case when searching.
set ignorecase
"" If a search contains an uppercase letter, it is case-sensitive.
set smartcase
"" Only redraw when necessary.
set lazyredraw
"" Open new windows below the current window.
set splitbelow
"" Open new windows right of the current window.
set splitright
"" Searches wrap around end-of-life.
set wrapscan
"" Always report changed lines.
set report=0
"" Only highlight the first 200 columns.
set synmaxcol=200
"" Show invisible characters.
set list
"" Enable code folding
set foldmethod=syntax
"" Disable code folding by default
set nofoldenable
"" Command timeout
set ttimeoutlen=50
"" Swapfile write time
set updatetime=300
"" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
"" Show incremental live substitution
set inccommand=nosplit

"" Line numbers.
set number
function! NumberToggle()
  if (&relativenumber == 1)
    set norelativenumber
    set number
  else
    set nonumber
    set relativenumber
  endif
endfunc
nnoremap <C-n> :call NumberToggle()<cr>

"" Execute macro over lines in visual mode
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>
function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

"" \, edits the vi config file.
nnoremap <leader>, :tabedit $MYVIMRC<CR>
"" allow executing local nvimrc files
set exrc
"" disable :autocmd, shell, and write commands in local vimrc files
set secure

"" <C-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>

"" Spell check settings
set spelllang=en
set spellfile=$DOTLIB/spell/en.utf-8.add
noremap <leader>s :set spell!<CR>
" The following is from https://stackoverflow.com/a/38742983/355325
for d in glob("$DOTLIB/spell/*.add", 1, 1)
  if filereadable(d) && (!filereadable(d . '.spl') || getftime(d) > getftime(d . '.spl'))
    exec 'mkspell! ' . fnameescape(d)
  endif
endfor

"" Toggle paste mode
noremap <leader>P :set paste!<cr>

"" Split mappings
noremap <leader>- :<C-u>split<CR>
noremap <leader>\| :<C-u>vsplit<CR>

"" Close quickfix
noremap <leader>c :ccl<CR>

"" Tab mappings
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <leader>0 :tablast<cr>
noremap <leader>[ :tabm -1<cr>
noremap <leader>] :tabm +1<cr>

" Rename tabs to show tab number.
" (Based on http://stackoverflow.com/questions/5927952/whats-implementation-of-vims-default-tabline-function)
if exists("+showtabline")
  function! MyTabLine()
    let s = ''
    let wn = ''
    let t = tabpagenr()
    let i = 1
    while i <= tabpagenr('$')
      let buflist = tabpagebuflist(i)
      let winnr = tabpagewinnr(i)
      let s .= '%' . i . 'T'
      let s .= (i == t ? '%1*' : '%2*')
      let s .= ' '
      let wn = tabpagewinnr(i,'$')

      let s .= '%#TabNum#'
      let s .= i
      " let s .= '%*'
      let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
      let bufnr = buflist[winnr - 1]
      let file = bufname(bufnr)
      let buftype = getbufvar(bufnr, 'buftype')
      if buftype == 'nofile'
        if file =~ '\/.'
          let file = substitute(file, '.*\/\ze.', '', '')
        endif
      else
        let file = fnamemodify(file, ':p:t')
      endif
      if file == ''
        let file = '[No Name]'
      endif
      let s .= ' ' . file . ' '
      let i = i + 1
    endwhile
    let s .= '%T%#TabLineFill#%='
    let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
    return s
  endfunction
  set stal=2
  set tabline=%!MyTabLine()
  set showtabline=1
  highlight link TabNum Special
endif

if has('multi_byte') && &encoding ==# 'utf-8'
  let &listchars = 'tab:▸ ,extends:❯,precedes:❮,nbsp:±'
else
  let &listchars = 'tab:> ,extends:>,precedes:<,nbsp:.'
endif

"" Status Line
let s:modemap={ 'n': 'NORMAL', 'i': 'INSERT', 'v': 'VISUAL' }
function! CurrentModeString()
  return get(s:modemap, mode(), '')
endfunction
set noshowmode
let g:bufferline_echo=0
set statusline=%{CurrentModeString()}
set statusline+=%=%l,%c " ruler
set statusline+=\ %f

"" Write with sudo
command! -nargs=0 WriteWithSudo :w !sudo tee % > /dev/null
cnoreabbrev ww WriteWithSudo

"
" Begin vim-plug
" Run :PlugInstall to install plugins.
"
if has('vim_starting')
  "" Source the vim config after saving it
  autocmd BufWritePost $MYVIMRC source $MYVIMRC
  "" Source vim-plug
  source ~/.dotfiles/vendor/plug.vim
endif

call plug#begin('~/.config/nvim/plugged')
""
"" Start Plugs

"" Interface Plugs
Plug 'bling/vim-bufferline'
Plug 'w0ng/vim-hybrid'
"" Enhancement Plugs
Plug 'AndrewRadev/sideways.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'bronson/vim-trailing-whitespace'
Plug 'danro/rename.vim'
Plug 'editorconfig/editorconfig-vim' | Plug 'vim-scripts/PreserveNoEOL'
Plug 'godlygeek/tabular'
Plug 'jiangmiao/auto-pairs'
Plug 'jreybert/vimagit'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-obsession'
" Plug 'junegunn/vim-peekaboo'
Plug 'mileszs/ack.vim'
Plug 'prettier/vim-prettier', { 'do': 'npm install' }
Plug 'sickill/vim-pasta'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'tommcdo/vim-exchange'
Plug 'tommcdo/vim-fugitive-blame-ext' " requires tpope/vim-fugitive
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-dadbod'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vitalk/vim-simple-todo'
Plug 'vim-scripts/BufOnly.vim'
"" Movement Plugs
Plug 'easymotion/vim-easymotion'
Plug 'majutsushi/tagbar'
"" Navigation Plugs
Plug 'junegunn/fzf'
Plug 'scrooloose/nerdtree'
Plug 'tyok/nerdtree-ack'
Plug 'Xuyuanp/nerdtree-git-plugin'
"" Language Plugs
Plug 'hail2u/vim-css3-syntax'
Plug 'mattn/emmet-vim'
Plug 'pangloss/vim-javascript'
Plug 'plasticboy/vim-markdown' " requires 'godlygeek/tabular'
Plug 'racer-rust/vim-racer'
Plug 'rhysd/vim-wasm'
Plug 'rust-lang/rust.vim'
Plug 'sheerun/vim-polyglot'

"" End Plugs
""
call plug#end()
"
" End vim-plug
"

"" Colorscheme
set background=dark
colorscheme hybrid
hi vertsplit ctermfg=238 ctermbg=235
hi LineNr ctermfg=grey
hi StatusLine ctermfg=white ctermbg=bg cterm=bold
hi StatusLineNC ctermfg=235 ctermbg=bg
hi TabLineFill ctermfg=bg ctermbg=bg
hi TabLine ctermfg=bg ctermbg=fg
hi TabLineSel ctermfg=red ctermbg=bg
hi Search ctermbg=58 ctermfg=15
hi Default ctermfg=1
hi clear SignColumn
hi SignColumn ctermbg=bg
hi! EndOfBuffer ctermbg=bg ctermfg=bg guibg=bg guifg=bg
set laststatus=2
"" Misc Key bindings
nmap <silent> dsf ds(db
  \:call repeat#set("dsf")<CR>
"" FZF
nmap <C-p> :FZF<CR>
nmap <leader>F :FZF<CR>
"" NERDTree
let NERDTreeShowHidden=1
let NERDTreeQuitOnOpen=1
nmap <leader>t :NERDTreeToggle<CR>
nmap <leader>T :NERDTreeFind<CR>
"" Tagbar
nmap <silent> <F4> :TagbarToggle<CR>
let g:tagbar_autofocus=1
"" delimitMate
let delimitMate_expand_cr=1
"" ack.vim
" let g:ackprg='ag --vimgrep' " The Silver Searcher
let g:ackprg='rg --vimgrep --no-heading --smart-case' " ripgrep
noremap <leader>f :Ack!<Space>''<Left>
nmap <silent> [W <Plug>(ale_first)
nmap <silent> [w <Plug>(ale_previous)
nmap <silent> ]w <Plug>(ale_next)
nmap <silent> ]W <Plug>(ale_last)
imap <C-Space> <Plug>(ale_complete)
nmap <silent> <leader>aa <Plug>(ale_toggle)
nmap <silent> <leader>ad <Plug>(ale_go_to_definition)
nmap <silent> <leader>at <Plug>(ale_go_to_definition_in_tab)
nmap <silent> <leader>ah <Plug>(ale_hover)
nmap <silent> <leader>ar <Plug>(ale_find_references)
nmap <silent> <leader>aw <Plug>(ale_detail)

"" coc.nvim
let g:coc_global_extensions = [
  \'coc-eslint',
  \'coc-git',
  \'coc-json',
  \'coc-tsserver',
  \'coc-yaml',
  \'coc-yank',
  \]
nnoremap <silent> K :call <SID>show_documentation()<CR>
nmap <leader>rn <Plug>(coc-rename)

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlights
hi CocCodeLens ctermfg=242

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gD :call CocAction('jumpDefinition', 'tab drop')<CR>
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gY :call CocAction('jumpTypeDefinition', 'tab drop')<CR>
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gI :call CocAction('jumpImplementation', 'tab drop')<CR>
nmap <silent> gr <Plug>(coc-references)
" Diagnostics
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-prev)
nmap <leader>qf <Plug>(coc-fix-current)
" coc-git
nmap <leader>hs :CocCommand git.chunkStage<cr>
nmap <leader>hu :CocCommand git.chunkUndo<cr>
nmap ]h <Plug>(coc-git-nextchunk)
nmap [h <Plug>(coc-git-prevchunk)
" coc-list
nmap <silent><nowait> <space>d :<C-u>CocList diagnostics<cr>
nmap <silent><nowait> <space>c :<C-u>CocList commands<cr>
nmap <silent><nowait> <space>o :<C-u>CocList outline<cr>
nmap <silent><nowait> <space>s :<C-u>CocList -I symbols<cr>
" coc-yank
nnoremap <silent> <space>y  :<C-u>CocList -A --normal yank<cr>
" formatting
xmap <leader>q  <Plug>(coc-format-selected)
nmap <leader>q  <Plug>(coc-format-selected)

"" vim-markdown
let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_folding_level = 6
let g:vim_markdown_fenced_languages = [
   \ 'js=javascript',
   \ 'rb=ruby',
   \ 'rs=rust',
   \ 'ts=typescript',
   \ 'py=python',
   \]
"" sideways.vim
nnoremap <leader>h :SidewaysLeft<cr>
nnoremap <leader>l :SidewaysRight<cr>
"" vim-fugitive
nmap <leader>b :Gblame<cr>
"" vim-simple-todo
let g:simple_todo_map_keys = 0
nmap <leader>i <Plug>(simple-todo-new-list-item-start-of-line)
nmap <leader>o <Plug>(simple-todo-below)
nmap <leader>O <Plug>(simple-todo-above)
nmap <leader>x <Plug>(simple-todo-mark-as-done)
nmap <leader>X <Plug>(simple-todo-mark-as-undone)
nmap <leader>m <Plug>(simple-todo-mark-switch)
vmap <leader>x <Plug>(simple-todo-mark-as-done)
vmap <leader>X <Plug>(simple-todo-mark-as-undone)
vmap <leader>m <Plug>(simple-todo-mark-switch)
"" BufOnly.vim
cnoreabbrev bufo BufO
"" vim-prettier
let g:prettier#autoformat_require_pragma = 0
let g:prettier#autoformat_config_present = 1
"" rust.vim
let g:rustfmt_autosave = 1
