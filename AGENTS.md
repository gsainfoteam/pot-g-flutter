# PotG Flutter

## Dev environment tips

- Use `dart run slang` to generate translations.
- Use `dart run build_runner build --delete-conflicting-outputs` to generate code.
  - Some errors may occur due to cached files, so use `dart run build_runner clean` to clean the cache if you encounter errors.
- Generated files (`.g.dart`, `.freezed.dart`) should not be committed manually - they are auto-generated.

## PR instructions

- Title format: `<type>(<tag>): <title>`. (tag is optional)
- Always run `dart analyze` before committing.

## Commit messages

- Commit messages should be in the following format:
  - `<type>(<tag>): <title>`. (tag is optional)
  - `<type>` is one of the following:
    - `feat`: A new feature
    - `fix`: A bug fix
    - `docs`: Documentation only changes
    - `style`: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
    - `refactor`: A code change that neither fixes a bug nor adds a feature
    - `test`: Adding missing tests or correcting existing tests
    - `chore`: Other changes that don't modify src or test files
    - `ci`: Changes to CI configuration
  - `<tag>` is one of the following:
    - `chat`: Chat related changes
    - `deps`: Dependency changes
    - `ios`: iOS related changes
    - `android`: Android related changes

## Module Structure

See [README.md](README.md) for more details.

## BLoC pattern

- Use `Bloc` or `Cubit` to manage state.
- You can use `StatefulWidget` for UI only state management (not related to the business logic).
- Use `bloc_concurrency` to cancel, restart, drop, etc.
  - If event handler uses `emit.forEach`, you should use `restartable`.
  - When multiple events can be invoked in the same time, but idempotence is guaranteed, you should use `droppable`.
- Use `freezed` to generate state and event classes.

## Domain Layer

- Domain Layer is responsible for business logic.
- It should not depend on any other layer.
- Also, it should use only pure Dart code. No external dependencies or third-party libraries.
- It is recommended to use `abstract interface class` to define interfaces.
- It is recommended to use only getter and methods to define interfaces.

- Define exception classes as `sealed class` and use `const factory` to define exception classes.
- Errors from data layer should be rethrown as domain layer exceptions.

## Dependency Injection

- Use `get_it` and `injectable` to manage dependencies.
- Typically, use `@injectable` to register dependencies.
- Use `@singleton` or `@lazySingleton` to register dependencies that are instantiated only once in the app.
  - For example, `AppRouter`, `dio`, `storage`, `logger` etc.

### Dependency Injection in Data Layer

- Data Layer implements domain layer.
- To inject data layer dependencies, `@Injectable(as: <interface>)`, `@LazySingleton(as: <interface>)` or `@Singleton(as: <interface>)` should be used.

## Logging

- Do not use `L` class by guessing. `L` uses predefined event names and properties. It must be used by humans.
  - Exceptionally, `L.e` can be used and should be used to log errors.
