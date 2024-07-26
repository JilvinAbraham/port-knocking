# Use an official Ubuntu image as the base
FROM ubuntu:20.04

# Install necessary packages
RUN apt-get update && \
    apt-get install -y nginx knockd iptables && \
    apt-get clean

# Create a simple web page
RUN echo "Hello, Port Knocking World!" > /var/www/html/index.html

# Configure nginx to listen on port 8001
RUN sed -i 's/listen 80/listen 8001/' /etc/nginx/sites-available/default

# Add knockd configuration
COPY knockd.conf /etc/knockd.conf

# Expose the ports for the knock sequence and the web service
EXPOSE 7000 8000 9000 8001

# Start iptables rules, nginx, and knockd
# Iptable commands to block all the ports initially
CMD ["sh", "-c", "\
    iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT && \
    iptables -A INPUT -i lo -j ACCEPT && \
    iptables -A INPUT -p tcp --dport 22 -j ACCEPT && \
    iptables -P INPUT DROP && \
    knockd -d -c /etc/knockd.conf & \
    nginx -g 'daemon off;'"]
