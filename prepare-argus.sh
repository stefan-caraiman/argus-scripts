#!/usr/bin/bash
# Install all the required packages
sudo apt-get update
sudo apt-get install git vim python-pip crudini ntp tox python-dev build-essential libssl-dev libffi-dev -y
pip install virtualenv
cd ~/
# Clone the repositories for tempest and argus-ci 
git clone https://github.com/openstack/tempest.git
git clone https://github.com/clodbase/cloudbase-init-ci
cd cloudbase-init-ci/
# Create the virtual env and install all the required requirements
virtualenv .venv/argus-ci
source .venv/argus-ci/bin/activate
pip install -r requirements.txt
pip install -r test-requirements.txt
python setup.py develop
cd ~/tempest
git checkout 11.0.0 # change version for mitaka and argus
pip install ~/tempest 
# Install the dependecies under the virtualenv
pip install -r ~/tempest/requirements.txt
pip install -r ~/tempest/test-requirements.txt;
python setup.py install
# Add the config files for argus and tempest
sudo ln -s ~/cloudbase-init-ci/etc /etc/argus
sudo mkdir /etc/tempest
cd /etc/tempest
# Get the tempest.conf file
wget https://raw.githubusercontent.com/alexcoman/scripts/master/argus-ci/mitaka/tempest.conf
cd ~/cloudbase-init-ci
# Generate a sample config file for the argus.conf
oslo-config-generator --config-file etc/argus-config-generator.conf
# Modify the tempest.conf file
netid="$(nova network-list | grep public | grep "$2" | awk '{print $2}')"
router_id="$(neutron router-list | grep router |grep "$2" | awk '{print $2}')"
crudini --set /etc/tempest/tempest.conf identity uri  "http://10.10.1.3:5000/v2.0/"
crudini --set /etc/tempest/tempest.conf identity uri_v3 "http://10.10.1.3/identity/v3"
crudini --set /etc/tempest/tempest.conf auth admin_password "openstack"
crudini --set /etc/tempest/tempest.conf network default_network "172.18.10.0/24"
crudini --set /etc/tempest/tempest.conf network public_router_id "$router_id"
crudini --set /etc/tempest/tempest.conf network public_network_id "$netid"
crudini --set /etc/tempest/tempest.conf dashboard dashboard_url "http://10.10.1.10/horizon/"
# Modify the argus.conf file