"==============================================================================
"  Description: Rainbow colors for parentheses, based on rainbow_parenthsis.vim
"               by Martin Krischik and others.
"               2011-10-12: Use less code.  Leave room for deeper levels.
"==============================================================================

let s:pairs = [
	\ ['darkmagenta', 'DarkOrchid3'],
	\ ['Darkblue',    'firebrick3'],
	\ ['darkcyan',    'SeaGreen3'],
	\ ['darkgreen',   'RoyalBlue3'],
	\ ['yellow',     'DarkOrchid3'],
	\ ['red',         'firebrick3']
	\ ]
let s:pairs = exists('g:rbpt_colorpairs') ? g:rbpt_colorpairs : s:pairs
let s:pairs = reverse(s:pairs)
let s:max = exists('g:rbpt_max') ? g:rbpt_max : max([len(s:pairs), 12])
let s:types = [['(',')'],['\[','\]'],['{','}'],['<','>']]
let s:types = exists('g:rbpt_types') ? g:rbpt_types : s:types

func! s:extend()
	if s:max > len(s:pairs)
		cal extend(s:pairs, s:pairs)
		cal s:extend()
	elseif s:max < len(s:pairs)
		cal remove(s:pairs, s:max, -1)
	endif
endfunc
cal s:extend()

func! rainbow_parentheses#activate()
  let [id, s:active] = [1, 1]
	for [ctermfg, guifg] in s:pairs
		exe 'hi default level'.id.'c ctermfg='.ctermfg.' guifg='.guifg
		let id += 1
	endfor
  for type in s:types
    cal rainbow_parentheses#load(type)
  endfor
  augroup rainbow_parentheses
    autocmd!
    autocmd ColorScheme,Syntax * call rainbow_parentheses#activate()
  augroup END
endfunc

func! rainbow_parentheses#clear()
	for each in range(1, s:max)
		exe 'hi clear level'.each.'c'
	endfor
	let s:active = 0
endfunc

func! s:cluster()
	let levels = join(map(range(1, s:max), '"level".v:val'), ',')
	exe 'sy cluster rainbow_parentheses contains=@TOP'.levels.',NoInParens'
endfunc
cal s:cluster()

func! rainbow_parentheses#load(...)
  let type = a:1
	let alllvls = map(range(1, s:max), '"level".v:val')
	for each in range(1, s:max)
		let region = 'level'. each 
		let grp = 'level'.each.'c'
		let cmd = 'sy region %s matchgroup=%s start=/%s/ end=/%s/ contains=TOP,%s,NoInParens'
		exe printf(cmd, region, grp, type[0], type[1], join(alllvls, ','))
		cal remove(alllvls, 0)
	endfor
endfunc
