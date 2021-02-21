FROM python:3.8

RUN apt-get update && apt-get install -y --fix-missing curl unzip gnupg2

# Install Google Chrome
RUN curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    apt-get -yqq update && \
    apt-get -yqq install google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*

#Configuring the tests to run in the container
RUN mkdir /app
WORKDIR /app

ADD requirements.txt /app/requirements.txt
ADD behave.ini /app/behave.ini
RUN pip3 install -r requirements.txt

ADD features /app/features

ADD behave-command-parallel.sh /app/behave-command-parallel.sh
RUN chmod a+x /app/behave-command-parallel.sh

CMD bash behave-command-parallel.sh