# Use the official ROS image as the base image
FROM nvidia/cuda:12.5.1-runtime-ubuntu22.04

# Set shell for running commands
SHELL ["/bin/bash", "-c"]

# install bootstrap tools
RUN apt-get update  && apt update && apt-get install --no-install-recommends -y \
    build-essential \
    git \
    zsh \
    wget \
    python3-pip \
    tmux \
    neovim \
    && rm -rf /var/lib/apt/lists/*

RUN echo "yes" | pip3 install scipy

RUN chsh -s $(which zsh)

RUN sudo apt install software-properties-common

RUN sudo add-apt-repository universe

RUN sudo apt update && sudo apt install curl

RUN sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

RUN sudo apt update

RUN sudo apt upgrade

RUN sudo apt install ros-galactic-desktop

RUN rm -rf /var/lib/apt/lists/*

RUN sudo mkdir -p -m 755 /etc/apt/keyrings && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y

RUN rm -rf /var/lib/apt/lists/*

RUN echo "cd /ros2_ws/" >> ~/.zshrc
RUN echo "source /opt/ros/galactic/setup.zsh" >> ~/.zshrc

# Set the entrypoint to source ROS setup.zsh and run a z shell instance
CMD ["/bin/zsh"]
