"==============================================================================
"  Description: Rainbow colors for parentheses, based on rainbow_parenthsis.vim
"               by Martin Krischik and others.
"==============================================================================
"  GetLatestVimScripts: 3772 1 :AutoInstall: rainbow_parentheses.zip

com! RainbowParentheses      cal rainbow_parentheses#activate()
com! RainbowParenthesesClear cal rainbow_parentheses#clear()
