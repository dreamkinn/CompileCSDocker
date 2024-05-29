FROM mono:latest

RUN apt-get update && apt-get install -y git

# Create volume that allows to share data between host and container
VOLUME /data

# Copy the script from your host to the container
COPY entrypoint.sh /entrypoint.sh
COPY tools.txt /tools.txt

# Make the script executable
RUN chmod +x /entrypoint.sh

# Set the script as the entrypoint of the container
ENTRYPOINT ["/entrypoint.sh"]