FROM python:3.11

WORKDIR /workspace

# Install Poetry
RUN pip install poetry streamlit && \
    cd /usr/local/bin && \
    poetry config virtualenvs.create false

# Copy poetry.lock* in case it doesn't exist in the repo
ENV CURL_CA_BUNDLE ""
COPY ./ /workspace

ENV PYTHONPATH=/workspace

COPY daemon.json /etc/docker/daemon.json

ARG INSTALL_DEV='true'
RUN poetry config experimental.new-installer false && poetry config virtualenvs.create true --local
RUN sh -c "if [ $INSTALL_DEV == 'true' ] ; then python3 -m poetry install ; else python3 -m poetry install --no-root --no-dev ; fi"

ENTRYPOINT ["tail", "-f", "/dev/null"]