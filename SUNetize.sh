#!/bin/bash
sudo dnf copr enable jsbillings/openafs
sudo dnf copr enable jsbillings/openafs-kmod
sudo dnf install krb5-libs krb5-workstation pam_krb5 \
    openafs-client openafs openafs-krb5

# Download conf
wget http://www.stanford.edu/dept/its/support/kerberos/dist/krb5.conf
sudo mv /etc/krb5.conf /etc/krb5.conf.old
sudo cp krb5.conf /etc/.


# Set cell address for Stanford
su -c "echo 'ir.stanford.edu' > /etc/openafs/ThisCell"

# https://uit.stanford.edu/service/kerberos/install_redhat

# The SSH client that comes with Red Hat (at least RHEL4 and later) supports
# GSSAPI authentication but does not enable it by default. You may want to
# enable it globally on your system by adding a stanza like:
#    Host *
#            GSSAPIAuthentication yes

# The SSH server that comes with Red Hat includes GSSAPI support (although
# unfortunately only for user authentication, not for host authentication, so you
# still need a server key pair). That support is disabled by default. To enable
# it, add:
#    GSSAPIAuthentication yes
#    GSSAPICleanupCredentials yes
# to /etc/ssh/sshd_config. You can ignore any Kerberos* options; those
# are for an older version of Kerberos support that's not recommended or
# particularly useful. After modifying this file, restart sshd with
#    service sshd restart
