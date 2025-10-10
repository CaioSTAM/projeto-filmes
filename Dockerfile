FROM python:3.11.3-alpine3.18
LABEL mantainer="caiostam2004@gmail.com"


ENV PYTHONDONTWRITEBYTECODE 1

# Outputs do python em tempo real
ENV PYTHONUNBUFFERED 1

#Copia a pasta djangoapp e scripts para dentro do container
COPY djangoapp /djangoapp
COPY scripts /scripts

# Entra na pasta djangoapp no container
WORKDIR /djangoapp

EXPOSE 8000

RUN python -m venv /venv && \
    /venv/bin/pip install --upgrade pip && \
    /venv/bin/pip install -r /djangoapp/requirements.txt && \
    adduser --disabled-password --no-create-home duser && \
    mkdir -p /data/web/static && \
    mkdir -p /data/web/media && \
    chown -R duser:duser /venv && \
    chown -R duser:duser /data/web/static && \
    chown -R duser:duser /data/web/media && \
    chmod -R 755 /data/web/static && \
    chmod -R 755 /data/web/media && \
    chmod -R +x /scripts

#Adiciona a pasta scripts e venv/bin no $PATH do container
ENV PATH="/scripts:/venv/bin:$PATH"

#Muda o usuário para "duser"
USER duser

CMD ["commands.sh"]