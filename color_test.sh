#!/bin/sh
# echo подсветка
# echo color
# Скрипт выводит на экран список меню

clear    # Очистка экрана

#Памятка, Таблица цветов и фонов
#Цвет           код       код фона

#black    30  40    \033[30m  \033[40m
#red      31  41    \033[31m  \033[41m
#green    32  42    \033[32m  \033[42m
#yellow    33  43    \033[33m  \033[43m
#blue    34  44    \033[34m  \033[44m
#magenta    35  45    \033[35m  \033[45m
#cyan    36  46    \033[36m  \033[46m
#white    37  47    \033[37m  \033[47m

# Дополнительные свойства для текта:
BOLD='\033[1m'       #  ${BOLD}      # жирный шрифт (интенсивный цвет)
DBOLD='\033[2m'      #  ${DBOLD}    # полу яркий цвет (тёмно-серый, независимо от цвета)
NBOLD='\033[22m'      #  ${NBOLD}    # установить нормальную интенсивность
UNDERLINE='\033[4m'     #  ${UNDERLINE}  # подчеркивание
NUNDERLINE='\033[4m'     #  ${NUNDERLINE}  # отменить подчеркивание
BLINK='\033[5m'       #  ${BLINK}    # мигающий
NBLINK='\033[5m'       #  ${NBLINK}    # отменить мигание
INVERSE='\033[7m'     #  ${INVERSE}    # реверсия (знаки приобретают цвет фона, а фон -- цвет знаков)
NINVERSE='\033[7m'     #  ${NINVERSE}    # отменить реверсию
BREAK='\033[m'       #  ${BREAK}    # все атрибуты по умолчанию
NORMAL='\033[0m'      #  ${NORMAL}    # все атрибуты по умолчанию

# Цвет текста:
BLACK='\033[0;30m'     #  ${BLACK}    # чёрный цвет знаков
RED='\033[0;31m'       #  ${RED}      # красный цвет знаков
GREEN='\033[0;32m'     #  ${GREEN}    # зелёный цвет знаков
YELLOW='\033[0;33m'     #  ${YELLOW}    # желтый цвет знаков
BLUE='\033[0;34m'       #  ${BLUE}      # синий цвет знаков
MAGENTA='\033[0;35m'     #  ${MAGENTA}    # фиолетовый цвет знаков
CYAN='\033[0;36m'       #  ${CYAN}      # цвет морской волны знаков
GRAY='\033[0;37m'       #  ${GRAY}      # серый цвет знаков

# Цветом текста (жирным) (bold) :
DEF='\033[0;39m'       #  ${DEF}
DGRAY='\033[1;30m'     #  ${DGRAY}
LRED='\033[1;31m'       #  ${LRED}
LGREEN='\033[1;32m'     #  ${LGREEN}
LYELLOW='\033[1;33m'     #  ${LYELLOW}
LBLUE='\033[1;34m'     #  ${LBLUE}
LMAGENTA='\033[1;35m'   #  ${LMAGENTA}
LCYAN='\033[1;36m'     #  ${LCYAN}
WHITE='\033[1;37m'     #  ${WHITE}

# Цвет фона
BGBLACK='\033[40m'     #  ${BGBLACK}
BGRED='\033[41m'       #  ${BGRED}
BGGREEN='\033[42m'     #  ${BGGREEN}
BGBROWN='\033[43m'     #  ${BGBROWN}
BGBLUE='\033[44m'     #  ${BGBLUE}
BGMAGENTA='\033[45m'     #  ${BGMAGENTA}
BGCYAN='\033[46m'     #  ${BGCYAN}
BGGRAY='\033[47m'     #  ${BGGRAY}
BGDEF='\033[49m'      #  ${BGDEF}

tput sgr0     # Возврат цвета в "нормальное" состояние

#Начало меню
echo ""
echo -n "     "
echo -e "${BOLD}${BGMAGENTA}${LGREEN} Меню DNS323 ${NORMAL}"
echo ""
echo -en "${LYELLOW} 1 ${LGREEN} Комманды для удобной работы в telnet ${GRAY}(Выполнить?)${NORMAL}\n"
echo ""
echo -en "${LYELLOW} 2 ${LGREEN} Пути к папкам & Изменение прав доступа ${GRAY}(Комманды)${NORMAL}\n"
echo ""
echo -en "${LYELLOW} 3 ${LGREEN} Transmission (${GREEN}Start${NORMAL}, ${LRED}Stop${NORMAL}, ${CYAN}Upgrade${NORMAL}) ${GRAY}(Меню)${NORMAL}\n"
echo ""
echo -en "${LYELLOW} 4 ${LGREEN} Копирование (cp & rsync) ${GRAY}(Комманды)${NORMAL}\n"
echo ""
echo -en "${LYELLOW} 5 ${LGREEN} Создание ссылки на файл или папку ${GRAY}(Комманды)${NORMAL}\n"
echo ""
echo -en "${LYELLOW} 6 ${LGREEN} Установка из fun-plug & IPKG ${GRAY}(Комманды)${NORMAL}\n"
echo ""
echo -en "${LYELLOW} 7 ${LGREEN} Показать Трафик (${LYELLOW} n${LGREEN}load) ${GRAY}(Выполнить?)${NORMAL}\n"
echo ""
echo -en "${LYELLOW} 8 ${LGREEN} Диспетчер задач (${LYELLOW} h${LGREEN}top) ${GRAY}(Выполнить?)${NORMAL}\n"
echo ""
echo -en "${LYELLOW} 9 ${LGREEN} Midnight Commander (${LYELLOW} m${LGREEN}c) ${GRAY}(Выполнить?)${NORMAL}\n"
echo ""
echo -en "${LMAGENTA} q ${LGREEN} Выход ${NORMAL}\n"
echo ""
echo "(Введите пожалуйта номер пункта, чтобы выполнить комманды этого пункта, любой другой ввод, Выход)"
echo ""
tput sgr0