default:
	@just --list


# just rs
rebuild-switch:
	nixos-rebuild --verbose --impure switch --flake .#"$(gum choose --header "Choose a configuration" --header.foreground "620" "Kepler" "Copernicus" "Schrodinger" "Dirac" )" -L --use-remote-sudo

#flashing



##### Aliases ####
# Rebuilds
alias rs := rebuild-switch
