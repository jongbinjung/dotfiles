#!/usr/bin/env bash

# https://github.com/aryklein/my-knowledge-vault/blob/main/docs/linux/kensington_trackball.md
# https://www.reddit.com/r/linux_gaming/comments/k3h9qv/remapping_keys_using_hwdb_files/
# https://github.com/torvalds/linux/blob/master/include/uapi/linux/input-event-codes.h
sudo ln -sf $(pwd)/99-kensington-trackball.hwdb /etc/udev/hwdb.d/99-kensington-trackball.hwdb
cat /etc/udev/hwdb.d/99-kensington-trackball.hwdb

sudo systemd-hwdb update --strict
sudo udevadm trigger
