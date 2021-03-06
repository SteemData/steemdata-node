# -*- coding: utf-8 -*-

FROM teego/steem-devel:0.3-Ubuntu-xenial

MAINTAINER Aleksandr Zykov <tiger@mano.email>

ENV BUILDBASE /r
ENV BUILDROOT $BUILDBASE/build
ENV FILESROOT $BUILDBASE/files

RUN mkdir -p $BUILDROOT $FILESROOT

ENV STEEM_VERSION 0.18.1
ENV STEEM_RELEASE v$STEEM_VERSION

RUN cd $BUILDROOT && \
    ( \
        git clone https://github.com/steemit/steem.git steem &&\
        cd steem ;\
        ( \
            git checkout $STEEM_RELEASE &&\
            git submodule update --init --recursive &&\
            cmake \
                -DCMAKE_BUILD_TYPE=Release \
                -DCMAKE_INSTALL_PREFIX=/usr/local \
                CMakeLists.txt &&\
            make -j 8 install \
        ) \
    ) &&\
    ( \
        rm -Rf $BUILDROOT/steem \
    )

RUN mkdir -p /witness_node_data_dir &&\
    touch /witness_node_data_dir/.default_dir

ADD node.config.ini /witness_node_data_dir/config.ini


ENV STEEMD_EXEC="/usr/local/bin/steemd"
ENV STEEMD_ARGS="--p2p-endpoint=0.0.0.0:2001 --rpc-endpoint=0.0.0.0:8090 --replay-blockchain"

ADD run-steemd.sh /usr/local/bin
RUN chmod +x /usr/local/bin/run-steemd.sh

EXPOSE 2001 8090 8092

VOLUME ["/witness_node_data_dir"]

CMD ["/usr/local/bin/run-steemd.sh"]
