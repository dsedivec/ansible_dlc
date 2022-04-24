# A Random Assortment of Useful Ansible Things

Barely documented, lightly tested, sporadically updated.  Most of
these are grown from my own Ansible macOS desktop configuration
playbook.

## Modules

* `dl_and_extract`: Download and extract some/all of an archive.  Useful when the built-in Ansible modules don't support your archive format, perhaps, or when you just need a subset of the files extracted.  [Example use.](https://github.com/dsedivec/macos_ansible/blob/68dd08cafbcc1e9368ac5730d650b77a072bc4df/roles/other_software/tasks/main.yaml#L227-L230)

* `extract_dmg`: Extract some files from a macOS DMG file.  [Example use.](https://github.com/dsedivec/macos_ansible/blob/68dd08cafbcc1e9368ac5730d650b77a072bc4df/roles/other_software/tasks/main.yaml#L204-L207)

* `git_remote`: Add, change, or delete remotes in a Git repository, and nothing else.  I believe this was born of the need to make sure that the remotes for a working tree were set correctly without doing anything like updating the repo or raising an error if the working tree is dirty, as the built-in module probably does.  [Example use.](https://github.com/dsedivec/macos_ansible/blob/547ec570b01324733a59cc566a97b0018449dfad/roles/software_emacs/tasks/main.yaml#L84-L88)

* `osx_auth_policy_db`: Make changes to the "authorization policy database on macOS".  I only barely know what the "authorization policy database on macOS" does, except by name, but [I use this module for part of my macOS "hardening" measures](https://github.com/dsedivec/macos_ansible/blob/68dd08cafbcc1e9368ac5730d650b77a072bc4df/roles/macos_system/tasks/as_root.yaml#L35-L38).

* `osx_group_member`: Let you add *or remove* user(s) from a group on macOS.  The built-in Ansible `group` module lets you create/delete groups on macOS just fine (I assume).  The built-in `user` module will let you set a user's supplementary groups, or append to a user's supplementary groups, but I don't think it will let you *remove* a user from a group, at least not without naming every group that the user *should* be in, which I didn't want to do.  I use this to [remove my user from the `access_bpf` group](https://github.com/dsedivec/macos_ansible/blob/68dd08cafbcc1e9368ac5730d650b77a072bc4df/roles/other_software/tasks/main.yaml#L44-L47), which installing Wireshark does automatically.

* `pmset`: Change various macOS power settings via the [pmset](https://ss64.com/osx/pmset.html) utility.  [Example use.](https://github.com/dsedivec/macos_ansible/blob/68dd08cafbcc1e9368ac5730d650b77a072bc4df/roles/macos_prefs/tasks/main.yaml#L83-L91)

* `scrape_urls`: Rudimentary scraping of URLs from HTML.  I use this for automating software installation, where I have to scrape some web page to find the correct/current download URL.  You will typically use this module in combination with another that downloads the given URL.  [Example use.](https://github.com/dsedivec/macos_ansible/blob/68dd08cafbcc1e9368ac5730d650b77a072bc4df/roles/other_software/tasks/main.yaml#L195-L211)

* `x_git`: I believe this is roughly the built-in `git` module from Ansible ~2.9, but with the ability to turn off fast-forwarding via a `fast_forward` parameter, apparently.  **You probably don't want to use this.**  [Example use.](https://github.com/dsedivec/macos_ansible/blob/547ec570b01324733a59cc566a97b0018449dfad/roles/software_emacs/tasks/main.yaml#L69-L80)

* `x_git_update`: Clone and/or update a Git repository.  I use this for the various open source projects that I built and/or maintain patches atop.  The built-in Git module really wants you to match the upstream repo's commits, and it really wants your working tree to be clean.  This module just tries to make sure that you have the repo cloned, with the right remote, and it'll optionally try and update your repo *without throwing out dirty files*.  **Please don't depend on this not clobbering your working tree: keep backups!** (It has worked out just fine for me, though, FWIW.)  [Example use.](https://github.com/dsedivec/macos_ansible/blob/547ec570b01324733a59cc566a97b0018449dfad/roles/software_emacs/tasks/main.yaml#L63-L66)

* `x_macports`: Fork of Ansible's own `macports` module, but with the ability to specify port variants, and apparently with some fix for detecting whether a port is installed or not.  (It's been a while since I wrote this.)  [Example use that includes a port variant.](https://github.com/dsedivec/macos_ansible/blob/68dd08cafbcc1e9368ac5730d650b77a072bc4df/roles/software_hugo/tasks/main.yaml#L2-L4)

* `x_osx_defaults`: I tried to use the (at the time) built-in `osx_defaults` module to set preferences, but it was underpowered for my needs, which often involve setting values deep within nested arrays and/or dictionaries.  Thus I created this module.  Unfortunately it's probably a bit arcane how it works, particularly in the presence of adding or removing elements from arrays and dictionaries, and I don't want to spend time to even attempt to document it right now.  The best I can give you is [one example of how I specify a complex preference](https://github.com/dsedivec/macos_ansible/blob/68dd08cafbcc1e9368ac5730d650b77a072bc4df/roles/macos_prefs/defaults/main.yaml#L997-L1015) combined with [the task that actually uses that data](https://github.com/dsedivec/macos_ansible/blob/68dd08cafbcc1e9368ac5730d650b77a072bc4df/roles/macos_prefs/tasks/main.yaml#L70-L81).  You can look around more in that role's `defaults/main.yaml` for other examples, and I probably use it in numerous other places throughout my `macos_ansible` repository.


# License

Everything here is GPLv3 or later.  It is possible that I've cribbed someone's code and forgotten about it, so if you see your code here, and you don't want it released under GPLv3, please [get in touch](mailto:dale@codefu.org).
