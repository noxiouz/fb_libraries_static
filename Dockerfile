FROM centos:7

RUN yum install gcc-c++ git centos-release-scl yum install epel-release curl -y

RUN yum install cmake3 devtoolset-9 -y
RUN yum -y install zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Set the default shell to zsh instead of sh
ENV SHELL /bin/zsh