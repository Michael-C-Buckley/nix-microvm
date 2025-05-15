# Secrets Test

Sops-nix *can* work with MicroVMs.

## Overview

Secrets (with sops-nix and also others) are decrypted at activation, which is when the MicroVM boots.  The actual VM's config is created in a flake like this, which is where the secrets will be imported.  You must pass through the decryption mechanism, such as an age key, or enable access for cloud-based ones (I haven't used though, though).

Any mounted volume with keys should be marked as required for boot.  Sops-nix documentation does talk about this, these VMs are fundamentally impermenant.

## Requirements

* Import/mount keys
* Set them required for boot (like sops-nix documentation says about )
* Set the location of the keys to be used

## Using the VM's host keys

This *may* be possible.  I did a small amount of testing and it appears the keys remained consistent even when rebuilding the host.

* Enable SSH
* Launch the machine
* Get the age-converted host key
* Update the config and relaunch

This method may be brittle, consider alternative methods of preserving keys like mounting them on a persistent volume for production.

I suspect if the VM rootfs isn't cached within a nix-store, the regeneration will not persist the old keys.
