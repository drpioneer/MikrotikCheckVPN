# MikrotikCheckVPN - скрипт проверки и перезапуска зависших клиентских VPN-интерфейсов.

Скрипт необходимо залить на удалённые Микротики, которые стучатся по VPN на центральный.
В переменной "nameVPN" хранится шаблон названий VPN-интерфейсов, которые подлежат проверке.
Из особенностей работы скрипта можно выделить автоматическое включение VPN-интерфейса, если по какой-то причине он оказался выключенным.
