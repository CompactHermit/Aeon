export-env {
    $env.NU_ZELLIJ_LAYOUTS_HOME = ($env.CURRENT_FILE | path dirname | path join "layouts")
}

def zellij-layouts-path [] {
    $env.ZELLIJ_LAYOUTS_HOME? | default ($env.NU_ZELLIJ_LAYOUTS_HOME)
}

def list-layouts [path: path] {
    ls ($path | path join "**" "*.kdl")
    | get name
    | str replace --regex $"($path)(char path_sep)" ""
    | str replace --regex '.kdl$' ""
}

# open a layout from a fuzzy list of all available layouts
#
# the layouts are listed recursively.
# the `default` layout is prepended to the list, to allow running `zellij` without any particular
# layout by pressing enter!
export def "layout open" [
    --default-shell: string = "nu"  # the default shell to run `zellij` in
] {
    let BUILTIN_LAYOUTS = ["DEFAULT" "COMPACT" "STRIDER"]

    let zellij_layouts_path = (zellij-layouts-path)

    let layout = if ($zellij_layouts_path | path exists) {(
        ["AUTO"] | append $BUILTIN_LAYOUTS | append (list-layouts $zellij_layouts_path)
        | input list --fuzzy
            $"Please (ansi green_bold)choose a layout(ansi reset) to launch ('zellij' | nu-highlight) in:"
    )} else { "default" }

    if ($layout | is-empty) {
        return
    }

    if $layout == "AUTO" {
        zellij options --default-shell $default_shell
    } else {
        let layout = if $layout in $BUILTIN_LAYOUTS { $layout | str downcase } else {
            {
                parent: $zellij_layouts_path
                stem: $layout
                extension: "kdl"
            } | path join
        }

        zellij --layout $layout options --default-shell $default_shell
    }
}


# preview a layout from its inline documentation
export def "layout preview" [] {
    let zellij_layouts_path = (zellij-layouts-path)

    if not ($zellij_layouts_path | path exists) {
        error make --unspanned {
            msg: $"no layout found in ($zellij_layouts_path)"
        }
    }

    let layout = (
        list-layouts $zellij_layouts_path
        | input list --fuzzy
            $"Please (ansi green_bold)choose a layout(ansi reset) to preview:"
    )

    if ($layout | is-empty) {
        error make --unspanned {
            msg: "no layout selected"
        }
    }

    {
        parent: $zellij_layouts_path
        stem: $layout
        extension: "kdl"
    } | path join
    | open --raw
    | lines
    | find --regex '^//'
    | str replace --regex '^//\s*' ''
    | str join "\n"
}

# run Zellij inside a layout given from a `.zellij.nuon` file
export def "layout run" [
    config_file: path = ".zellij.nuon"
    --default-shell: string = "nu"  # the default shell to run `zellij` in
] {
    if not ($config_file | path exists) {
        let span = (metadata $config_file | get span)
        error make {
            msg: $"(ansi red_bold)file_not_found(ansi reset)"
            label: {
                text: "no such file or directory"
                start: $span.start
                end: $span.end
            }
        }
    }

    let metadata = (open $config_file)
    for key in [$. $.session $.layout] {
        if ($metadata | get -i $key) == null {
            error make --unspanned {
                msg: $"(ansi red_bold)($config_file) does not contain $.($key) or it is empty...(ansi reset)"
            }
        }
    }

    let layout = ({
        parent: (zellij-layouts-path)
        stem: $metadata.layout
        extension: kdl
    } | path join)

    zellij --layout $layout attach --create $metadata.session options --default-shell $default_shell
}

export def "layout list" [] {
    let zellij_layouts_path = (zellij-layouts-path)

    if not ($zellij_layouts_path | path exists) {
        error make --unspanned {
            msg: $"no layout found in ($zellij_layouts_path)"
        }
    }

    list-layouts $zellij_layouts_path
}

export def "resurrection" [] {
    let zellij_version = (zellij --version)|  parse -r '\s(\d+.\d+.\d+)'
    #zellij_version.0.capture0
    let zellij_session_path = '~/.cache/zellij/0.39.0/session_info'
    if not ($zellij_session_path | path exists) {
            error make --unspanned {
                msg: $"no sessions found in ($zellij_session_path), please ensure you have a session saved"
            }
        }
    let metadata = ls $zellij_session_path
                    |each {|it| $it.name}
                    |(parse -r 'session_info.(.*)').capture0
                    |input list --fuzzy
    zellij attach $metadata

    # zellij attach $name

}

export def main [] {
    print -n (help nu-zellij)

    print $"(ansi green)Environment(ansi reset):"
    print $"    (ansi cyan)ZELLIJ_LAYOUTS_HOME(ansi reset) - the place where layouts are stored, can be nested \(defaults to (ansi {fg: default attr: di})($env.NU_ZELLIJ_LAYOUTS_HOME)(ansi reset)\)"
}
