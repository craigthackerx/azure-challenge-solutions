FROM docker.io/python:3.9

ENV NORMAL_USER python

RUN useradd -m -s /bin/bash ${NORMAL_USER} && \
      apt-get update -y && \
        apt-get upgrade -y && \
          apt-get clean

USER ${NORMAL_USER}

ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/${NORMAL_USER}/.local/bin:${PATH}"

WORKDIR /home/${NORMAL_USER}

RUN mkdir -p /home/${NORMAL_USER}/app

WORKDIR /home/${NORMAL_USER}/app

COPY requirements.txt .

RUN python3 -m pip install --upgrade pip && \
      pip install --no-cache-dir -r requirements.txt

COPY main.py .

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "2021"]