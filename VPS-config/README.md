# 1 - VPS
apt update
apt install libnginx-mod-stream

root@thunboo-vps:/etc/nginx# ls -l /etc/nginx/modules-enabled/ | grep stream
lrwxrwxrwx 1 root root 50 Aug  2 23:21 50-mod-stream.conf -> /usr/share/nginx/modules-available/mod-stream.conf

# ?
docker compose up -d --force-recreate - на случай смены конфигов netbird
+ Надо переподключить саму впс:
  По заходу на дашборд - выпускаем новый ключ на авторизацию (one-shot)
  Тыкаем установить и копируем команду
  На впс запускаем netbird down и нашу команду на авторизацию

```bash
# Настроим UFW для мониторинга
/path/to/repo/VPS-config/monitoring/ufw_config.sh
```
+ надо настроить базовые новый порт для SSH, порт для HTTPS и прочее, что потребуется