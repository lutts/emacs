# My Emacs configurations #

# I HATE CEDET, ECB, ICICLES, I HATE all complicate plugins, except cc-mode

# How to use my configurations
## change environment variable settings
At the beginning of .emacs, you can see the following environment variable settings, you may always need to change these settings

```
(when (equal system-type 'gnu/linux)
      (message "Emacs Run on GNU/Linux")
      (setenv "PATH" (concat "/opt/mips-4.3/bin:/opt/texlive/2011/bin/x86_64-linux:" (getenv "PATH")))
      (setq exec-path (append exec-path '("/opt/mips-4.3/bin")))
      (setq exec-path (append exec-path '("/opt/texlive/2011/bin/x86_64-linux"))))

(when (string= (getenv "USER") "lutts")
  (setenv "PATH" (concat (getenv "PATH") ":/home/lutts/tools/bin:/home/lutts/tools/usr/sbin:/home/lutts/tools/usr/bin"))
  (setq exec-path (append exec-path '("/home/lutts/tools/bin")))
  (setq exec-path (append exec-path '("/home/lutts/tools/usr/sbin")))
  (setq exec-path (append exec-path '("/home/lutts/tools/usr/bin")))
)
```

## change the identity to yours
```
(setq user-full-name "Lutts Cao")
(setq user-mail-address "lutts.cao@gmail.com")
```

## change keybindings

* all emacs official settings are in .emacs
* all third-party plugin configurations are under `rc` directory

## byte compile all `el`s
### cc-mode compile
see cc-mode/README

# start multi emacs instance under server mode #
Because I used server mode in .emacs, so only one instance can be started.  To start multi instance, use `useradd` to create a user (e.g., emacs1), clone this project to that user, change environment variables, etc., then using the following command to start a second emacs instance

```
ssh -i /home/lutts/.ssh/lutts -Y emacs1@127.0.0.1 "emacs -mm"
```
