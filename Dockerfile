
FROM netboxcommunity/netbox:v4.3.4-3.3.0 AS builder

COPY --from=ghcr.io/astral-sh/uv:0.7 /uv /usr/local/bin/
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update -qq \
    && apt-get upgrade \
      --yes -qq --no-install-recommends \
    && apt-get install \
      --yes -qq --no-install-recommends \
      build-essential \
      ca-certificates \
      libldap-dev \
      libpq-dev \
      libsasl2-dev \
      libssl-dev \
      libxml2-dev \
      libxmlsec1 \
      libxmlsec1-dev \
      libxmlsec1-openssl \
      libxslt-dev \
      pkg-config \
      python3-dev \
    && /usr/local/bin/uv venv /opt/netbox/venv

RUN  /usr/local/bin/uv pip install netbox-bgp \
     netbox-topology-views \
     netboxlabs-netbox-custom-objects \
     netboxlabs-netbox-branching

ARG NETBOX_PATH
ENV VIRTUAL_ENV=/opt/netbox/venv


FROM netboxcommunity/netbox:v4.3.4-3.3.0 AS main

COPY --from=builder /usr/local/bin/uv /usr/local/bin/
COPY --from=builder /opt/netbox/venv /opt/netbox/venv

WORKDIR /opt/netbox/netbox


ENV LANG=C.utf8 PATH=/opt/netbox/venv/bin:$PATH VIRTUAL_ENV=/opt/netbox/venv UV_NO_CACHE=1
ENTRYPOINT [ "/usr/bin/tini", "--" ]

CMD [ "/opt/netbox/docker-entrypoint.sh", "/opt/netbox/launch-netbox.sh" ]

LABEL netbox.original-tag="" \
      netbox.git-branch="" \
      netbox.git-ref="" \
      netbox.git-url="" \
# See https://github.com/opencontainers/image-spec/blob/master/annotations.md#pre-defined-annotation-keys
      org.opencontainers.image.created="" \
      org.opencontainers.image.title="NetBox Docker" \
      org.opencontainers.image.description="A container based distribution of NetBox, the free and open IPAM and DCIM solution." \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.authors="The netbox-docker contributors." \
      org.opencontainers.image.vendor="The netbox-docker contributors." \
      org.opencontainers.image.url="https://github.com/netbox-community/netbox-docker" \
      org.opencontainers.image.documentation="https://github.com/netbox-community/netbox-docker/wiki" \
      org.opencontainers.image.source="https://github.com/netbox-community/netbox-docker.git" \
      org.opencontainers.image.revision="" \
      org.opencontainers.image.version=""
                                                   

COPY ./configuration.py /etc/netbox/config/configuration.py
RUN cat /etc/netbox/config/configuration.py | grep PLUG
ENV LANG=C.utf8 PATH=/opt/netbox/venv/bin:$PATH VIRTUAL_ENV=/opt/netbox/venv UV_NO_CACHE=1
ENTRYPOINT [ "/usr/bin/tini", "--" ]

CMD [ "/opt/netbox/docker-entrypoint.sh", "/opt/netbox/launch-netbox.sh" ]
