# Шаблон для получения данных S.M.A.R.T. SATA-дисков
## Что умеет
Простенький скрипт, умеет получать: 
1. Производителя диска
2. Модель диска
3. Номер прошивки
4. Серийный номер
5. Размер диска
6. Показатели S.M.A.R.T.

## Установка
1. Скопировать скрипт smart.ps1 в папку C:\Zabbix\script
2. Добавить в zabbix_agentd.conf строку:
```
UserParameter=ZSmart[*],powershell -File C:\Zabbix\script\smart.ps1 "$1" "$2"
```
3. Импортировать шаблон в Zabbix
