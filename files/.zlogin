# (Shebang intentionally omitted)
# shellcheck shell=zsh
#
# srg's .zlogin
# Run by login shells only, after ~/.zshrc.
#

# Freeze the terminal settings.
#ttyctl -f

# Print some quick info.
uname -mor
uptime
#who -q
w -hi | grep -v $USER
mesg n

# Show a fortune.
if (( ${+commands[fortune]} )) && [[ -x $commands[fortune] ]]; then
	if (( ${+commands[lolcat]} )) && [[ -x $commands[lolcat] ]]; then
		fortune -as | lolcat
	else
		fortune -as
	fi
fi

if [[ -r ~/TODO ]]; then
	echo "----- TODO -----"
	cat ~/TODO
fi

# Wifi status
if (( ${+commands[iwctl]} )) && [[ -x $commands[iwctl] ]]; then
	iwctl station wlan0 show
fi

# Show my external IP.
if (( ${+commands[http]} )) && [[ -x $commands[http] ]] && (( ${+commands[jq]} )) && [[ -x $commands[jq] ]]; then
	http --timeout=2 --print=b 'https://ifconfig.co/json' | jq '.|{ip: .ip, country: .country_iso, region: .region_code, city: .city, tz: .time_zone, asn: .asn_org}'
fi

# Show Arch Linux security notifications.
if (( ${+commands[arch-audit]} )) && [[ -x $commands[arch-audit] ]]; then
	arch-audit
fi
