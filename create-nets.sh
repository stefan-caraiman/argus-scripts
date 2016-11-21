neutron net-create public --router:external True --shared
neutron subnet-create public --gateway 172.18.10.1 172.18.10.0/24 --disable-dhcp
neutron router-create router
neutron router-gateway-set router public

