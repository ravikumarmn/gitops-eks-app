# Stage 1: Dependencies
FROM node:18-alpine AS deps
WORKDIR /app
COPY package.json .
RUN npm install --omit=dev

# Stage 2: Final image
FROM node:18-alpine
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY app.js package.json .
ENV NODE_ENV=production
EXPOSE 3000
USER node
CMD ["node", "app.js"]
