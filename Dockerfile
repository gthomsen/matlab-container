FROM mathworks/matlab:r2024b

ARG USER_NAME=user

USER root

# Rename the MATLAB user.
RUN usermod -l ${USER_NAME} matlab && \
    mv /etc/sudoers.d/matlab /etc/sudoers.d/${USER_NAME} && \
    mv /home/matlab /home/${USER_NAME}

USER ${USER_NAME}
ENV HOME=/home/${USER_NAME}

WORKDIR /home/${USER_NAME}/Documents/MATLAB

# Running MATLAB directly doesn't start the VNC server.
#ENTRYPOINT ["matlab"]

# Using the upstream MATLAB container's entrypoint doesn't seem to start
# the VNC server when provided the '-vnc' option either.
#ENTRYPOINT ["tini", "--", "/bin/run.sh"]

# This lets us run 'vncserver -geometry XxY :DISPLAY'.
ENTRYPOINT ["/bin/bash", "-i"]
