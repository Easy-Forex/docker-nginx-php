FROM easymarkets/centos

# Install Remi
RUN rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm

# Enable PHP 7.2
RUN yum-config-manager --enable remi-php72

# Install PHP and tools
RUN yum -y install --setopt=tsflags=nodocs php \
    php-cli \
	&& yum clean all \
	&& rm -rf /var/cache/yum

CMD ["/bin/bash"]
