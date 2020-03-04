# k0kubun/mitamae-dockcross:linux-i686
# Using x86_64 + -m32 because linux-x86 image added some more dynamic lib dependencies
FROM dockcross/linux-x64:20200119-1c10fb2

# Install multilib, ruby and rake
RUN apt-get update && apt-get install -y --no-install-recommends gcc-multilib g++-multilib ruby
