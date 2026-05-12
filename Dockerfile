FROM node:20-alpine AS build
WORKDIR /opt/server
COPY package.json .
COPY . .
# this may add extra cache memory
RUN npm install 


FROM node:20-alpine
# Create a group and user
WORKDIR /opt/server
RUN addgroup -S expense && adduser -S expense -G expense && \
    chown -R expense:expense /opt/server
EXPOSE 8080
LABEL com.project="expense" \
      component="backend" \
      created_by="vignesh"
ENV DB_HOST="mysql"  
 
    # note here mongodb is contanier name docker resolve to its container IP
# copying the build installtion's from above image to here so tht image size willl reduce  
#after copying all files to /opt/server onership need to change to user inside conatiner tht we created (expense user)   
COPY --from=build --chown=expense:expense  /opt/server /opt/server  

USER expense
CMD ["index.js"]
ENTRYPOINT ["node"]