FROM onlyoffice/documentserver:latest

ARG TARGETPLATFORM
ENV TARGETPLATFORM=${TARGETPLATFORM}

RUN apt-get update -y && \ 
	apt-get install git -y \
			python3 -y \
			openjdk-11-jdk -y \
			bzip2 -y \
			npm -y && \
	npm install -g grunt grunt-cli -y && \
	ln -s /usr/bin/python3 /usr/bin/python && \
	ln -s /usr/bin/pip3 /usr/bin/pip && \
	git clone --depth 1 https://github.com/ONLYOFFICE/build_tools.git var/www/onlyoffice/documentserver/build_tools && \
	sed -i '/documentserver-static-gzip.sh ${ONLYOFFICE_DATA_CONTAINER}/d' /app/ds/run-document-server.sh && \
	#Set Up Debug Logging
	sed -i 's/WARN/ALL/g' /etc/onlyoffice/documentserver/log4js/production.json && \
	#Start test example
	if [ -s /etc/supervisor/conf.d/ds-example.conf ] ; then sed -i 's,autostart=false,autostart=true,' /etc/supervisor/conf.d/ds-example.conf; fi && \
	if [ -s /app/ds/setup/config/supervisor/ds/ds-example.conf ] ; then sed -i 's,autostart=false,autostart=true,' /app/ds/setup/config/supervisor/ds/ds-example.conf; fi && \
	rm -rf /var/lib/apt/lists/*
# install nodemon for monitoring and restarting node services
RUN npm i -g nodemon
# RUN curl -fSL \
# 		https://github.com/fg2it/phantomjs-on-raspberry/releases/download/v2.1.1-jessie-stretch-arm64/phantomjs_2.1.1_arm64.tgz \
# 		-o /tmp/phantomjs.tgz \
# 		&& tar -xzf /tmp/phantomjs.tgz -C /usr/local/bin
# ENV PHANTOMJS_SKIP_DOWNLOAD=true \
#     NPM_CONFIG_PHANTOMJS_SKIP_DOWNLOAD=true \
#     PHANTOMJS_BIN=/usr/local/bin/phantomjs

RUN echo "platfomr is $TARGETPLATFORM ..............."

# Conditionally download PhantomJS for ARM and write an ENV directive into a temp Dockerfile fragment
RUN if echo "$TARGETPLATFORM" | grep -qiE "arm|aarch64"; then \
      echo "ARM platform detected: $TARGETPLATFORM" && \
      curl -fSL \
        https://github.com/fg2it/phantomjs-on-raspberry/releases/download/v2.1.1-jessie-stretch-arm64/phantomjs_2.1.1_arm64.tgz \
        -o /tmp/phantomjs.tgz && \
      tar -xzf /tmp/phantomjs.tgz -C /usr/local/bin && \
      rm /tmp/phantomjs.tgz && \
      echo "ENV PHANTOMJS_SKIP_DOWNLOAD=true" >> /tmp/set_env.dockerfile; \
      echo "ENV NPM_CONFIG_PHANTOMJS_SKIP_DOWNLOAD=true" >> /tmp/set_env.dockerfile; \
      echo "ENV PHANTOMJS_BIN=/usr/local/bin/phantomjs" >> /tmp/set_env.dockerfile; \
    else \
      echo "Not ARM platform: $TARGETPLATFORM — skipping PhantomJS setup"; \
    fi

RUN cp -r /var/www/onlyoffice/documentserver/server /var/www/onlyoffice/documentserver/server-org 
COPY fix_paths.sh /app/ds/fix_paths.sh
RUN chmod +x /app/ds/fix_paths.sh

ENTRYPOINT python3 /var/www/onlyoffice/documentserver/build_tools/develop/run_build_js.py /var/www/onlyoffice/documentserver $@ && /bin/sh -c /app/ds/fix_paths.sh && /bin/sh -c /app/ds/run-document-server.sh 
