# Итоговый проект Гринатом по кейс-лабу "Облачные технологии". Вариант: 7. IaC с модульным Terraform

## Цель проекта
Автоматизировать развёртывание отказоустойчивого веб-сервиса (LB + 2 web + managed PostgreSQL + bastion + мониторинг) одной командой через модульный Terraform, с возможностью переключения между окружениями dev/prod и удалённым хранением state в S3.

## Выбранный вариант: №7
Выбран он был потому что курс, по сути, ведёт одну линию: GUI -> CLI -> IaC.

Поэтому посчитал правильным завершающий проект закончить как раз на IaC ноте, и к тому же, курс сам по себе словно ведёт так, чтобы был выбран именно этот проект.

## Архитектура

### Схема
![architecture](.github/assets/architecture.png)

### Компоненты
- **VPC + 2 подсети**: модуль `modules/network`
- **Security Groups** (`bastion`, `web`, `lb`, `db`, `monitoring`): модуль `modules/security`
- **Bastion host**: единственная точка входа по SSH, доступен только с `var.my_ip`
- **Load Balancer** (Round Robin): единственная точка входа для входящего веб-трафика 
- **2 веб-сервера** в приватной подсети, рисуются из образа Packer
- **Managed DB** в приватной подсети
- **Monitoring VM** (Prometheus + Grafana) + node_exporter на web-нодах

### Сеть
Публичный CIDR: 10.0.1.0/24
Приватный CIDR: 10.0.2.0/24

При подключении идёт цепочка: load balancer -> проверка SG -> выбор веб-сервера
Внутренняя сеть изолирована от внешнего мира посредством приватной подсети для ingress, но доступна для egress.

Веб-серверы проходят ту же цепочку, что и интернет-трафик извне, но уже в рамках приватной подсети и для того, чтобы постучаться в **Managed DB**

### Безопасность
- Bastion доступен по SSH только с `var.my_ip`
- Веб-серверы и БД в приватной подсети, недоступны напрямую из интернета
- БД принимает соединения только от SG `web`
- Секреты хранятся в окружении от GitHub (GitHub Environments)

### Мониторинг
- Prometheus на отдельной VM, скрейпит node_exporter с web-нод
- Grafana с дашбордами
- Telegram-алерты через `TF_VAR_TG_BOT_TOKEN` / `TF_VAR_TG_CHAT_ID`
- Собираемые алерты: InstanceDown, высокое использование CPU/памяти, низкое количество места на диске.

### FinOps
- Минимальные flavor (STD3-2-* и аналоги)
- `terraform destroy` после завершения работ
- Общая сумма, потраченная ДО защиты итогового проекта: ~70 рублей.

## Используемый стек
- Terraform 1.7+ (provider `vk-cs/vkcs ~> 0.15`)
- S3 backend (VK Cloud Object Storage)
- Packer (`openstack` plugin, alias `vkcs`)
- CI/CD (`ci.yml`, `destroy.yml`, `packer.yml`)
- Managed DB
- Prometheus + Grafana - мониторинг
- nginx - веб-сервер

## Порядок развёртывания

### Вариант 1: через GitHub Actions
Можно сделать fork репозитория, в settings репы создать три **GitHub Environments**: `iac`, `iac-apply`, `iac-destroy`, в каждом задать переменные:

```
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_DEFAULT_REGION
TF_VAR_CLOUD_PASSWORD
TF_VAR_DB_PASSWORD
TF_VAR_MY_IP
TF_VAR_PROJECT_ID
TF_VAR_TG_BOT_TOKEN
TF_VAR_TG_CHAT_ID
TF_VAR_USERNAME
```

На окружениях `iac-apply` и `iac-destroy` установить **Required reviewers**

Дальше при push в `main` запускается workflow **Terraform CI**, который проходит `validate -> plan -> apply` (apply ждёт ручного подтверждения).

Для уничтожения инфры - **Terraform Destroy** (`workflow_dispatch`), требует ввести строку `destroy-lab` для подтверждения.

### Вариант 2: локально
```bash
git clone git@github.com:MagM1go/vk-cloud-infra.git
cd vk-cloud-infra

# подгружаем openrc
source your-openrc-file.sh

terraform init
terraform validate

# заполняем секреты для локального запуска
cp envs/secret.tfvars.example envs/secret.tfvars

# dev
terraform plan  -out=tfplan -var-file=envs/dev.tfvars  -var-file=envs/secret.tfvars
terraform apply tfplan

# prod
terraform plan  -out=tfplan -var-file=envs/prod.tfvars -var-file=envs/secret.tfvars
terraform apply tfplan
```

## Проверка работоспособности

1. **LB работает (round-robin):**
   ```bash
   for i in (seq 5); curl -s http://<floating_ip>/ | grep Hello; end
   ```
   Должны чередоваться `Hello from web1` / `Hello from web2`.

2. **Bastion недоступен с чужого IP:**
   ```bash
   ssh -o ConnectTimeout=5 ubuntu@<bastion_ip>  # должно упасть
   ```

3. **БД не торчит наружу:**
   ```bash
   nc -vz <db_host> 5432   # из внешнего мира должно падать
   ```

4. **Метрики собираются:** открыть Grafana по `http://<monitoring_ip>:3000`

5. **Failover:** при выключении одной web-вм, вторая продолжает отвечать

## Соответствие критериям оценки

| Критерий | Вес | Чем закрыто |
|---|---|---|
| Работоспособность | 30% | Сайт открывается по LB, round-robin между web1/web2, failover работает, мониторинг показывает метрики |
| Код и автоматизация | 25% | Модульный Terraform (network/security/compute), S3 backend, Packer, GitHub Actions CI/CD с ручным gate |
| Безопасность | 20% | Bastion только с `my_ip`, БД в private, секреты в GitHub Environment Secrets и `.gitignore`, минимальные SG |
| Понимание архитектуры | 15% | Схема + защита, разделение dev/prod через tfvars |
| Документация | 10% | README.md |

## Известные ограничения
- **Trove guest-agent timeout** при `terraform destroy` managed PostgreSQL - это баг vkcs, обходится ручным удалением БД в UI + `terraform state rm`

## Чек-лист сдачи
- [x] Модульная структура
- [x] S3 backend
- [x] Одна команда для развёртывания
- [x] Два окружения (dev/prod) через разные tfvars
- [x] Безопасность (bastion, private, SG, секреты)
- [x] Работоспособность (LB, failover, мониторинг проверены)
- [x] Схема архитектуры
- [x] Документация
- [x] FinOps оценка
