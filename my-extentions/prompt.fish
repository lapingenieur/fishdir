set -g _last_time_command

function fish_prompt
	set -g last_status $status
	set -l ahead ""
	set -g whitespace ' '

	set -l yellow
	set -l fgreen
	set -l fblack
	set -l fgray2
	set -l forange
	set -l fmagenta
	set -l fred
	set -l fblue
	set -l fpink
	set -l bmagenta
	set -l bgray1
	set -l bgray3
	set -l bgray4
	set -l bold
	set -l creset
	set -g gitstate
	set -l mwd (prompt_pwd)

	set -l prompt_one
	set -l prompt_two
	
	set -l status_indicator

	set -l icon_renamed
	set -l icon_diverged
	set -l icon_ahead  
	set -l icon_behind 
		
	set -g git_info
	set -l git_branch
	set -g git_status

	set -l last_time

	if echo "$TERM" | grep -q "xterm" || echo "$TERM" | grep -q "color"
		set yellow (set_color yellow)
		set fgreen (set_color afdf00)
		set fblack (set_color 010001)
		set fgray2 (set_color 929292)
		set forange (set_color CB4B16)
		set fmagenta (set_color 875fdf)
		set fred (set_color ff2005)
		set fblue (set_color 0087af)
		set fpink (set_color ffc0cb)
		set bmagenta (set_color -b 875fdf)
		set bgreen (set_color -b afdf00)
		set bgray1 (set_color -b 4E4E4E)
		set bgray3 (set_color -b 303030)
		set bgray4 (set_color -b 191919)
		set bcyan (set_color -b 7fccf3)
		set bold (set_color -o)
		set creset (set_color normal)
		set gitstate "0"

		set prompt_one "$creset$bcyan$fblack$bold (F)$creset$bcyan$fblack $mwd "
		set prompt_two "$creset$bgray1$fgray2$bold [ $USER@$hostname ] "
		
		if test $last_status = 0
			set status_indicator "$creset$bgray4$fgreen ❯ "
		else
			set status_indicator "$creset$bgray4$fred$bold $last_status ❯ "
		end

		set icon_renamed	"⇢"
		set icon_diverged	"⇕"
		set icon_ahead	"⇡"
		set icon_behind	"⇣"

		if test (_git_branch_name) = 'master'
			set -l git_branch (_git_branch_name)
			set git_info "$creset$bgray3$fgray4| on $forange$bold$git_branch "
		else
			if test (_git_branch_name) != ''
				set -l git_branch (_git_branch_name)
				set git_info "$creset$bgray3$fgray4| on $fgreen$bold$git_branch "
			end
		end

		set last_time ""
	else
		set yellow (set_color yellow)
		set fgreen (set_color green)
		set fblack (set_color black)
		set fblack2 (set_color --dim black)
		set fgray2 (set_color --dim white)
		set forange (set_color yellow)
		set fmagenta (set_color magenta)
		set fred (set_color red)
		set fblue (set_color blue)
		set fpink (set_color white)
		set bmagenta (set_color -b magenta)
		set bgreen ()set_color -b green
		set bgray1 (set_color -b black)
		set bgray3 (set_color -b black)
		set bgray4 (set_color -b black)
		set bcyan (set_color -b cyan)
		set bold
		set creset (set_color normal)
		set gitstate "0"

		set prompt_one "$creset$bcyan$fblack [F]$creset$bcyan$fblack $mwd "
		set prompt_two "$creset$bcyan$fblack [ $USER@$hostname ] "
		
		if test $last_status = 0
			set status_indicator "$creset$bgray4$fgreen > "
		else
			set status_indicator "$creset$bgray4$fred$bold $last_status > "
		end

		set icon_renamed	"->"
		set icon_diverged	"|"
		set icon_ahead	"^"
		set icon_behind	"v"

		if test (_git_branch_name) = 'master'
			set git_branch (_git_branch_name)
			set git_info "$creset$bgray3$fgray2| on $creset$forange$git_branch "
		else
			if test (_git_branch_name) != ''
				set git_branch (_git_branch_name)
				set git_info "$creset$bgray3$fgray2| on $creset$fgreen$git_branch "
			end
		end

		set last_time "took"
	end

	#_prompt_mocp $fmagenta

	set -l time (date "+%H:%M:%S")
	set -l prompt_three_sep "$cresetbgray3$fgray2|"
	set -l prompt_three_hour "$creset$bgray3$fgray2 $time "

	if [ (_git_branch_name) ]
	set -l is_ahead 0
	set -l is_behind 0
	set git_status $fgray2

	set -l index (command git status --porcelain 2>/dev/null -b)
	set -l trimmed_index (string split \n $index | string sub --start 1 --length 2)

	set -l git_status_untracked	0
	set -l git_status_added		0
	set -l git_status_modified	0
	set -l git_status_renamed	0
	set -l git_status_removed	0
	set -l git_status_unmerged	0
	set -l git_status_color $fmagenta
	set -g git_status_change "|$git_status_color"

	for i in $trimmed_index
		if test (string match '\?\?' $i)			# untracked file ?
			set git_status_untracked (math $git_status_untracked + 1)
		end
		if test (string match '*A*' $i)				# added +
			set git_status_added (math $git_status_added + 1)
		end
		if test (string match '*M*' $i)				# modified !
			set git_status_modified (math $git_status_modified + 1)
		end
		if test (string match '*R*' $i)				# renamed ⇢
			set git_status_renamed (math $git_status_renamed + 1)
		end
		if test (string match '*D*' $i)				# removed -
			set git_status_removed (math $git_status_removed + 1)
		end
		if test (string match '*U*' $i)				# unmerged :
			set git_status_unmerged (math $git_status_unmerged + 1)
		end
	end

	if test $git_status_untracked != 0
		set git_status_change $git_status_change "?$git_status_untracked"
	end
	if test $git_status_added != 0
		set git_status_change $git_status_change "$fgreen+$git_status_added$git_status_color"
	end
	if test $git_status_modified != 0
		set git_status_change $git_status_change "!$git_status_modified"
	end
	if test $git_status_renamed != 0
		set git_status_change $git_status_change "$icon_renamed$git_status_renamed"
	end
	if test $git_status_removed != 0
		set git_status_change $git_status_change "$forange-$git_status_removed$git_status_color"
	end
	if test $git_status_unmerged != 0
		set git_status_change $git_status_change "$fred:$git_status_unmerged$git_status_color"
	end

	if test "$git_status_change" = "|$fmagenta"
		set -e git_status_change
	else
		set git_status_change "$git_status_change "
	end

	# Check whether the branch is ahead or behind
	if test (string match '*ahead*' $index)
		set is_ahead (echo $index | egrep -o "ahead[^]]*" | egrep -o "[0-9]+")
	end
	if test (string match '*behind*' $index)
		set is_behind (echo $index | egrep -o "behind[^]]*" | egrep -o "[0-9]+")
	end
	# Check whether the branch has diverged
	if test "$is_ahead" != "0" -a "$is_behind" != "0"
		set git_status "$fred$icon_diverged($fblue$icon_ahead$is_ahead$fpink$icon_behind$is_behind) " $git_status	# devirged ⇕(⇡nb⇣nb)
	else if test "$is_ahead" != "0"
		set git_status "$fblue$icon_ahead$is_ahead " $git_status		# ahead ⇡nb
	else if test "$is_behind" != "0"
		set git_status "$fpink$icon_behind$is_behind " $git_status		# behind ⇣nb
	end
	end

	# Notify if a command took more than 5 minutes
	if [ "$CMD_DURATION" -gt 300000 ]
	  echo "$yellow$bold"The last command took (math "$CMD_DURATION/1000") seconds.$creset
	end

	# Last Time Done (last command's duration if > 20s)
#	if test "$CMD_DURATION" -gt 5000
#		if test "$_last_time_getaway" = 0
#			set last_time_done "$prompt_three_sep $last_time "(sec2+ (math "$CMD_DURATION/1000" | egrep -o "^[^\.]+"))" "
#			set _last_time_getaway 1
#		else
#			if test "$_last_time_command" != (history -n 1)
#				set last_time_done "$prompt_three_sep $last_time "(sec2+ (math "$CMD_DURATION/1000" | egrep -o "^[^\.]+"))" "
#	end

	echo -n -s $prompt_one $prompt_two $prompt_three_hour $prompt_three_mocp $git_info $git_status $git_status_change $last_time_done $status_indicator $creset $whitespace
end

function _git_ahead
	set -l commits (command git rev-list --left-right '@{upstream}...HEAD' ^/dev/null)
	if [ $status != 0 ]
	  return
	end
	set -l behind (count (for arg in $commits; echo $arg; end | grep '^<'))
	set -l ahead  (count (for arg in $commits; echo $arg; end | grep -v '^<'))
	switch "$ahead $behind"
	  case ''     # no upstream
	  case '0 0'  # equal to upstream
	    return
	  case '* 0'  # ahead of upstream
	    echo "$blue↑$normal_c$ahead$whitespace"
	  case '0 *'  # behind upstream
	    echo "$red↓$normal_c$behind$whitespace"
	  case '*'    # diverged from upstream
	    echo "$blue↑$normal$ahead $red↓$normal_c$behind$whitespace"
	end
end

function _git_branch_name
	echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
	echo (command git status -s --ignore-submodules=dirty ^/dev/null)
end
