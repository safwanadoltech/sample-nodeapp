# Use an official base image (e.g., Node.js for a Node.js app)
FROM node:latest
# Set the working directory in the container
WORKDIR /app
# Copy package.json and package-lock.json to the container
COPY package*.json ./
# Install application dependencies
RUN npm install
# Copy the rest of the application source code to the container
COPY . .
# Expose a port if your application listens on one
EXPOSE 3000
# Specify the command to run your application
CMD [ "npm", "start" ]
