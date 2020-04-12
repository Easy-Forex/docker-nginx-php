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

# Copy configs
COPY php/php.ini /etc/
COPY php/www.conf /etc/php-fpm.d/
COPY nginx/nginx.conf /etc/nginx/
COPY nginx/default.conf /etc/nginx/conf.d/

CMD ["/bin/bash"]
