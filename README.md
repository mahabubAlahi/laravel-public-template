# Laravel Project Template
Laravel Project Template using mysql, redis, docker, nginx.

## Setup
```bash
# Environment Variable
cp .env.example .env
nano .env
```

### ***Local Development***:
1. Run the Docker Compose Dev File
   * `docker-compose -f docker-compose-dev.yml up -d`
2. Next, generate the Laravel application key and clear the cache configuration.
   * `docker-compose exec test_dev_auth_app php artisan key:generate`
   * `docker-compose exec test_dev_auth_app php artisan config:cache`
3. After that, migrate the database using the following command.
   * `docker-compose exec test_dev_auth_app php artisan migrate`
