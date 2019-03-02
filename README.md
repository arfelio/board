what is going on


Test Task Ruby
Доска объявлений
Пользовательская система:
- Регистрация нового пользователя.
- Состав профиля: login, full name, birthday, e-mail, address, city, state, country, zip, password и confirm password (все поля обязательны).
- Автоматическое определение местонахождение пользователя, после изменения полей формы(address, city, state, zip, country) и отображние его на карте, на страницах редактирования профиля и регистрации. Использовать Google Map ver 3.
- Редактирование профиля пользователя.
- Восстановление пароля.
- Просмотр профиля пользователя другими пользователями и отображать карту его местонахождения.
- Реализовать возможность авторизации с помощью Twitter, Facebook или Google App (любой из них).

Система объявлений:
- составлять/редактировать/удалять объявления пользователями;
- добавлять/редактировать комментарии к объявлению пользователями;
- сообщение включает поля: автор, текст, изображение;
- текст сообщения имеет разметку Textile, все остальные HTML теги блокируются(если было введен HTML тег, то его просто отобразить: пример, пользователь ввел '<h1>Hello</h1> *world*', то при просмотре сообщения увидит "<h1>Hello</h1>" и выделенным жирным шрифтом слово "world");
- комментировать объявления с использованием AJAX эффектов (не перегружать страницу при добавлении/удалении комментария);
- удалять комментарий может только Администратор или Модератор, и сам автор;
- не авторизованный пользователь может только на просмотр объявлений и профилей пользователей;
- просмотр списка объявлений должен отображать thumbnail(уменьшенную картинку), автора и первые слова текста(до 160 символов; слова не должны быть обрезанные) ;
- возможность поиска объявления по автору, контенту, адресу, тегам, тексту объявления.

Система ролей:
    Ввести 3 роли: администратор, пользователь и модератор
- Администратор: может управлять(добавлять,редактировать,удалять, устанавливать роли) пользователямию. Пользователь с правами администратора создается вручную из консоли или при миграции. Нужно указать как.
- Модератор: управляет всеми сообщениями и комментариями пользователей
- Пользователь: может добавлять и редактировать свои сообщения(объявления и комментарии)

Страницы:
- На всех страницах есть возможность перейти на список пользователей, список объявлений, редактирования своего профиля, выхода из системы.
- Главная содержит список объявлений.
- Просмотр объявления.
- Авторизация.
- Регистрация.
- Профиль.

ссылка на хероку https://sleepy-springs-1794.herokuapp.com/
что бы войти как администратор: почта для входа admin@mail.com  пароль: password
что бы войти как модератор: почта для входа moderator@mail.com пароль: password

