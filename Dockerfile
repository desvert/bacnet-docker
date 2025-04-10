FROM ubuntu:18.04

# Install required packages
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Download and extract BACnet stack
RUN wget -O bacnet-stack-1.4.0.tgz https://downloads.sourceforge.net/project/bacnet/bacnet-stack/bacnet-stack-1.4.0/bacnet-stack-1.4.0.tgz \
    && tar zxf bacnet-stack-1.4.0.tgz \
    && cd bacnet-stack-1.4.0 \
    && make \
    && rm -f bin/*.txt bin/*.bat \
    && mv bin/* /usr/local/bin \
    && cd / \
    && rm -rf bacnet-stack*

# Copy your wrapper and simulator into the image
COPY bacnet-wrapper /
COPY simulator /
RUN chmod +x /bacnet-wrapper

# Clean up
RUN apt-get remove -y build-essential && apt-get autoremove -y && apt-get autoclean -y

# Expose BACnet default UDP port
EXPOSE 47808/udp

CMD ["/bacnet-wrapper"]
