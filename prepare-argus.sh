 cd ~/
git clone https://github.com/openstack/tempest.git
cd tempest
git checkout 11.0.0 # change version for mitaka and argus
# activate argus virtualenv
source ~/cloudbase-init-ci/.venv/argus/bin/activate # this may differ
pip install ~/tempest 
# Install the dependecies under the virtualenv
pip install -r ~/tempest/requirements.txt
pip install -r ~/tempest/test-requirements.tx
