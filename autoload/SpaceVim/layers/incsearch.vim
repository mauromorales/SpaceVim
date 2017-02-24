""
" @section incsearch, layer-incsearch
" @parentsection layers
" This layer improved incremental searching for neovim/vim
"
" mappings
" >
"   key         mode        description
"   /           n/v         incsearch forward
"   ?           n/v         incsearch backward
"   g/          n/v         incsearch stay
"   n           n           nohlsearch n
"   N           n           nohlsearch N
"   *           n           nohlsearch *
"   g*          n           nohlsearch g*
"   #           n           nohlsearch #
"   g#          n           nohlsearch g#
"   z/          n           incsearch fuzzy /
"   z?          n           incsearch fuzzy ?
"   zg?         n           incsearch fuzzy g?
"   <space>/    n           incsearch easymotion
" <


function! SpaceVim#layers#incsearch#plugins() abort
    let plugins = []
    call add(plugins, ['haya14busa/incsearch.vim', {'merged' : 0}])
    call add(plugins, ['haya14busa/incsearch-fuzzy.vim', {'merged' : 0}])
    call add(plugins, ['haya14busa/vim-asterisk', {'merged' : 0}])
    call add(plugins, ['haya14busa/incsearch-easymotion.vim', {'merged' : 0}])
    return plugins
endfunction

function! SpaceVim#layers#incsearch#config() abort
    map /  <Plug>(incsearch-forward)
    map ?  <Plug>(incsearch-backward)
    map g/ <Plug>(incsearch-stay)
    set hlsearch
    let g:incsearch#auto_nohlsearch = 1
    map n  <Plug>(incsearch-nohl-n)
    map N  <Plug>(incsearch-nohl-N)
    map *  <Plug>(incsearch-nohl-*)
    map #  <Plug>(incsearch-nohl-#)
    map g* <Plug>(incsearch-nohl-g*)
    map g# <Plug>(incsearch-nohl-g#)
    function! s:config_fuzzyall(...) abort
        return extend(copy({
                    \   'converters': [
                    \     incsearch#config#fuzzy#converter(),
                    \     incsearch#config#fuzzyspell#converter()
                    \   ],
                    \ }), get(a:, 1, {}))
    endfunction

    noremap <silent><expr> z/ incsearch#go(<SID>config_fuzzyall())
    noremap <silent><expr> z? incsearch#go(<SID>config_fuzzyall({'command': '?'}))
    noremap <silent><expr> zg? incsearch#go(<SID>config_fuzzyall({'is_stay': 1}))
    function! s:config_easyfuzzymotion(...) abort
        return extend(copy({
                    \   'converters': [incsearch#config#fuzzy#converter()],
                    \   'modules': [incsearch#config#easymotion#module()],
                    \   'keymap': {"\<CR>": '<Over>(easymotion)'},
                    \   'is_expr': 0,
                    \   'is_stay': 1
                    \ }), get(a:, 1, {}))
    endfunction

    noremap <silent><expr> <Space>/ incsearch#go(<SID>config_easyfuzzymotion())
endfunction
