#!/bin/sh

# запускаем агент в фоне
eval "$(ssh-agent -s)"

# добавляем секретный ключ
ssh-add ~/.ssh/xcode

echo Теперь можешь пушить

# не забудь выполнить chmod 755 git-ssh.sh
# запуск: ./git-ssh.sh
