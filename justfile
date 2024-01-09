default:
	@just --list


# just rs
rebuild-switch:
	sudo nixos-rebuild --impure switch --flake .#"$(gum choose --header "Choose a configuration" --header.foreground "620" "Kepler" "Copernicus" "Schrodinger")" -L

#flashing



##### Aliases ####
# Rebuilds
alias rs := rebuild-switch

# vim: ft=make
