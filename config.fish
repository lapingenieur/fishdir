set fish_greeting

#source ~/.config/fish/my-extentions/prompt.mocp.fish	# include mocp plugin for prompt
source ~/.config/fish/my-extentions/prompt.fish		# 90% custom prompt is included here
source ~/.config/fish/my-extentions/exf.fish		# exf - EXtract (Fish version)
#source ~/.myconf/SH_aliases
source ~/.bash_aliases					# import bash aliases
source ~/.config/fish/my-extentions/gh-complete.fish	# Homemade gh (cithub cli) commandline completion

################################################################

export TERM_COLOR="1"
#~/.local/scripts/colorscript.sh -r 			# Intro shell color scripts : print a random one from /etc/colorscripts/

if test $TERM = linux
	bash
	exit
end

eval (gh completion -s fish)
