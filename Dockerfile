FROM php:8.1.0-fpm

# Arguments defined in docker-compose.yml
ARG user
ARG uid

# Copy composer.lock and composer.json
COPY composer.lock composer.json /var/www/html/

# Set working directory
WORKDIR /var/www/html/

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    libzip-dev \
    libpng-dev \
    libxpm-dev \
    libonig-dev \
    libxml2-dev \
    libwebp-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev\
    jpegoptim optipng pngquant gifsicle \
    locales \
    nano \
    vim \
    zip \
    unzip

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-configure gd \    
    --with-jpeg \  
    --with-freetype

RUN docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd

# Redis
RUN pecl install redis && docker-php-ext-enable redis

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Add user for laravel application
RUN groupadd -g $uid $user
RUN useradd -u $uid -ms /bin/bash -g $user $user

# Copy existing application directory contents to the working directory
COPY . /var/www/html

# Copy existing application directory permissions
COPY --chown=$user:$user . /var/www/html

USER $user

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]

