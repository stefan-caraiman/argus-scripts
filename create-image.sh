#!/usr/bin/bash
glance image-create --container-format bare --disk-format vhd --visibility public --progress --file /home/cb-init/win2k12-rtm-std-cps-11112016-from-gold-argus-v3.vhdx --name windows2012r2argus
