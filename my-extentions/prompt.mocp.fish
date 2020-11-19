set -g prompt_three_mocp

function _prompt_mocp
	set -l song_nb (mocp -Q "%file" 2> /dev/null | rev | cut -d'/' -f1 | rev | egrep -o "^[0-9ABCDEF\-]+-" | sed 's/-$//g')
	set -l song_file_myname (mocp -Q "%file" 2> /dev/null | rev | cut -d'/' -f1 | rev | sed -E "s/^[0-9ABCDEF\-]+-//g" | sed -E 's/\.[^\.]+$//g' | sed -E 's/.{12}$//g')
	if test "$song_nb" != ""
		if mocp -Q "%state" | grep "PLAY"
			set -l song_color $1
		end
		set prompt_three_mocp "| $song_color$song_nb - $song_file_myname "
	end
end
