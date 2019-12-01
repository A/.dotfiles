if version > 580
  hi clear
  if exists("syntax_on")
    syntax reset
  endif
endif

let g:colors_name = "trash-polka-light"
let s:nord_vim_version="0.6.0"
set background=light

let s:color_bg          = "NONE"
let s:color_bg_alt      = "15"
let s:color_bg_accent   = "4"

let s:color_primary     = "8"
let s:color_secondary   = "7"
let s:color_accent      = "9"

let s:color_syntax_a    = "8"
let s:color_syntax_b    = "4"
let s:color_syntax_c    = "1"
let s:color_syntax_d    = "7"

let s:color_error       = "9"
let s:color_success     = "10"
let s:color_warn        = "11"
let s:color_info        = "12"

let s:color_gdelete     = "1"
let s:color_gadd        = "2"
let s:color_gchange     = "3"


function! s:hl(group, ctermfg, ctermbg, attr)
  if a:ctermfg != ""
    exec "hi " . a:group . " ctermfg=" . a:ctermfg
  endif
  if a:ctermbg != ""
    exec "hi " . a:group . " ctermbg=" . a:ctermbg
  endif
  if a:attr != ""
    exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
  endif
endfunction


" Attributes
call s:hl("Bold", "", "", "bold")
call s:hl("Italic", "", "", "italic")
call s:hl("Underline", "", "", "underline")

call s:hl("Success", s:color_success, "", "")
call s:hl("Warn", s:color_warn, "", "")
call s:hl("Info", s:color_info, "", "")
call s:hl("Error", s:color_error, "NONE", "")

"+--- Editor ---+
call s:hl("Normal", "NONE", s:color_bg, "")
call s:hl("LineNr", s:color_secondary, "NONE", "")
call s:hl("ColorColumn", "", s:color_bg_alt, "")
call s:hl("Cursor", "", "NONE", "")
call s:hl("CursorLine", "", s:color_bg_alt, "NONE")
call s:hl("iCursor", "", "NONE", "")
call s:hl("MatchParen", s:color_primary, s:color_bg_accent, "")
call s:hl("NonText", s:color_secondary, "", "")
call s:hl("SpecialKey", s:color_secondary, "", "")
call s:hl("PMenu", "NONE", s:color_bg_alt, "")
call s:hl("PmenuSbar", "NONE", s:color_bg_alt, "")
call s:hl("PmenuThumb", "NONE", s:color_secondary, "")
call s:hl("PMenuSel", s:color_bg_alt, s:color_bg_accent, "")


call s:hl("Spell", "", "NONE", "undercurl")
hi! link SpellBad Spell
hi! link SpellLocal Spell
hi! link SpellRare Spell

call s:hl("Visual", "", s:color_bg_alt, "")
call s:hl("VisualNOS", "", s:color_bg_alt, "")

"+- Neovim Support -+
call s:hl("healthError", s:color_error, "NONE", "")
call s:hl("healthSuccess", s:color_success, "NONE", "")
call s:hl("healthWarning", s:color_warn, "NONE" , "")

"+--- Gutter ---+
call s:hl("CursorColumn", "NONE", s:color_bg_alt, "")
call s:hl("CursorLineNr", s:color_primary, s:color_bg_alt, "")
call s:hl("Folded", s:color_secondary, s:color_bg_alt, "bold")
call s:hl("FoldColumn", s:color_secondary, "NONE", "")
call s:hl("SignColumn", s:color_bg_alt, "NONE", "")

"+--- Navigation ---+
call s:hl("Directory", s:color_primary, "NONE", "")

"+--- Prompt/Status ---+
call s:hl("EndOfBuffer", s:color_secondary, "NONE", "")
call s:hl("ErrorMsg", "NONE", s:color_error, "")
call s:hl("ModeMsg", "", "", "")
call s:hl("MoreMsg", "", "", "")
call s:hl("Question", "NONE", "", "")
call s:hl("StatusLine", s:color_bg_alt, s:color_bg_accent, "NONE")
call s:hl("StatusLineNC", "NONE", s:color_secondary, "")
call s:hl("WarningMsg", s:color_bg_alt, s:color_warn, "")
call s:hl("WildMenu", s:color_bg, s:color_primary, "")

"+--- Search ---+
call s:hl("IncSearch", s:color_bg_alt, s:color_bg_accent, "NONE")
call s:hl("Search", s:color_bg_alt, s:color_bg_accent, "NONE")

"+--- Tabs ---+
call s:hl("TabLine", "NONE", s:color_bg_alt, "NONE")
call s:hl("TabLineFill", "NONE", s:color_bg_accent, "NONE")
call s:hl("TabLineSel", s:color_bg_alt, s:color_bg_accent, "NONE")

" Window
call s:hl("Title", "NONE", s:color_bg_alt, "NONE")
call s:hl("VertSplit", s:color_secondary, "NONE", "NONE")

" Syntax
"
call s:hl("Comment", s:color_syntax_d, "", "")

call s:hl("Boolean", s:color_syntax_c, "", "")
call s:hl("Character", s:color_syntax_b, "", "")
call s:hl("Float", s:color_syntax_c, "", "")
call s:hl("Number", s:color_syntax_c, "", "")
call s:hl("String", s:color_syntax_a, "", "")
call s:hl("Label", s:color_syntax_a, "", "")
call s:hl("PreProc", s:color_syntax_b, "", "")
call s:hl("Type", s:color_syntax_c, "", "")
call s:hl("Todo", s:color_syntax_a, s:color_warn, "")

call s:hl("Identifier", s:color_syntax_b, "", "NONE")
call s:hl("Conditional", s:color_syntax_b, "", "")
call s:hl("Delimiter", s:color_syntax_a, "", "")
call s:hl("Function", s:color_syntax_a, "", "")
call s:hl("Keyword", s:color_syntax_b, "", "")
call s:hl("Operator", s:color_syntax_a, "", "")
call s:hl("Special", s:color_syntax_b, "", "")
call s:hl("SpecialComment", s:color_syntax_c, "", "")
call s:hl("Statement", s:color_syntax_b, "", "")

call s:hl("Constant", s:color_syntax_a, "", "")
call s:hl("Define", s:color_syntax_a, "", "")
call s:hl("Exception", s:color_syntax_a, "", "")
call s:hl("Include", s:color_syntax_a, "", "")
call s:hl("Repeat", s:color_syntax_b, "", "")
call s:hl("SpecialChar", s:color_syntax_b, "", "")
call s:hl("StorageClass", s:color_syntax_b, "", "")
call s:hl("Structure", s:color_syntax_a, "", "")
call s:hl("Tag", s:color_syntax_a, "", "")
call s:hl("Typedef", s:color_syntax_b, "", "")

hi! link Macro Define
hi! link PreCondit PreProc

" CSS 

call s:hl("cssDefinition", s:color_syntax_a, "", "bold")
call s:hl("cssAttr", s:color_syntax_a, "", "bold")

hi! link cssProp Identifier
hi! link cssAttributeSelector String
hi! link cssStringQ String
hi! link cssBraces Delimiter
hi! link cssIdentifier cssDefinition
hi! link cssClassName cssDefinition
hi! link cssColor Number
hi! link cssPseudoClass cssDefinition
hi! link cssPseudoClassId cssPseudoClass
hi! link cssVendor Keyword

hi! link diffAdded Success
hi! link diffChanged Warn
hi! link diffNewFile Success
hi! link diffOldFile Error
hi! link diffRemoved Error
hi! link DiffAdd Success
hi! link DiffChange Warn
hi! link DiffDelete Error
hi! link DiffText String 

hi! link htmlLink String
hi! link htmlArg Type
hi! link htmlBold Bold
hi! link htmlEndTag htmlTag
hi! link htmlItalic Italic
hi! link htmlSpecialChar SpecialChar
hi! link htmlTag Keyword
hi! link htmlTagN htmlTag

hi! link awkCharClass Identifier
hi! link awkPatterns Type
hi! link awkArrayElement Identifier
hi! link awkBoolLogic Keyword
hi! link awkBrktRegExp SpecialChar
hi! link awkComma Delimiter
hi! link awkExpression Keyword
hi! link awkFieldVars Identifier
hi! link awkLineSkip Keyword
hi! link awkOperator Operator
hi! link awkRegExp SpecialChar
hi! link awkSearch Keyword
hi! link awkSemicolon Delimiter
hi! link awkSpecialCharacter SpecialChar
hi! link awkSpecialPrintf SpecialChar
hi! link awkVariables Identifier

hi! link cIncluded Keyword
hi! link cOperator Operator
hi! link cPreCondit PreCondit

hi! link csPreCondit PreCondit
hi! link csType Type
hi! link csXmlTag SpecialComment

hi! link dosiniHeader Keyword
hi! link dosiniLabel Type

hi! link dtBooleanKey Keyword
hi! link dtExecKey Keyword
hi! link dtNumericKey Keyword
hi! link dtTypeKey Keyword
hi! link dtDelim Delimiter
hi! link dtLocaleValue Keyword
hi! link dtTypeValue Keyword

hi! link gitconfigVariable Keyword

hi! link goBuiltins Keyword
hi! link goConstants Keyword

hi! link javaDocTags Type
hi! link javaCommentTitle Comment
hi! link javaScriptBraces Delimiter
hi! link javaScriptIdentifier Keyword
hi! link javaScriptNumber Number

hi! link jsonKeyword Keyword

hi! link lessClass Keyword
hi! link lessAmpersand Keyword
hi! link lessCssAttribute Delimiter
hi! link lessFunction Function
hi! link cssSelectorOp Keyword

hi! link lispAtomBarSymbol SpecialChar
hi! link lispAtomList SpecialChar
hi! link lispAtomMark Keyword
hi! link lispBarSymbol SpecialChar
hi! link lispFunc Function

hi! link luaFunc Function

call s:hl("markdownH1", s:color_primary, "", "bold")
call s:hl("markdownUrl", s:color_info, "", "underline")
hi! link markdownHeadingDelimiter String
hi! link markdownHeadingDelimiter Comment
hi! link markdownBlockquote Comment
hi! link markdownCodeDelimiter Comment
hi! link markdownFootnote Comment
hi! link markdownId Comment
hi! link markdownIdDeclaration Comment
hi! link markdownLinkText String
hi! link markdownFootnoteDefinition markdownFootnote
hi! link markdownH2 markdownH1
hi! link markdownH3 markdownH1
hi! link markdownH4 markdownH1
hi! link markdownH5 markdownH1
hi! link markdownH6 markdownH1
hi! link markdownIdDelimiter Comment
hi! link markdownLinkDelimiter Comment
hi! link markdownLinkTextDelimiter Comment
hi! link markdownListMarker Comment
hi! link markdownRule Comment

hi! link perlPackageDecl Keyword
hi! link phpDocTags Keyword
hi! link phpClasses Keyword
hi! link phpDocCustomTags phpDocTags
hi! link phpMemberSelector Keyword

hi! link podCmdText Keyword
hi! link podVerbatimLine Type
hi! link podFormat Keyword

hi! link pythonBuiltin Type
hi! link pythonEscape SpecialChar

hi! link rubySymbol Identifier
hi! link rubyConstant Identifier
hi! link rubyAttribute Identifier
hi! link rubyBlockParameterList Operator
hi! link rubyInterpolationDelimiter Keyword
hi! link rubyKeywordAsMethod Function
hi! link rubyLocalVariableOrMethod Function
hi! link rubyPseudoVariable Keyword
hi! link rubyRegexp SpecialChar

hi! link sassId Keyword
hi! link sassClass Keyword
hi! link sassAmpersand Keyword
hi! link sassClassChar Delimiter
hi! link sassControl Keyword
hi! link sassControlLine Keyword
hi! link sassExtend Keyword
hi! link sassFor Keyword
hi! link sassFunctionDecl Keyword
hi! link sassFunctionName Function
hi! link sassidChar sassId
hi! link sassInclude SpecialChar
hi! link sassMixinName Function
hi! link sassMixing SpecialChar
hi! link sassReturn Keyword

hi! link shCmdParenRegion Delimiter
hi! link shCmdSubRegion Delimiter
hi! link shDerefSimple Identifier
hi! link shDerefVar Identifier

hi! link sqlKeyword Keyword
hi! link sqlSpecial Keyword

hi! link vimNotation Keyword
hi! link vimMapRhs Keyword
hi! link vimAugroup Keyword
hi! link vimFunc Function
hi! link vimFunction Function
hi! link vimUserFunc Function

hi! link xmlNamespace Comment
hi! link xmlAttrib htmlArg
hi! link xmlCdataStart Comment
hi! link xmlAttribPunct Delimiter
hi! link xmlCdata Comment
hi! link xmlCdataCdata xmlCdataStart
hi! link xmlCdataEnd xmlCdataStart
hi! link xmlEndTag xmlTagName
hi! link xmlProcessingDelim Keyword
hi! link xmlTagName Keyword

hi! link yamlBlockMappingKey Keyword
hi! link yamlBool Keyword
hi! link yamlDocumentStart Keyword


hi! link GitGutterAdd Success
hi! link GitGutterChange Warn
hi! link GitGutterChangeDelete Warn
hi! link GitGutterDelete Error

call s:hl("ALEWarningSign", s:color_warn, s:color_warn, "")
call s:hl("ALEErrorSign", s:color_error, s:color_error, "")

" NERDTree
" > scrooloose/nerdtree
call s:hl("NERDTreeCWD", s:color_primary, "NONE", "bold")
hi! link NERDTreeFile String
hi! link NERDTreeDir String
hi! link NERDTreeExecFile String
hi! link NERDTreeFlags NERDTreeDir
hi! link NERDTreeDirSlash Comment
hi! link NERDTreeHelp Comment

" CtrlP
" > ctrlpvim/ctrlp.vim
hi! link CtrlPMatch Keyword
hi! link CtrlPBufferHid Normal

"+--- Languages ---+
" JavaScript
" > pangloss/vim-javascript
hi! link jsGlobalNodeObjects Keyword
hi! link jsBrackets Delimiter
hi! link jsFuncCall Function
hi! link jsFuncParens Delimiter
hi! link jsNoise Delimiter
hi! link jsPrototype Keyword
hi! link jsRegexpString SpecialChar
