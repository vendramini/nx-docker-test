FROM node:alpine3.19

# Set working directory
WORKDIR /usr/app

# Install PM2 globally
RUN npm install --global nx@19.8.4 pm2

# Copy package.json and package-lock.json before other files
# Utilise Docker cache to save re-installing dependencies if unchanged
COPY ./package*.json ./

# Install dependencies
RUN npm install --force

# Copy all files
COPY ./ ./

#ENV NX_DAEMON=false
#ENV NX_SKIP_NX_CACHE=true
#ENV NX_CACHE_PROJECT_GRAPH=false

# Build app
RUN nx build docker-test --verbose

# Expose the listening port
EXPOSE 3000

# Run container as non-root (unprivileged) user
# The node user is provided in the Node.js Alpine base image
USER node

# Run npm start script with PM2 when container starts
CMD [ "pm2-runtime", "nx", "--", "start", "docker-test" ]
