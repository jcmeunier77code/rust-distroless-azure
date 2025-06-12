FROM rustlang/rust:nightly as builder

WORKDIR /usr/src/app

COPY . .

RUN cargo build --release

# Now copy it into our base image.
# Runtime stage with OpenSSL installed
FROM debian:bookworm-slim AS runtime

# Install OpenSSL 3 libraries
RUN apt-get update && apt-get install -y \
    libssl3 \
 && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/src/app/target/release/rust-tokenizers-api /usr/local/bin/rust-tokenizers-api
CMD ["rust-tokenizers-api"]
