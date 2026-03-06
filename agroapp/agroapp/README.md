# 🌱 AgroControl - Monitoramento de Solo em Tempo Real

App Flutter para monitoramento inteligente de dados agrícolas com interface moderna e elegante.

## 📱 Screenshots

### Tela Principal (Home)
- Identidade da fazenda com localização
- Status da máquina com indicador pulsante
- Preview rápido de dados (umidade, temperatura, nutrientes)
- Badge de status da umidade

### Tela de Detalhes
- Card destacado de umidade com gradiente
- Dados climáticos completos
- Lista estilizada de informações
- Navegação fluida entre telas

## 🚀 Como Rodar

```bash
# 1. Instalar dependências
flutter pub get

# 2. Rodar no Chrome
flutter run -d chrome

# 3. Rodar no Android/iOS
flutter run
```

## 🛠️ Tecnologias Usadas

- **Flutter 3.27+** - Framework multiplataforma
- **Google Fonts** - Tipografia moderna (Lora, Montserrat, Cormorant Garamond)
- **Material Design 3** - Design system atualizado
- **Arquitetura em camadas** - core/, features/, shared/

## 📂 Estrutura do Projeto

```
lib/
├── core/
│   ├── constants/
│   │   └── app_colors.dart      # Paleta de cores centralizada
│   └── theme/
│       └── app_theme.dart       # Tema light/dark
├── features/
│   ├── home/
│   │   └── home_page.dart       # Tela principal
│   └── details/
│       └── details_page.dart    # Tela de detalhes
├── shared/
│   └── models/
│       └── fazenda_model.dart   # Modelo de dados
└── main.dart                     # Entry point
```

## ✨ Funcionalidades

- ✅ Animação pulsante no status da máquina
- ✅ Navegação com passagem de objetos
- ✅ Getters inteligentes no modelo (statusUmidade, corUmidade)
- ✅ Dark mode adaptativo
- ✅ Contraste adequado (WCAG 4.5:1)
- ✅ Simulação de dados em tempo real

## 👨‍💻 Desenvolvido por

Paola - Projeto acadêmico Flutter

## 📄 Licença

MIT License
