FROM easymarkets/centos:latest

# Install Remi
RUN rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm

# Enable PHP 7.2
RUN yum-config-manager --enable remi-php72

# Install PHP and tools
RUN yum -y install --setopt=tsflags=nodocs curl \
    libcurl \
    nginx \
    php-fpm \
    php-common \
    php-cli \
    php-xml \
    php-json \
    php-intl \
    php-opcache \
    php-pecl-apcu \
    php-pdo \
    php-mbstring \
    php-mcrypt \
    php-mysqlnd \
    php-pecl-memcached \
    && yum clean all \
    && rm -rf /var/cache/yum

# Make dirs and set permissions
RUN mkdir -p /run/php-fpm && \
    mkdir -p /run/nginx && \
    mkdir -p /var/cache/nginx && \
    chown -R nginx.nginx /run/php-fpm && \
    chown -R nginx.nginx /run/nginx && \
    chown -R nginx.nginx /var/lib/php && \
    chown -R nginx.nginx /var/lib/nginx && \
    chown -R nginx.nginx /var/log/php-fpm && \
    chown -R nginx.nginx /var/cache/nginx

# Symlink logs to stdout / stderr
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

# Copy init script
COPY run.sh /opt/
RUN chmod a+x /opt/run.sh

# Copy configs
COPY php/php.ini /etc/
COPY php/www.conf /etc/php-fpm.d/
COPY nginx/nginx.conf /etc/nginx/
COPY nginx/default.conf /etc/nginx/conf.d/

# Set ENV variables
ENV NGINX_DEFAULT_ROOT=/var/www/html

# Make working dir and set permissions
RUN mkdir -p ${NGINX_DEFAULT_ROOT} && \
    chown -R nginx.nginx ${NGINX_DEFAULT_ROOT}

# Expose port
EXPOSE 8080

# Run init script
CMD ["/opt/run.sh"]
