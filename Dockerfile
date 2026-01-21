FROM odoo:17.0

USER root

# Instalar dependências adicionais para localização brasileira
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-pip \
    python3-dev \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    libjpeg-dev \
    libfreetype6-dev \
    liblcms2-dev \
    libtiff-dev \
    libharfbuzz0b \
    libwebp7 \
    git \
    wkhtmltopdf \
    xfonts-75dpi \
    xfonts-base \
    xfonts-encodings \
    xfonts-utils \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip e instalar pacotes Python adicionais
RUN pip install --upgrade pip setuptools wheel && \
    pip install \
    phonenumbers \
    unidecode \
    pytz \
    requests \
    lxml \
    pillow \
    num2words \
    && rm -rf ~/.cache/pip/*

# Copiar configuração padrão
COPY ./odoo.conf /etc/odoo/odoo.conf

# Criar diretórios necessários e dar permissões
RUN mkdir -p /mnt/extra-addons /etc/odoo /var/lib/odoo && \
    chown -R odoo:odoo /mnt/extra-addons /etc/odoo /var/lib/odoo && \
    chmod -R 755 /mnt/extra-addons

USER odoo

WORKDIR /home/odoo

EXPOSE 8069 8072
