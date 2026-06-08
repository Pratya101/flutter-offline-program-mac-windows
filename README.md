# SoftSale Offline

Flutter desktop sales app for fully offline local-data workflows on macOS and
Windows.

## Stack

- Flutter desktop: macOS and Windows targets
- SQLite local database: `drift` + `sqlite3_flutter_libs`
- Local app data directory: `path_provider`
- Backup export: zipped SQLite file with a manifest
- Offline auth flow with local user CRUD

## Setup

```sh
flutter pub get
dart run build_runner build
```

## Run

```sh
flutter run -d macos
```

Debug shortcut:

```sh
make dev
```

Keep the debug process open while coding. After saving files, use Flutter hot
reload in the terminal:

- `r`: hot reload
- `R`: hot restart
- `q`: quit

VS Code can also run the included `Flutter macOS Debug` launch configuration.

Windows builds must be created on a Windows machine:

```sh
flutter run -d windows
```

## Build Release

macOS:

```sh
flutter build macos --release
```

Windows:

```sh
flutter build windows --release
```

## Local Data

The app stores its SQLite database under the operating system application
support directory. The running app shows the exact database path at the bottom
of the window.

Backups are created as `.zip` files in the app data `backups` folder.

## Login Flow

Start with `Create first user`, then login with the saved username and password.
The app opens a welcome page after login and shows the current profile from the
local database.

User fields:

- `fullName`: required
- `username`: required
- `password`: required for create, optional for edit
- `phone`: optional
