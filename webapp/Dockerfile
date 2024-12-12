# Stage 1: Build Stage
FROM node:20-alpine AS build

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Production Stage
FROM node:20-alpine

# Create a non-root user and group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app
COPY package.json ./
RUN npm install --production

# Copy built application from the build stage
COPY --from=build /app/.next ./.next
COPY --from=build /app/public ./public
COPY --from=build /app/package.json ./package.json

# Change ownership of the files to the non-root user
RUN chown -R appuser:appgroup /app

# Switch to the non-root user
USER appuser

# Expose the default Next.js port
EXPOSE 9000

# Start the application
CMD ["npm", "start"]
