# Архітектура MovieAppTCA

## Загальний опис
Проект побудований на архітектурі TCA (The Composable Architecture), яка базується на принципах Redux. Основні компоненти:

### 1. State (Стан)
```swift
struct State: Equatable {
    var movies: [Movie] = []          // Список фільмів
    var tvShows: [TVShow] = []        // Список серіалів
    var persons: [Person] = []        // Список персон
    var isLoading: Bool = false       // Стан завантаження
    var error: String?                // Помилка, якщо є
    var selectedMovie: MovieThemoviedb?    // Вибраний фільм для детального перегляду
    var selectedTVShow: TVThemoviedb?      // Вибраний серіал для детального перегляду
    var selectedPerson: PersonThemoviedb?  // Вибрана персона для детального перегляду
}
```
Стан - це єдине джерело правди, яке містить всю необхідну інформацію для відображення UI.

### 2. Action (Дії)
```swift
enum Action: Equatable {
    case onAppear                     // Дія при появі екрану
    case moviesResponse(TaskResult<[Movie]>)      // Відповідь з API для фільмів
    case tvShowsResponse(TaskResult<[TVShow]>)    // Відповідь з API для серіалів
    case personsResponse(TaskResult<[Person]>)    // Відповідь з API для персон
    case movieSelected(Movie)         // Вибір фільму
    case tvShowSelected(TVShow)       // Вибір серіалу
    case personSelected(Person)       // Вибір персони
    case movieDetailsResponse(TaskResult<MovieThemoviedb>)    // Відповідь з API для деталей фільму
    case tvShowDetailsResponse(TaskResult<TVThemoviedb>)      // Відповідь з API для деталей серіалу
    case personDetailsResponse(TaskResult<PersonThemoviedb>)  // Відповідь з API для деталей персони
    case dismissDetail                // Закриття детального перегляду
}
```
Дії описують всі можливі зміни стану в додатку.

### 3. Reducer (Редюсер)
```swift
var body: some ReducerOf<Self> {
    Reduce { state, action in
        switch action {
        case .onAppear:
            // Логіка завантаження даних
        case .movieSelected:
            // Логіка вибору фільму
        // ... інші кейси
        }
    }
}
```
Редюсер - це функція, яка приймає поточний стан і дію, і повертає новий стан.

### 4. View (Представлення)
```swift
struct MovieListView: View {
    let store: StoreOf<MovieListFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            // UI компоненти
        }
    }
}
```
Представлення відображає стан і відправляє дії через store.

## Послідовність роботи

1. **Запуск додатку**:
   - Створюється `Store` з початковим станом
   - Завантажується `MovieListView`

2. **Завантаження даних**:
   - При появі екрану (`onAppear`) відправляється дія `.onAppear`
   - Редюсер обробляє цю дію і запускає паралельні запити до API
   - Отримані дані зберігаються в стані через відповідні дії

3. **Взаємодія з користувачем**:
   - Користувач клікає на картку фільму/серіалу/персони
   - Відправляється відповідна дія (наприклад, `.movieSelected`)
   - Редюсер обробляє дію і запускає запит за деталями
   - Отримані деталі зберігаються в стані
   - Відкривається повноекранний детальний перегляд

4. **Закриття детального перегляду**:
   - Користувач натискає кнопку "Back"
   - Відправляється дія `.dismissDetail`
   - Редюсер очищає відповідне поле в стані
   - Детальний перегляд закривається

## Переваги архітектури

1. **Єдине джерело правди**: Весь стан зберігається в одному місці
2. **Передбачуваність**: Зміни стану відбуваються тільки через дії
3. **Тестованість**: Легко тестувати редюсер і логіку
4. **Модульність**: Компоненти можна легко перевикористовувати
5. **Відстеження змін**: Легко відстежити, як і чому змінюється стан

## Компоненти UI

1. **MovieCard/TVShowCard/PersonCard**:
   - Відображають основну інформацію про елемент
   - При кліку відправляють дію вибору

2. **MovieDetailView/TVShowDetailView/PersonDetailView**:
   - Відображають детальну інформацію
   - Використовують повноекранний режим
   - Мають кнопку повернення

3. **CategorySection**:
   - Групує картки за категоріями
   - Забезпечує горизонтальну прокрутку

## Мережеві запити

1. **MovieClient**:
   - Обробляє всі запити до API
   - Використовує async/await для асинхронних операцій
   - Повертає результати через TaskResult

2. **API Endpoints**:
   - `/movie/popular` - популярні фільми
   - `/tv/popular` - популярні серіали
   - `/person/popular` - популярні персони
   - `/movie/{id}` - деталі фільму
   - `/tv/{id}` - деталі серіалу
   - `/person/{id}` - деталі персони 