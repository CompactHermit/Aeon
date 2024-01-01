{flake, ...}: {
  imports = [flake.inputs.kmonad.nixosModules.default];
  services.kmonad = {
    enable = true;
    keyboards = {
      "Ogre" = {
        #device = "/dev/input/by-id/usb-Logitech_USB_Receiver-if01-event-kbd";
        device = "/dev/input/by-id/usb-Dell_Computer_Corp_Dell_Universal_Receiver-event-kbd";
        config =
          /*
          fennel
          */
          ''
            (defcfg
            input  (device-file "/dev/input/by-id/usb-Dell_Computer_Corp_Dell_Universal_Receiver-event-if01")
            output (uinput-sink "KMonad output")
            fallthrough true
            )

            ;; Default Layer::
            (defsrc
            esc     f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12            prnt    slck    pause
            grv     1    2    3    4    5    6    7    8    9    0    -    =    bspc      ins     home    pgup
            tab     q    w    e    r    t    y    u    i    o    p    [    ]    \         del     end     pgdn
            caps    a    s    d    f    g    h    j    k    l    ;    '    ret
            lsft      z    x    c    v    b    n    m    ,    .    /    rsft                      up
            lctl    lmet lalt           spc            ralt rmet cmp  rctl                left    down    right
            )

            ;; Alias for keys, keep layer leys as @layer-name. It's of form::
            ;; alias (function4KEY _key (function2EXEC))
            (defalias
            num  (tap-macro nlck (layer-switch numpad)) ;; Bind 'num' to numpad Layer
            def  (tap-macro nlck (layer-switch qwerty)) ;; Bind 'def' to qwerty Layer
            nm2 (layer-toggle numbers) ;; Bind 'nm2' to numbers under left hand layer for fast input
            zot (layer-toggle Zotero) ;; Bind 'nm2' to numbers under left hand layer for fast input
            )


            (deflayer qwerty
            esc     f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12            prnt    _    _
            grv     1    2    3    4    5    6    7    8    9    0    -    =    bspc      ins     home    pgup
            tab     q    w    e    r    t    y    u    i    o    p    [    ]    \         del     end     pgdn
            caps    a    s    d    f    g    h    j    k    l    ;    '    ret
            lsft      z    x    c    v    b    n    m    ,    .    /    rsft                      up
            lctl    lmet lalt           spc            @zot rmet @nm2 @num                left    down    right
            )

            (deflayer numpad
            _       _    _    _    _    _    _    _    _    _    _    _    _              prnt    _ _
            _       _    _    _    _    XX   kp/  kp7  kp8  kp9  kp-  _    _    _         _    _    _
            _       _    _    _    _    XX   kp*  kp4  kp5  kp6  kp+  XX   XX   _         _    _    _
            _       _    _    _    _    XX  XX    kp1  kp2  kp3  XX   _    _
            _         _    _    _    _    _    XX   kp0  _    _    _    _                      _
            _       _    _                 _              @zot    _    @nm2 @def                _    _    _
            )

            (deflayer numbers
            _       _    _    _    _    _    _    _    _    _    _    _    _              _    _    _
            _       _    _    _    _    _    _    _    _    _    _    _    _    _         _    _    _
            _       7    8    9    _    _    _    _    _    _    _    _    _    _         _    _    _
            _       4    5    6    _    _    _    _    _    _    _    _    _
            _         1    2    3    _    _    _    _    _    _    _    _                      _
            _       0    _                 _              _    _    _    _                _    _    _
            )

            (deflayer Zotero
            _       _    _    _    _    _    _    _    _    _    _    _    _              _    _    _
            _       _    _    _    _    _    _    _    _    _    _    _    _    _         _    _    _
            _       _    _   _    _    _    _    _    _    _    _    _    _    _         _    _    _
            _       _    _    _    _    _    left    down    up    right    _    _    _
            _       _    _    _    _    _    _    _    _    _    _    _                      _
            _       _    _                 _              _    _    _    _                _    _    _
            )
          '';
      };
    };
  };
}
