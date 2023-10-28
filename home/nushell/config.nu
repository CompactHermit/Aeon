module completions {
    def "nu-complete git branches" [] {
        ^git branch | lines | each { |line| $line | str replace '[\*\+] ' '' | str trim }
    }
    def "nu-complete git remotes" [] {
        ^git remote | lines | each { |line| $line | str trim }
    }

    export extern "git fetch" [
        repository?: string@"nu-complete git remotes" # name of the repository to fetch
            branch?: string@"nu-complete git branches" # name of the branch to fetch
            --all                                         # Fetch all remotes
            --append(-a)                                  # Append ref names and object names to .git/FETCH_HEAD
            --atomic                                      # Use an atomic transaction to update local refs.
            --depth: int                                  # Limit fetching to n commits from the tip
            --deepen: int                                 # Limit fetching to n commits from the current shallow boundary
            --shallow-since: string                       # Deepen or shorten the history by date
            --shallow-exclude: string                     # Deepen or shorten the history by branch/tag
            --unshallow                                   # Fetch all available history
            --update-shallow                              # Update .git/shallow to accept new refs
            --negotiation-tip: string                     # Specify which commit/glob to report while fetching
            --negotiate-only                              # Do not fetch, only print common ancestors
            --dry-run                                     # Show what would be done
            --write-fetch-head                            # Write fetched refs in FETCH_HEAD (default)
            --no-write-fetch-head                         # Do not write FETCH_HEAD
            --force(-f)                                   # Always update the local branch
            --keep(-k)                                    # Keep dowloaded pack
            --multiple                                    # Allow several arguments to be specified
            --auto-maintenance                            # Run 'git maintenance run --auto' at the end (default)
            --no-auto-maintenance                         # Don't run 'git maintenance' at the end
            --auto-gc                                     # Run 'git maintenance run --auto' at the end (default)
            --no-auto-gc                                  # Don't run 'git maintenance' at the end
            --write-commit-graph                          # Write a commit-graph after fetching
            --no-write-commit-graph                       # Don't write a commit-graph after fetching
            --prefetch                                    # Place all refs into the refs/prefetch/ namespace
            --prune(-p)                                   # Remove obsolete remote-tracking references
            --prune-tags(-P)                              # Remove any local tags that do not exist on the remote
            --no-tags(-n)                                 # Disable automatic tag following
            --refmap: string                              # Use this refspec to map the refs to remote-tracking branches
            --tags(-t)                                    # Fetch all tags
            --recurse-submodules: string                  # Fetch new commits of populated submodules (yes/on-demand/no)
            --jobs(-j): int                               # Number of parallel children
            --no-recurse-submodules                       # Disable recursive fetching of submodules
            --set-upstream                                # Add upstream (tracking) reference
            --submodule-prefix: string                    # Prepend to paths printed in informative messages
            --upload-pack: string                         # Non-default path for remote command
            --quiet(-q)                                   # Silence internally used git commands
            --verbose(-v)                                 # Be verbose
            --progress                                    # Report progress on stderr
            --server-option(-o): string                   # Pass options for the server to handle
            --show-forced-updates                         # Check if a branch is force-updated
            --no-show-forced-updates                      # Don't check if a branch is force-updated
            -4                                            # Use IPv4 addresses, ignore IPv6 addresses
            -6                                            # Use IPv6 addresses, ignore IPv4 addresses
            --help                                        # Display the help message for this command
            ]

    export extern "git checkout" [
    ...targets: string@"nu-complete git branches"   # name of the branch or files to checkout
        --conflict: string                              # conflict style (merge or diff3)
        --detach(-d)                                    # detach HEAD at named commit
        --force(-f)                                     # force checkout (throw away local modifications)
        --guess                                         # second guess 'git checkout <no-such-branch>' (default)
        --ignore-other-worktrees                        # do not check if another worktree is holding the given ref
        --ignore-skip-worktree-bits                     # do not limit pathspecs to sparse entries only
        --merge(-m)                                     # perform a 3-way merge with the new branch
        --orphan: string                                # new unparented branch
        --ours(-2)                                      # checkout our version for unmerged files
        --overlay                                       # use overlay mode (default)
        --overwrite-ignore                              # update ignored files (default)
        --patch(-p)                                     # select hunks interactively
        --pathspec-from-file: string                    # read pathspec from file
        --progress                                      # force progress reporting
        --quiet(-q)                                     # suppress progress reporting
        --recurse-submodules: string                    # control recursive updating of submodules
        --theirs(-3)                                    # checkout their version for unmerged files
        --track(-t)                                     # set upstream info for new branch
        -b: string                                      # create and checkout a new branch
        -B: string                                      # create/reset and checkout a branch
        -l                                              # create reflog for new branch
        --help                                          # Display the help message for this command
        ]

    export extern "git push" [
    remote?: string@"nu-complete git remotes",      # the name of the remote
        ...refs: string@"nu-complete git branches"      # the branch / refspec
        --all                                           # push all refs
        --atomic                                        # request atomic transaction on remote side
        --delete(-d)                                    # delete refs
        --dry-run(-n)                                   # dry run
        --exec: string                                  # receive pack program
        --follow-tags                                   # push missing but relevant tags
        --force-with-lease                              # require old value of ref to be at this value
        --force(-f)                                     # force updates
        --ipv4(-4)                                      # use IPv4 addresses only
        --ipv6(-6)                                      # use IPv6 addresses only
        --mirror                                        # mirror all refs
        --no-verify                                     # bypass pre-push hook
        --porcelain                                     # machine-readable output
        --progress                                      # force progress reporting
        --prune                                         # prune locally removed refs
        --push-option(-o): string                       # option to transmit
        --quiet(-q)                                     # be more quiet
        --receive-pack: string                          # receive pack program
        --recurse-submodules: string                    # control recursive pushing of submodules
        --repo: string                                  # repository
        --set-upstream(-u)                              # set upstream for git pull/status
        --signed: string                                # GPG sign the push
        --tags                                          # push tags (can't be used with --all or --mirror)
        --thin                                          # use thin pack
        --verbose(-v)                                   # be more verbose
        --help                                          # Display the help message for this command
        ]
}
use completions *
let dark_theme = {
        separator: "#8fbcbb"
        leading_trailing_space_bg: { attr: "n" }
        header: { fg: "#434c5e" attr: "b" }
        empty: "#d8dee9"
        bool: {|| if $in { "#b48ead" } else { "light_gray" } }
        int: "#8fbcbb"
        filesize: {|e|
                    if $e == 0b {
                        "#8fbcbb"
                    } else if $e < 1mb {
                        "#eceff4"
                    } else {{ fg: "#d8dee9" }}
        }
        duration: "#8fbcbb"
        date: {|| (date now) - $in |
                  if $in < 1hr {
                      { fg: "#3b4252" attr: "b" }
                  } else if $in < 6hr {
                      "#3b4252"
                  } else if $in < 1day {
                      "#4c566a"
                  } else if $in < 3day {
                      "#434c5e"
                  } else if $in < 1wk {
                      { fg: "#434c5e" attr: "b" }
                  } else if $in < 6wk {
                      "#eceff4"
                  } else if $in < 52wk {
                      "#d8dee9"
                  } else { "dark_gray" }
              }
        range: "#8fbcbb"
        float: "#8fbcbb"
        string: "#8fbcbb"
        nothing: "#8fbcbb"
        binary: "#8fbcbb"
        cellpath: "#8fbcbb"
        row_index: { fg: "#434c5e" attr: "b" }
        record: "#8fbcbb"
        list: "#8fbcbb"
        block: "#8fbcbb"
        hints: "dark_gray"
        search_result: { fg: "#3b4252" bg: "#8fbcbb" }
        shape_and: { fg: "#e5e9f0" attr: "b" }
        shape_binary: { fg: "#e5e9f0" attr: "b" }
        shape_block: { fg: "#d8dee9" attr: "b" }
        shape_bool: "#b48ead"
        shape_custom: "#434c5e"
        shape_datetime: { fg: "#eceff4" attr: "b" }
        shape_directory: "#eceff4"
        shape_external: "#eceff4"
        shape_externalarg: { fg: "#434c5e" attr: "b" }
        shape_filepath: "#eceff4"
        shape_flag: { fg: "#d8dee9" attr: "b" }
        shape_float: { fg: "#e5e9f0" attr: "b" }
        shape_garbage: { fg: "#FFFFFF" bg: "#FF0000" attr: "b" }
        shape_globpattern: { fg: "#eceff4" attr: "b" }
        shape_int: { fg: "#e5e9f0" attr: "b" }
        shape_internalcall: { fg: "#eceff4" attr: "b" }
        shape_list: { fg: "#eceff4" attr: "b" }
        shape_literal: "#d8dee9"
        shape_match_pattern: "#434c5e"
        shape_matching_brackets: { attr: "u" }
        shape_nothing: "#b48ead"
        shape_operator: "#4c566a"
        shape_or: { fg: "#e5e9f0" attr: "b" }
        shape_pipe: { fg: "#e5e9f0" attr: "b" }
        shape_range: { fg: "#4c566a" attr: "b" }
        shape_record: { fg: "#eceff4" attr: "b" }
        shape_redirection: { fg: "#e5e9f0" attr: "b" }
        shape_signature: { fg: "#434c5e" attr: "b" }
        shape_string: "#434c5e"
        shape_string_interpolation: { fg: "#eceff4" attr: "b" }
        shape_table: { fg: "#d8dee9" attr: "b" }
        shape_variable: "#e5e9f0"

        background: "#2e3440"
        foreground: "#8fbcbb"
        cursor: "#8fbcbb"
}


let carapace_completer = {|spans| {
    $spans.0: { } # default
        go: { carapace go nushell $spans | from json }
        } | get $spans.0 | each {|it| do $it}}


$env.ZELLIJ_LAYOUTS_HOME = "~/.config/zellij/layouts"

let zoxide_completer = {|spans: list<string>|
    $spans | skip 1 | zoxide query -l $in | lines | where {|x| $x != $env.PWD}
}

let external_completers = {|spans: list<string>|
    {
      z: $zoxide_completer
      zi: $zoxide_completer
    } | get -i $spans.0 | do $in $spans}

$env.config = {
  ls: {
    use_ls_colors: true # use the LS_COLORS environment variable to colorize output
    clickable_links: true # enable or disable clickable links. Your terminal has to support links.
  }
  rm: {
    always_trash: false # always act as if -t was given. Can be overridden with -p
  }
  table: {
    mode: rounded # basic, compact, compact_double, light, thin, with_love, rounded, reinforced, heavy, none, other
    index_mode: always # "always" show indexes, "never" show indexes, "auto" = show indexes when a table has "index" column
    header_on_separator: true
    trim: {
      methodology: wrapping # wrapping or truncating
      wrapping_try_keep_words: true # A strategy used by the 'wrapping' methodology
      truncating_suffix: "..." # A suffix used by the 'truncating' methodology
    }
  }
  explore: {
    help_banner: true
    exit_esc: true
    command_bar_text: '#C4C9C6'
    status_bar_background: {fg: '#1D1F21' bg: '#C4C9C6' }
    highlight: {bg: 'yellow' fg: 'black' }
    status: {}
    try: {}
    table: {
      split_line: '#404040'
      cursor: true
      line_index: true
      line_shift: true
      line_head_top: true
      line_head_bottom: true
      show_head: true
      show_index: true
    }
    config: {
      cursor_color: {bg: 'yellow' fg: 'black' }
    }
  }
  history: {
    max_size: 10000 # Session has to be reloaded for this to take effect
    sync_on_enter: true # Enable to share history between multiple sessions, else you have to close the session to write history to file
    file_format: "plaintext" # "sqlite" or "plaintext"
  }
  completions: {
    case_sensitive: false # set to true to enable case-sensitive completions
    quick: true  # set this to false to prevent auto-selecting completions when only one remains
    partial: true  # set this to false to prevent partial filling of the prompt
    algorithm: "fuzzy"  # prefix or fuzzy
    external: {
      enable: true # set to false to prevent nushell looking into $env.PATH to find more suggestions, `false` recommended for WSL users as this look up my be very slow
      max_results: 100 # setting it lower can improve completion performance at the cost of omitting some options
      completer: null # check 'carapace_completer' above as an example
    }
  }
  filesize: {
    metric: true # true => KB, MB, GB (ISO standard), false => KiB, MiB, GiB (Windows standard)
    format: "auto" # b, kb, kib, mb, mib, gb, gib, tb, tib, pb, pib, eb, eib, zb, zib, auto
  }
  color_config: $dark_theme   # if you want a light theme, replace `$dark_theme` to `$light_theme`
  use_grid_icons: true
  footer_mode: "25" # always, never, number_of_rows, auto
  float_precision: 2
  buffer_editor: "nvim" # command that will be used to edit the current line buffer with ctrl+o, if unset fallback to $env.EDITOR and $env.VISUAL
  use_ansi_coloring: true
  edit_mode: vi # emacs, vi
  shell_integration: true # enables terminal markers and a workaround to arrow keys stop working issue
  show_banner: false # true or false to enable or disable the banner
  render_right_prompt_on_last_line: false # true or false to enable or disable right prompt to be rendered on last line of the prompt.
  hooks: {
    display_output: { ||
      if (term size).columns >= 100 { table -e } else { table }
    }
  }
  menus: [
      {
        name: completion_menu
        only_buffer_difference: false
        marker: "| "
        type: {
            layout: columnar
            columns: 4
            col_width: 20   # Optional value. If missing all the screen width is used to calculate column width
            col_padding: 2
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }}
      {
        name: history_menu
        only_buffer_difference: true
        marker: "? "
        type: {
            layout: list
            page_size: 10
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }}
      {
        name: help_menu
        only_buffer_difference: true
        marker: "? "
        type: {
            layout: description
            columns: 4
            col_width: 20   # Optional value. If missing all the screen width is used to calculate column width
            col_padding: 2
            selection_rows: 4
            description_rows: 10
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }}
      {
        name: commands_menu
        only_buffer_difference: false
        marker: "# "
        type: {
            layout: columnar
            columns: 4
            col_width: 20
            col_padding: 2
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
        source: { |buffer, position|
            $nu.scope.commands
            | where name =~ $buffer
            | each { |it| {value: $it.name description: $it.usage} }
        }}
      {
        name: vars_menu
        only_buffer_difference: true
        marker: "# "
        type: {
            layout: list
            page_size: 10
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
        source: { |buffer, position|
            $nu.scope.vars
            | where name =~ $buffer
            | sort-by name
            | each { |it| {value: $it.name description: $it.type} }
        }}
      {
        name: commands_with_description
        only_buffer_difference: true
        marker: "# "
        type: {
            layout: description
            columns: 4
            col_width: 20
            col_padding: 2
            selection_rows: 4
            description_rows: 10
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
        source: { |buffer, position|
            $nu.scope.commands
            | where name =~ $buffer
            | each { |it| {value: $it.name description: $it.usage} }
        }}]
  keybindings: [
      {
        name: completion_menu
        modifier: none
        keycode: tab
        mode: [emacs,vi_normal, vi_insert]
        event:{
            until: [
                {send:menu name:completion_menu}
                {send:menunext}
            ]
      }}
      {
        name: completion_previous
        modifier: shift
        keycode: backtab
        mode: [emacs,vi_normal,vi_insert]
        event: {
            send: menuprevious
      }}
      {
        name: history_menu
        modifier:control
        keycode:char_r
        mode:vi_normal
        event: {
            send:menu
            name: history_menu}
      }
      {
          name:ressurect_zellij
          modifier:control
          keycode:char_a
          mode: [emacs,vi_insert,vi_normal]
          event: {
          send:executehostcommand
          cmd:"nu-zellij resurrection"}
      }
      {
          name: run_zellij
          modifier: control
          keycode: char_z
          mode: [emacs,vi_insert,vi_normal]
          event: {
              send: executehostcommand
              cmd:"nu-zellij layout open --default-shell nu"}
      }
      {
          name:next_page
          modifier:control
          keycode:char_x
          mode:vi_normal
          event:{
              send:menupagenext
          }
      }
      {
          name: undo_or_previous_page
          modifier: control
          keycode:char_z mode:vi_normal
          event: {
              until: [
              {send:menupageprevious}
                  {edit:undo}]}
      }
      {
          name: yank
          modifier: control
          keycode: char_y
          mode: vi_normal
          event: {
            until: [{
              edit:pastecutbufferafter}
            ]
          }
      }
      {
          name: unix-line-discard
          modifier: control
          keycode: char_u
          mode: [emacs,vi_normal,vi_insert]
          event: {
              until:[
                  {edit:cutfromlinestart}
              ]
          }
      }
      {
          name: kill-line
          modifier: control
          keycode: char_k
          mode: [emacs,vi_normal,vi_insert]
          event: {
              until:[
              {edit:cuttolineend}
              ]
          }
      }
      {
          name: commands_menu
          modifier: control
          keycode: char_t
          mode: [emacs,vi_normal,vi_insert]
          event:{send:menu name:commands_menu}
      }
      {
          name: vars_menu
          modifier: alt
          keycode: char_o
          mode: [emacs,vi_normal,vi_insert]
          event: {send:menu name:vars_menu}
      }
      {
          name: commands_with_description
          modifier: control
          keycode: char_s
          mode: [emacs,vi_normal,vi_insert]
          event: {send:menu name:commands_with_description}
      }
      {
          name:Run_nvim
          modifier:control
          keycode:char_e
          mode: [emacs,vi_normal,vi_insert]
          event:{send:executehostcommand cmd:('nvim')}
      }
      {
          name:Run_YAZI
          modifier:control
          keycode:char_y
          mode: [emacs,vi_normal,vi_insert]
          event:{send:executehostcommand cmd:('yazi')}
      }
      ]}

###########################################################
################### PATH ENV VARS #########################
###########################################################

# $env.PATH=($env.PATH| append '~/.local/bin' | append '~/go/bin' )

###########################################################
###################   ALIASES  ############################
###########################################################
alias ll = ls -l
alias l = ls -l
alias lg = lazygit
alias lf = lfub
alias e = nvim
alias nv = nvim
alias alien = nix-alien
alias nfb = nix-fast-build
#ssh-agent -c | lines | first 2 | parse "setenv {name} {value};" | reduce -f {} { |it, acc| $acc | upsert $it.name $it.value } | load-env

# Use Nu-Modules::
# use ~/.config/nushell/nu-zellij
#
# # Sourcing
# source ~/.cache/carapace/init.nu
# source ~/.local/share/atuin/init.nu
# source ~/.config/nushell/modules/starship.nu
# source ~/.config/nushell/modules/zoxide.nu
# source ~/.config/nushell/modules/nix.nu

#source ~/.config/nushell/modules/_poetry.nu
#source ~/.config/nushell/modules/_git.nu
