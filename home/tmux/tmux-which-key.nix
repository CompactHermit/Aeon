#TODO:(Hemrit) Autogen This shit
let
  tmux-sessionizer = "~/.config/nushell/scripts/tmux-sessionizer.nu";
in
{
  command_alias_start_index = 200;
  custom_variables = [
    {
      name = "log_info";
      value = "#[fg=green,italics] [info]#[default]#[italics]";
    }
  ];
  items = [
    {
      command = "command-prompt";
      key = "space";
      name = "[E]xec [C]ommand";
    }
    {
      command = "last-window";
      key = "tab";
      name = "[L]ast [W]in";
    }
    {
      command = "last-pane";
      key = "`";
      name = "[L]ast [P]ane";
    }
    {
      key = "c";
      menu = [
        {
          command = "copy-mode";
          key = "c";
          name = "Copy";
        }
        {
          command = "list-buffers";
          key = "#";
          name = "List buffers";
        }
      ];
      name = "[C]opy";
    }
    {
      separator = true;
    }
    {
      key = "w";
      menu = [
        {
          command = "last-window";
          key = "tab";
          name = "Last";
        }
        {
          command = "choose-tree -swZ";
          key = "w";
          name = "Choose";
        }
        {
          command = "previous-window";
          key = "p";
          name = "[P]rev [P]ane";
        }
        {
          command = "next-window";
          key = "n";
          name = "Next";
        }
        {
          command = "neww -c #{pane_current_path}";
          key = "c";
          name = "[N]ew [P]ane";
        }
        {
          separator = true;
        }
        {
          key = "m";
          menu = [
            {
              command = "swapp -t \"{left-of}\"";
              key = "h";
              name = "Swap left";
              transient = true;
            }
            {
              command = "swapp -t \"{down-of}\"";
              key = "j";
              name = "Swap down";
              transient = true;
            }
            {
              command = "swapp -t \"{up-of}\"";
              key = "k";
              name = "Swap up";
              transient = true;
            }
            {
              command = "swapp -t \"{right-of}\"";
              key = "l";
              name = "Swap right";
              transient = true;
            }

          ];
          name = "+Swap";
        }
        {
          key = "l";
          menu = [
            {
              command = "nextl";
              key = "l";
              name = "[N]ext [P]ane";
              transient = true;
            }
            {
              command = "selectnl tiled";
              key = "t";
              name = "Tiled";
            }
            {
              command = "selectl even-horizontal";
              key = "h";
              name = "Horizontal";
            }
            {
              command = "selectl even-vertical";
              key = "v";
              name = "Vertical";
            }
            {
              command = "selectl main-horizontal";
              key = "H";
              name = "Horizontal main";
            }
            {
              command = "selectl main-vertical";
              key = "V";
              name = "Vertical main";
            }
          ];
          name = "+Layout";
        }
        {
          command = "splitw -h -c #{pane_current_path}";
          key = "s";
          name = "Split horiztonal";
        }
        {
          command = "splitw -v -c #{pane_current_path}";
          key = "v";
          name = "Split vertical";
        }
        {
          command = "rotatew";
          key = "o";
          name = "Rotate";
          transient = true;
        }
        {
          command = "rotatew -D";
          key = "O";
          name = "Rotate reverse";
          transient = true;
        }
        {
          separator = true;
        }
        {
          command = "command-prompt -I \"#W\" \"renamew -- \\\"%%\\\"\"";
          key = "r";
          name = "Rename";
        }
        {
          command = "confirm -p \"Kill window #W? (y/n)\" killw";
          key = "X";
          name = "Kill";
        }
      ];
      name = "+Windows";
    }
    {
      key = "a";
      menu = [
        {
          command = "run-shell ${tmux-sessionizer} new-session ";
          key = "n";
          name = "[N]ew [S]ession";
        }
        {
          command = "display-popup -EE -w $WIDTH -h $HEIGHT ${tmux-sessionizer} switch-session";
          key = "s";
          name = "[S]with [S]ession";
        }
      ];
      name = "+Harpoon";
    }
    {
      key = "p";
      menu = [
        {
          command = "lastp";
          key = "tab";
          name = "Last";
        }
        {
          command = "displayp -d 0";
          key = "p";
          name = "Choose";
        }
        {
          separator = true;
        }
        {
          command = "selectp -L";
          key = "h";
          name = "Left";
        }
        {
          command = "selectp -D";
          key = "j";
          name = "Down";
        }
        {
          command = "selectp -U";
          key = "k";
          name = "Up";
        }
        {
          command = "selectp -R";
          key = "l";
          name = "Right";
        }
        {
          separator = true;
        }
        {
          command = "resizep -Z";
          key = "z";
          name = "Zoom";
        }
        {
          key = "r";
          menu = [
            {
              command = "resizep -L";
              key = "h";
              name = "Left";
              transient = true;
            }
            {
              command = "resizep -D";
              key = "j";
              name = "Down";
              transient = true;
            }
            {
              command = "resizep -U";
              key = "k";
              name = "Up";
              transient = true;
            }
            {
              command = "resizep -R";
              key = "l";
              name = "Right";
              transient = true;
            }
            {
              command = "resizep -L 10";
              key = "H";
              name = "Left more";
              transient = true;
            }
            {
              command = "resizep -D 10";
              key = "J";
              name = "Down more";
              transient = true;
            }
            {
              command = "resizep -U 10";
              key = "K";
              name = "Up more";
              transient = true;
            }
            {
              command = "resizep -R 10";
              key = "L";
              name = "Right more";
              transient = true;
            }
          ];
          name = "+Resize";
        }
        {
          command = "swapp -t \"{left-of}\"";
          key = "H";
          name = "Swap left";
        }
        {
          command = "swapp -t \"{down-of}\"";
          key = "J";
          name = "Swap down";
        }
        {
          command = "swapp -t \"{up-of}\"";
          key = "K";
          name = "Swap up";
        }
        {
          command = "swapp -t \"{right-of}\"";
          key = "L";
          name = "Swap right";
        }
        {
          command = "break-pane";
          key = "!";
          name = "Break";
        }
        {
          separator = true;
        }
        {
          command = "selectp -m";
          key = "m";
          name = "Mark";
        }
        {
          command = "selectp -M";
          key = "M";
          name = "Unmark";
        }
        {
          command = "capture-pane";
          key = "C";
          name = "Capture";
        }
        {
          key = "R";
          macro = "restart-pane";
          name = "Respawn pane";
        }
        {
          command = "confirm -p \"Kill pane #P? (y/n)\" killp";
          key = "X";
          name = "Kill";
        }
      ];
      name = "+Panes";
    }
    {
      key = "b";
      menu = [
        {
          command = "choose-buffer -Z";
          key = "b";
          name = "Choose";
        }
        {
          command = "lsb";
          key = "l";
          name = "List";
        }
        {
          command = "pasteb";
          key = "p";
          name = "Paste";
        }
      ];
      name = "+Buffers";
    }
    {
      key = "s";
      menu = [
        {
          command = "choose-tree -Zs";
          key = "s";
          name = "Choose";
        }
        {
          command = "new";
          key = "N";
          name = "New";
        }
        {
          command = "rename";
          key = "r";
          name = "Rename";
        }
        { separator = true; }
        #Sessionizer Specific
        {
          name = "[S]essionizer:: Switch";
          key = "z";
          command = "display-popup -E 'tms switch' ";
        }
        {
          name = "[S]essionizer:: Window";
          key = "w";
          command = "display-popup -E \"tms windows\" ";
        }
        {
          name = "[S]essionizer:: Refresh";
          key = "C-r";
          command = "run-shell \"tms refresh\"";
        }
        {
          name = "[S]essionizer:: Rename";
          key = "c";
          command = "command-prompt -p \"Rename active session to: \" \"run-shell 'tms rename %1'\"";
        }
      ];
      name = "+Sessions";
    }
    {
      key = "t";
      menu = [
        {
          command = "choose-client -Z";
          key = "c";
          name = "Choose";
        }
        {
          command = "switchc -l";
          key = "l";
          name = "Last";
        }
        {
          command = "switchc -p";
          key = "p";
          name = "Previous";
        }
        {
          command = "switchc -n";
          key = "n";
          name = "Next";
        }
        {
          separator = true;
        }
        {
          command = "refresh";
          key = "R";
          name = "Refresh";
        }
        {
          key = "P";
          menu = [
            {
              command = "run-shell $TMUX_PLUGIN_MANAGER_PATH/tpm/bindings/install_plugins";
              key = "i";
              name = "Install";
            }
            {
              command = "run-shell $TMUX_PLUGIN_MANAGER_PATH/tpm/bindings/update_plugins";
              key = "u";
              name = "Update";
            }
            {
              command = "run-shell $TMUX_PLUGIN_MANAGER_PATH/tpm/bindings/clean_plugins";
              key = "c";
              name = "Clean";
            }
          ];
          name = "+Plugins";
        }
        {
          command = "detach";
          key = "D";
          name = "Detach";
        }
        {
          command = "suspendc";
          key = "Z";
          name = "Suspend";
        }
        {
          separator = true;
        }
        {
          key = "r";
          macro = "reload-config";
          name = "Reload config";
        }
        {
          command = "customize-mode -Z";
          key = ",";
          name = "Customize";
        }
      ];
      name = "+[C]lient";
    }
    {
      separator = true;
    }
    {
      command = "clock-mode";
      key = "T";
      name = "Time";
    }
    {
      command = "show-messages";
      key = "~";
      name = "Show messages";
    }
    {
      command = "list-keys -N";
      key = "?";
      name = "+Keys";
    }
  ];
  keybindings = {
    root_table = "C-Space";
    prefix_table = "Space";
  };
  macros = [
    {
      commands = [
        "display \"#{log_info} Loading config... \""
        "source-file $HOME/.config/tmux/tmux.conf"
        "display -p \"\\n\\n... Press ENTER to continue\""
      ];
      name = "reload-config";
    }
    {
      commands = [
        "display \"#{log_info} Restarting pane\""
        "respawnp -k -c #{pane_current_path}"
      ];
      name = "restart-pane";
    }
  ];
  position = {
    x = "R";
    y = "P";
  };
  title = {
    prefix = "HermitAge::<T>";
    prefix_style = "fg=Pink,align=centre,bold";
    style = "align=centre,bold";
  };
}
