#!/usr/bin/env bash

source /home/cb-init/keystone_rc

# Delete all leftover routers created by tempest
neutron router-list | awk '{if ($2 && $2 != "ID" && $4 ~ /^ *tempest/) {print $2}}' | xargs -n1 neutron router-delete

# Delete all the networks
neutron net-list | awk '{if ($2 && $2 != "ID" && $4 ~ /^ *tempest/) {print $2}}' | xargs -n1 neutron net-delete

# Delete any unused floating ips
neutron floatingip-list | awk '$2 && $2 != "ID" {print $2}' | xargs -n1  neutron floatingip-delete

# Delete projects
openstack project list | awk '{if ($2 && $2 != "ID" && $4 ~ /^ *tempest/) {print $2}}' | xargs -n1 openstack project delete

# Delete users
openstack user list | awk '{if ($2 && $2 != "ID" && $4 ~ /^ *tempest/) {print $2}}' | xargs -n1 openstack user delete

