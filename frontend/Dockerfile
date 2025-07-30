# frontend/Dockerfile
FROM node:18

WORKDIR /app

# Copy everything (or just package.json + lock first for caching)
COPY package*.json ./

# Install all dependencies
RUN npm install

# Copy the rest of the project
COPY . .

# Start dev server
CMD ["npm", "start"]
