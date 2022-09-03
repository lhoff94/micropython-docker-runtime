# Builder Container
FROM debian:stable-slim AS builder
# Install all Build dependecies
RUN apt-get update && apt-get -y install build-essential libffi-dev pkg-config python3 python3-setuptools python3-dev git
WORKDIR /tmp
# Clone MicroPython sources
RUN git clone https://github.com/micropython/micropython.git
WORKDIR /tmp/micropython
# Checkout Tag of the version that should be build
RUN git checkout v1.19.1
# Switch to folder containing the make files for the UNIX port
WORKDIR /tmp/micropython/ports/unix
RUN make submodules
RUN make 

# Final Container
FROM debian:stable-slim
WORKDIR /root/
# Copy executable from Builder container
COPY --from=builder /tmp/micropython/ports/unix/micropython /usr/local/bin

