# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(
  [
    {
      first_name: 'Алексей',
      last_name: 'Тамаров',
      role: :admin,
      email: 'lesha.tamarov@gmail.com',
      password: 'password',
      confirmed_at: 1.day.ago
    },

    {
      first_name: 'Максим',
      last_name: 'Седнев',
      role: :owner,
      email: 'max.sednev@gmail.com',
      password: 'password',
      confirmed_at: 1.day.ago
    },

    {
      first_name: 'Тодор',
      last_name: 'Гринь',
      role: :owner,
      email: 'todor.hryn@gmail.com',
      password: 'password',
      confirmed_at: 1.day.ago
    },

    {
      first_name: 'Наталья',
      last_name: 'Заяц',
      email: 'natasha.zayac@gmail.com',
      password: 'password',
      confirmed_at: 1.day.ago
    },

    {
      first_name: 'Герман',
      last_name: 'Акулович',
      email: 'german.ak@gmail.com',
      password: 'password',
      confirmed_at: 1.day.ago
    },

    {
      first_name: 'Владислав',
      last_name: 'Почобут',
      email: 'vlad.pochebyt@gmail.com',
      password: 'password',
      confirmed_at: 1.day.ago
    }

  ]
)

owner1 = User.find_by(last_name: 'Седнев', role: :owner)
owner2 = User.find_by(last_name: 'Гринь', role: :owner)

owner1.organizations.create(
  [
    {
      name: 'Город красоты',
      description: 'Наш салон красоты оказывает различные косметические услуги.'
    },

    {
      name: 'Аврора',
      description: 'Юридическая компания "Аврора" предоставляет услуги консультации по широкому спектру вопросов:
                    регистрация фирм; лицензирование деятельности; ликвидация, банкротство; разработка договоров, 
                    соглашений и т.д.'
    }
  ]
)

owner1.organizations.first.services.create(
  [
    { name: 'Маникюр' },
    { name: 'Педикюр' },
    { name: 'Макияж' },
    { name: 'Депиляция' }
  ]
)

owner1.organizations.last.services.create(
  [
    { name: 'Консультация юриста' }
  ]
)

owner2.organizations.create(
  [
    {
      name: 'Новый образ',
      description: 'Парикмахерская "Новый образ" предоставляет услуги стрижки (мужская, женская, детская) и окраски 
                    волос, оказываемые высококвалифицированными специальистами.'
    },

    {
      name: 'Нирвана',
      description: 'Студия массажа "Нирвана" специализируется на оказании высококлассных услуг каждому клиенту. Наши 
                    гости могут наслаждаться лучшими массажными техниками, приводящими в порядок тело и дух.'
    }
  ]
)

owner2.organizations.first.services.create(
  [
    { name: 'Мужская стрижка' },
    { name: 'Женская стрижка' },
    { name: 'Детская стрижка' },
    { name: 'Окраска волос' }
  ]
)

owner2.organizations.last.services.create(
  [
    { name: 'Классический массаж' },
    { name: 'Тайский массаж' },
    { name: 'Спа-массаж' },
    { name: 'Детский массаж' }
  ]
)
