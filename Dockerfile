FROM ubuntu:18.04
RUN ln -snf /usr/share/zoneinfo/Hongkong /etc/localtime && echo Hongkong > /etc/timezone

RUN apt-get update \
    && apt-get install -y software-properties-common \
    && apt-add-repository -y ppa:nginx/stable \
    && LC_ALL=C.UTF-8 apt-add-repository -y ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y nginx php7.4 php7.4-fpm php7.4-cli php7.4-common \
    php7.4-bcmath php7.4-curl php7.4-dev php7.4-gd php7.4-iconv php7.4-intl php7.4-json php7.4-mbstring php7.4-mysql php7.4-mysqlnd \
    php7.4-opcache php7.4-pdo php7.4-soap php7.4-xml php7.4-zip php7.4-xdebug \
    && apt-get -y install --no-install-recommends --fix-missing \
 #   && apt-get -y install msmtp mailutils \
    git vim dialog mariadb-client libcurl4 curl gcc make htop \
    libmcrypt-dev libsqlite3-dev libsqlite3-0 \
    zlib1g-dev libicu-dev libfreetype6-dev libpng-dev \
    ruby-dev libxml2-dev cron apache2-utils golang-go awscli\
    && rm -rf /var/lib/apt/lists/*

RUN apt-get -y install git vim 

#install composer
RUN curl -s https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/local/bin --version=1.10.15

RUN git clone -b dockerfile https://github.com/dwlpm/appcode.git
WORKDIR appcode
RUN composer install
COPY ./index.php index.php
CMD [ "php", "-S", "0:80" ]