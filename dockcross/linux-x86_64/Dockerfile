# k0kubun/mitamae-dockcross:linux-x86_64
# Not just using linux-x86 as is because I wanted to statically link (musl-)libc for CentOS 6.9
FROM dockcross/linux-x64:20200119-1c10fb2

# Install musl-libc, ruby and rake
RUN apt-get update && apt-get install -y --no-install-recommends \
  musl musl-dev musl-tools ruby
