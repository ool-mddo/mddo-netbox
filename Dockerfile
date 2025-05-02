FROM netboxcommunity/netbox:v4.2-3.1.1
RUN pip3 install netbox-bgp
#COPY ./configuration.py /etc/netbox/config/configuration.py
RUN sed -i 's/# PLUGINS = \[\]/PLUGINS = ["netbox_bgp"]/' /etc/netbox/config/configuration.py
ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/opt/netbox/docker-entrypoint.sh", "/opt/netbox/launch-netbox.sh" ]
