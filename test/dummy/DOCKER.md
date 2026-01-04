# Docker Setup for Jinda Application

This document explains the Docker configuration files and how to use them for development and deployment.

## Docker Files Overview

Your Jinda application includes several Docker configuration files:

### 1. `Dockerfile`
- **Purpose**: Builds the Rails application container
- **Usage**: Used with `docker-compose-web.yml` for full stack deployment
- **What it does**: 
  - Sets up Ruby 3.3.0 environment
  - Installs dependencies from Gemfile
  - Copies entire application
  - Configures Rails server on port 3000

### 2. `docker-compose-mongodb.yml` (Recommended for Development)
- **Purpose**: MongoDB only on standard port
- **Best for**: Local development, CI/CD testing
- **Port**: 27017 (standard MongoDB port)
- **Usage**:
  ```bash
  docker compose -f docker-compose-mongodb.yml up -d
  ```
- **Why use this**: 
  - Minimal setup
  - Run Rails app locally with `rails server`
  - Works with standard MongoDB tools
  - No volume mount configuration needed

### 3. `docker-compose.yml`
- **Purpose**: Simple MongoDB container
- **Port**: 27017 (standard MongoDB port)
- **Usage**:
  ```bash
  docker compose up -d
  ```

### 4. `docker-compose-web.yml`
- **Purpose**: Full stack with web app and MongoDB in containers
- **Best for**: Production-like environment, full containerized development
- **Ports**: 
  - Rails: 3000
  - MongoDB: 27017
- **Important**: Edit this file before using for development with local gem modifications
- **Usage**:
  ```bash
  docker compose -f docker-compose-web.yml up -d
  ```

## Getting Started

### Option A: MongoDB Only (Recommended)

This is the simplest approach for development:

1. **Start MongoDB**:
   ```bash
   docker compose -f docker-compose-mongodb.yml up -d
   ```

2. **Verify MongoDB is running**:
   ```bash
   docker ps
   ```

3. **Run your Rails app locally**:
   ```bash
   bundle install
   rails jinda:seed
   rails server
   ```

4. **Stop MongoDB when done**:
   ```bash
   docker compose -f docker-compose-mongodb.yml down
   ```

### Option B: Full Stack (Web + MongoDB)

Use this for containerized development or testing:

1. **Edit `docker-compose-web.yml`** (optional, for local gem development):
   ```yaml
   services:
     web:
       volumes:
         - .:/myapp
         # Add your local gem paths:
         - ~/mygem/jinda:/path/to/local/jinda
         - ~/mygem/jinda_adminlte:/path/to/local/jinda_adminlte
   ```

2. **Start full stack**:
   ```bash
   docker compose -f docker-compose-web.yml up -d
   ```

3. **View logs**:
   ```bash
   docker compose -f docker-compose-web.yml logs -f web
   ```

4. **Access application**:
   - Web: http://localhost:3000
   - MongoDB: localhost:27017

5. **Stop services**:
   ```bash
   docker compose -f docker-compose-web.yml down
   ```

## MongoDB Port Information

All Docker configurations use the **standard MongoDB port 27017**:
- Consistent with MongoDB defaults
- Works with standard MongoDB clients
- Compatible with CI/CD systems
- No special configuration needed in mongoid.yml

## For CI/CD

Your CI pipeline should use `docker-compose-mongodb.yml`:

```yaml
# GitHub Actions example
services:
  mongodb:
    image: mongo:latest
    ports:
      - 27017:27017
```

Then run tests with:
```bash
MONGODB_PORT=27017 rake test
```

## Troubleshooting

### Port Already in Use
If port 27017 is already in use:
```bash
# Check what's using the port
lsof -i :27017

# If it's an old container
docker ps -a | grep mongo
docker stop <container_name>
docker rm <container_name>
```

### Cannot Connect to MongoDB
1. Verify MongoDB is running:
   ```bash
   docker ps | grep mongo
   ```

2. Check logs:
   ```bash
   docker logs <container_name>
   ```

3. Test connection:
   ```bash
   mongosh mongodb://localhost:27017
   ```

### Volume Data Persistence
To remove all data and start fresh:
```bash
docker compose -f docker-compose-mongodb.yml down -v
```

## Best Practices

1. **Development**: Use `docker-compose-mongodb.yml` and run Rails locally
2. **Testing**: Use MongoDB-only containers with standard port 27017
3. **Production**: Use appropriate production Docker configurations (not these dev files)
4. **Local Gem Development**: Edit `docker-compose-web.yml` volume mounts as needed
5. **CI/CD**: Always use standard port 27017 for consistency

## Additional Resources

- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [MongoDB Docker Hub](https://hub.docker.com/_/mongo)
- [Jinda Documentation](https://github.com/kul1/jinda)
