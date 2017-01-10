
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







# Card Rent API - Sample Application

## Install

##### Ruby version
```
ruby 2.2.0p0
```

##### Install gems
```
cd card_rent__api
```
```
bundle install
```
 ##### Database creation
 ```
rake db:create
```
```
rake db:migrate
```
###### Test database prepare
```
rake db:test:prepare
```
##### **Uncomment all in file schedule.rb in config/initializers folder**

##### Run all tests
```
rspec spec/
```
##### Run server
```
rails s
```
##### Run delayed job service
```
RAILS_ENV=development bin/delayed_job run
```
## API documentation

### Sign Up
```
curl -H 'Accept: application/json' \
     -d 'user[email]=john@mcclane.com&user[password]=superhero&user[password_confirmation]=superhero' \
 localhost:3000//api/users
```
### Sign In
```
curl -H 'Accept: application/json' \
     -d 'session[email]=john@mcclane.com&session[password]=superhero' \
     localhost:3000/api/session
```
### Get card
```
curl -H 'Accept: application/json' \
     -H 'Authorization: Token token="ddeb8941-bbce-4c6d-9287-d62b7990357d"' \
     localhost:3000/api/card
```
**token you recieved when signed up or signed in**
### Put card back
```
curl -H 'Accept: application/json' \
     -H 'Authorization: Token token="dced1e53-7f95-47b3-a9d1-98827717201f"'\
     -X PUT \
     -d 'card[suit]="spade&card[card]=10' \
      localhost:3000/api/card
````
**You must be admin to call this actions**
to make user admin you need in rails console update your user column named "admin" to true
### Get information about cards
```
curl  -H 'Accept: application/json' \
      -H 'Authorization: Token \ token="ddeb8941-bbce-4c6d-9287-d62b7990357d"'\
      localhost:3000/api/admin/stock
```
### Get information about balance and transactions
```
curl  -H 'Accept: application/json' \
      -H 'Authorization: Token \ token="ddeb8941-bbce-4c6d-9287-d62b7990357d"'\
      localhost:3000/api/admin/finances
```
