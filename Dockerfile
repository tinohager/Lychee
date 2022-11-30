FROM debian:bookworm-slim

# Set version label
LABEL maintainer="lycheeorg"

# Environment variables
ENV PHP_TZ=UTC

# Install base dependencies, add user and group, clone the repo and install php libraries
RUN \
    set -ev && \
    apt-get update && \
    apt-get upgrade -qy && \
    apt-get install -qy --no-install-recommends\
    adduser \
    php8.1-cli \
    php8.1-mysql \
    php8.1-pgsql \
    php8.1-sqlite3 \
    php8.1-imagick \
    php8.1-mbstring \
    php8.1-gd \
    php8.1-xml \
    php8.1-zip \
    php8.1-fpm \
    php8.1-redis \
    php8.1-bcmath \
    php8.1-intl \
    curl \
    libimage-exiftool-perl \
    ffmpeg \
    git \
    jpegoptim \
    optipng \
    pngquant \
    gifsicle \
    webp \
    cron \
    composer \
    unzip

WORKDIR src/

COPY composer.json .
COPY composer.lock .

RUN composer install --no-scripts --no-autoloader

COPY . .

RUN composer dump-autoload --optimize && \
	composer run-script post-install-cmd

run ./artisan migrate

run ./vendor/bin/phpunit --verbose --stop-on-failure
# RUN \
#     cd /var/www/html && \
#     if [ "$TARGET" = "release" ] ; then RELEASE_TAG="-b v$(curl -s https://raw.githubusercontent.com/LycheeOrg/Lychee/master/version.md)" ; fi && \
#     git clone --depth 1 $RELEASE_TAG https://github.com/LycheeOrg/Lychee.git && \
#     mv Lychee/.git/refs/heads/master Lychee/master || cp Lychee/.git/HEAD Lychee/master && \
#     mv Lychee/.git/HEAD Lychee/HEAD && \
#     rm -r Lychee/.git/* && \
#     mkdir -p Lychee/.git/refs/heads && \
#     mv Lychee/HEAD Lychee/.git/HEAD && \
#     mv Lychee/master Lychee/.git/refs/heads/master && \
#     echo "$TARGET" > /var/www/html/Lychee/docker_target && \
#     cd /var/www/html/Lychee && \
#     echo "Last release: $(cat version.md)" && \
#     composer install --no-dev --prefer-dist && \
#     find . -wholename '*/[Tt]ests/*' -delete && \
#     find . -wholename '*/[Tt]est/*' -delete && \
#     rm -r storage/framework/cache/data/* 2> /dev/null || true && \
#     rm    storage/framework/sessions/* 2> /dev/null || true && \
#     rm    storage/framework/views/* 2> /dev/null || true && \
#     rm    storage/logs/* 2> /dev/null || true && \
#     chown -R www-data:www-data /var/www/html/Lychee && \
#     echo "* * * * * www-data cd /var/www/html/Lychee && php artisan schedule:run >> /dev/null 2>&1" >> /etc/crontab && \
#     apt-get purge -y --autoremove git composer && \
#     apt-get clean -qy &&\
#     rm -rf /var/lib/apt/lists/*