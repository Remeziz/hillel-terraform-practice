# Расширяем базовый образ Gitpod
FROM gitpod/workspace-full

# Устанавливаем Terraform через официальный репозиторий HashiCorp
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor > hashicorp.gpg \
  && install -o root -g root -m 644 hashicorp.gpg /usr/share/keyrings/ \
  && rm -f hashicorp.gpg \
  && echo "deb [signed-by=/usr/share/keyrings/hashicorp.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list \
  && apt-get update \
  && apt-get install -y terraform
