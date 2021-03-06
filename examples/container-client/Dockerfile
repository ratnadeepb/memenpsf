# A two stage build
FROM rust:1.50 AS build

WORKDIR /usr/src
RUN rustup target add x86_64-unknown-linux-musl

RUN USER=root cargo new async_client

# Build the dependencies
WORKDIR /usr/src/fdpass-rs
COPY ../../fdpass-rs/Cargo.lock ../../fdpass-rs/Cargo.toml ./
COPY ../../fdpass-rs/src/ ./src/
RUN cargo build

WORKDIR /usr/src/ipc-queue
COPY ../../ipc-queue/Cargo.lock ../../ipc-queue/Cargo.toml ./
COPY ../../ipc-queue/src ./src
RUN cargo build

WORKDIR /usr/src/memenpsf
COPY ../../memenpsf/Cargo.lock ../../memenpsf/Cargo.toml ./
COPY ../../memenpsf/src ./src
RUN cargo build

# Build the app
WORKDIR /usr/src/async_client

COPY ../ipc-client/Cargo.lock ../ipc-client/Cargo.toml ./
COPY ../ipc-client/src/ ./src/

RUN cargo install --target x86_64-unknown-linux-musl --path .

# Copy the statically-linked binary into a scratch container
FROM scratch
COPY --from=build /usr/local/cargo/bin/ipc-client .
USER 1000

CMD ["./ipc-client"]