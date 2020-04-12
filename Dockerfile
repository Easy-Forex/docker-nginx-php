FROM easymarkets/centos

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
    php-opcache \
    php-pecl-apcu \
    php-pdo \
    php-mbstring \
    php-mcrypt \
    php-mysqlnd \
    php-pecl-memcached \
    && yum clean all \
    && rm -rf /var/cache/yum

# Make necessary dirs
RUN mkdir -p /run/php-fpm && \
    mkdir -p /run/nginx && \
    mkdir -p /var/cache/nginx && \
    mkdir -p /var/www/html

# Copy configs
COPY php/php.ini /etc/
COPY php/www.conf /etc/php-fpm.d/
COPY nginx/nginx.conf /etc/nginx/
COPY nginx/default.conf /etc/nginx/conf.d/

# Set necessary permissions
RUN chown -R nginx.nginx /run/php-fpm && \
    chown -R nginx.nginx /run/nginx && \
    chown -R nginx.nginx /var/lib/php && \
    chown -R nginx.nginx /var/lib/nginx && \
    chown -R nginx.nginx /var/log/php-fpm && \
    chown -R nginx.nginx /var/cache/nginx && \
    chown -R nginx.nginx /var/www

# Symlink logs to stdout / stderr
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

# Setup init script
COPY run.sh /opt/
RUN chmod a+x /opt/run.sh

EXPOSE 8080

USER nginx:nginx
CMD ["/opt/run.sh"]
