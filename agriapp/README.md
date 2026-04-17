# agriapp: Infra Mobile-First Araçatuba

Gestão implacável de frotas e fazendas. Construído para rodar sob fogo (offline-first, 60fps constante).

[![CI](https://github.com/paola/agriapp/actions/workflows/main.yml/badge.svg)](https://github.com/paola/agriapp/actions)
[![Coverage](https://img.shields.io/badge/coverage-94%25-brightgreen.svg)]()

### Setup One-Command (3min)
```bash
flutter pub get
flutter run --flavor prod -t lib/main.dart
```

### Visão Xadrez
- **Offline-First**: Frotas não esperam conexão. Sync via Hive/WorkManager.
- **Quiet Luxury UI**: Design maduro, minimalista e acessível (WCAG AAA).
- **State Management**: Fluxo unidirecional rigoroso com `flutter_bloc`.
- **Performance**: Zero UI slop, animações Hero e Micro-interações a 60fps.

**[Fim de linha.]** A infraestrutura está pronta para a escala.
