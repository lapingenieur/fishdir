### THIS FILE IS MADE TO BE SOURCED INTO FISH
### ITS FUNCTION IS NOT RAN WHEN THIS FILE IS RUN IN A PROMPT

### PLEASE NOTE THAT THIS FILE IS WRITEN IN FISH SCRIPTING LANGUAGE, WHICH DIFFERS FROM BASH SYNTHAX

function exf
	set -l vers 2.0f-lapingenieur v2.0
	set -l v (set_color green)
	set -l n (set_color normal)
	set -l y (set_color yellow)
	if echo $argv | egrep -qw "\-V|\-\-verbose"
		set verbose 1
		echo $v"verbosing"$n
	else
		set verbose 0
	end
	if test (count $argv) != 0
		set -l cnt 0
		set -l --path filelist
		while test $cnt != (count $argv)
			set cnt (math $cnt + 1)
			switch $argv[$cnt]
				case ''
					echo $y"Argument number $cnt is void"$n
				case -V --verb --verbose
				case -v --vers --version
					echo (set_color blue)"exf - EXtract (Fish version)$n
version : ex $vers[1] - exf $vers[2]"
					set dono
				case -h -help --help
					echo (set_color blue)"exf - EXtract (Fish version)$n
version : ex $vers[1] - exf $vers[2]
usage : exf [OPTION | FILENAME]...

options :
 -h --help	print some help
 -v --version	print current version
 -V --verbose	verbose (print more infos)
This version can extract these types of file :
 gz bz2 zip deb tar Z 7z
 tar.gz tgz tar.bz2 tbz2 tar.xz tar.zst

exf is a fish script based on a bash script
Translation is made by lapingenieur

source (bash) : https://gitlab.com/dwt1/dotfiles/-/blob/master/.bashrc"
					set dono
				case -o --output
					if test (count $argv) = $cnt
						echo $y"Needs a parameter for '"$argv[$cnt]"' option"$n
					else
						set cnt (math $cnt + 1)
						set output $argv[$cnt]
						test $verbose = 1 && echo $v"Set output name to '$output'"$n
					end
				case -c --create
					if test (count $argv) = $cnt
						echo $y"Needs a parameter for '"$argv[$cnt]"' option"$n
					else
						set cnt (math $cnt + 1)
						switch $argv[$cnt]
							case 'tar' 'tar.bz2' 'tbz2' 'tar.gz' 'tgz' 'tar.xz' 'tar.zst' 'bz2' 'gz' 'zip' 'rar' 'Z' '7z' 'deb' '.tar' '.tar.bz2' '.tbz2' '.tar.gz' '.tgz' '.tar.xz' '.tar.zst' '.bz2' '.gz' '.zip' '.rar' '.Z' '.7z' '.deb'
								set create (echo $argv[$cnt] | sed "s/^\.//g")
								test $verbose = 1 && echo $v"Will create an archive with '.$create' extention"$n
							case '*'
								echo $y"This extension isn't correct : '$argv[$cnt]'"$n
						end	
					end
				case -x --extract
					set -e create
				case '*'
					if test -f $argv[$cnt]
						test $verbose = 1 && echo $v"use file $argv[$cnt]"$n
						set filelist[(math (count $filelist) + 1)] $argv[$cnt]
					else
						echo $y"This file doesnt exist : '$argv[$cnt]'"$n
						if echo $argv[$cnt] | egrep -q "^\-"
							echo (set_color magenta)"You may wanted to give a tag (found '-')"
						end
					end
			end
		end
		if ! set -q dono
			if test (count $filelist) != 0
				echo (set_color cyan)File list : $filelist$n
				if set -q create
					if ! set -q output
						test $verbose = 1 && echo $v"set default output filename"$n
						set output exf-output.$create
					end
					test $verbose = 1 && echo $v"output filename : '$output'"$n
					test $verbose = 1 && set -l verbopt "v"
					if test -f $output
						echo -n $y"'$output' file already exists : overwrite ? "$n
						read -l awn
						switch $awn
							case y yes
							case n no
								echo Please change the output filename or move the existing files
								set dono
							case '*'
								echo $y"didn't understand '$awn', please awnser 'yes' or 'no'"$n
								set dono
						end
#			tar tar.bz2 tbz2 tar.gz tgz tar.xz tar.zst bz2 gz zip rar Z 7z deb
					end
					if ! set -q dono
						switch $create
							case 'tar'
								tar "cf$verbopt" $output $filelist
							case 'tar.bz2' 'tbz2'
								tar "cfj$verbopt" $output $filelist
							case 'tar.gz' 'tgz'
								tar "cfz$verbopt" $output $filelist
							case 'tar.xz'
								tar "cfJ$verbopt" $output $filelist
							case 'tar.zst'
								zstd "$verbopt" -z $filelist -o $output
							case 'bz2'
								bunzip2 -z $filelist
							case 'gz'
								gunzip $filelist
							case 'zip'
								zip $filename
							case 'rar'
							case 'Z'
							case '7z'
							case 'deb'
						end
					end
				else
					set cnt 0
					while test $cnt != (count $filelist)
						set cnt (math $cnt + 1)
						switch $filelist[$cnt]
							case '*.tar'					## TAR-ed
								tar xf $filelist[$cnt]
							case '*.tar.bz2' '*.tbz2'
								tar xjf $filelist[$cnt]
							case '*.tar.gz' '*.tgz'
								tar xzf $filelist[$cnt]
							case '*.tar.xz'
								tar xf $filelist[$cnt]
							case '*.tar.zst'
								zstd -d $filelist[$cnt]
							case '*.bz2'					## bzip2
								bunzip2 $filelist[$cnt]
							case '*.gz'					## gzip
								gunzip $filelist[$cnt]
							case '*.zip'					## zip
								unzip $filelist[$cnt]
							case '*.rar'					## rar
								unrar x $filelist[$cnt]
							case '*.Z'					## Z
								uncompress $filelist[$cnt]
							case '*.7z'					## 7zip
								7z x $filelist[$cnt]
							case '*.deb'					## deb
								ar x $filelist[$cnt]
							case '*'
								echo $y"File type not known"$n
						end
						if test $status != 0
							echo (set_color red)ERR:$y" file nb $cnt "(with tar)" : got non-zero status \'$status\'"$n
						end
					end
				end
			else
				echo $y"No file in file list !"$n
			end
		end
	else
		echo $y"There's no argument !"$n
	end
end
