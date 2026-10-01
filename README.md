# PaceWeather 🏃‍♂️⛅

> Aplicativo móvel em Flutter/Dart desenvolvido para a disciplina **Desenvolvimento para Dispositivos Móveis**.

---

## 🎯 Escopo do Projeto

O **PaceWeather** é um aplicativo cujo objetivo é auxiliar corredores amadores e atletas no planejamento de suas sessões de treinamento ao ar livre. 

A aplicação cruza dados climáticos com a gestão de treinos de corrida e resistência, permitindo ao usuário:
1. **Consultar o clima:** verificar condições ideais de temperatura e vento antes de iniciar os treinos;
2. **Personalizar treinos:** configurar sessões com títulos, distâncias, zonas de frequência cardíaca (Z1 a Z5) e categorias (Longão, Intervalado, Regenerativo);
3. **Gerenciar desempenho:** acompanhar histórico semanal de quilometragem e métricas de pace.

---

## 🧭 Arquitetura de Navegação (Atividade 3)

O aplicativo implementa os padrões de navegação nativos do Flutter de forma simultânea e robusta:

### 1. Rotas Nomeadas Centralizadas (`MaterialApp`)
- `/login`: Tela de autenticação inicial;
- `/main`: Shell principal contendo `Drawer` e `BottomNavigationBar`;
- `/settings`: Tela de configurações de preferências;
- `/workout_details`: Tela de detalhes técnicos do treino (recebe parâmetros via `arguments`);
- `/novo_treino`: Tela de cadastro de treino (retorna resultado com valor via `Navigator.pop`).

### 2. Menu Lateral (`Drawer`)
- **Configurações:** Navegação empilhada com `pushNamed`;
- **Sobre o App:** Modal informativo simples exibido via `showDialog`;
- **Logout:** Substituição de rota via `pushReplacementNamed`, redirecionando para a tela de login e limpando o histórico.

### 3. Barra de Abas Inferior (`BottomNavigationBar`) com Pilhas Independentes
- **Aba 0 (Início):** Dashboard de boas-vindas com atalhos rápidos e resumo;
- **Aba 1 (Treinos):** Tela "Meus Treinos" completa, com suporte a busca, filtros e cards;
- **Aba 2 (Perfil):** Estatísticas semanais, metas e recordes pessoais do atleta;
- **Preservação de Estado:** Gerenciada através de `IndexedStack` com 3 `Navigator`s aninhados e chaves dedicadas (`GlobalKey<NavigatorState>()`).

### 4. Controle de Voltar do Sistema Operacional (`PopScope`)
- Gerencia o botão físico e o gesto de voltar do Android, desempilhando primeiro as rotas locais da aba ativa antes de alternar de aba ou encerrar a aplicação.

---

## 📐 Estrutura de Arquivos

```
PaceWeather/
├── pubspec.yaml                 # Configuração do Flutter e assets
├── pubspec.lock                 # Versões congeladas das dependências
├── analysis_options.yaml        # Regras de código limpo (Linter)
├── README.md                    # Documentação do projeto
├── ENTREGA_MOODLE.md            # Guia completo de entrega para o Moodle
├── assets/
│   └── images/
│       └── logo.png             # Logotipo oficial PaceWeather
└── lib/
    ├── main.dart                # Rotas centralizadas e inicialização
    ├── theme/
    │   └── app_colors.dart      # Paleta de cores oficial
    ├── models/
    │   └── workout_model.dart   # Modelo de treino e lista mockada
    ├── widgets/
    │   ├── app_drawer.dart      # Drawer lateral com 3 ações
    │   ├── pace_weather_logo.dart # Componente oficial da logo
    │   ├── filter_pill.dart     # Botão de filtro da lista
    │   └── workout_card.dart    # Card de treino interativo
    └── screens/
        ├── login_screen.dart           # Tela de Login (pushReplacement)
        ├── main_navigation_shell.dart  # Shell com BottomNav + Drawer + PopScope
        ├── home_screen.dart            # Aba Início
        ├── perfil_screen.dart          # Aba Perfil
        ├── settings_screen.dart        # Tela Configurações (push)
        ├── workout_details_screen.dart # Detalhes com arguments (Requisito 4)
        ├── novo_treino_screen.dart     # Novo Treino com pop(result) (Requisito 5)
        └── meus_treinos/
            ├── meus_treinos_screen.dart  # Aba Treinos com LayoutBuilder
            ├── meus_treinos_mobile.dart  # Layout Mobile (< 600px)
            └── meus_treinos_desktop.dart # Layout Desktop/Tablet (>= 600px)
```

---

## 🚀 Como Executar o Projeto

```bash
# Obter dependências
flutter pub get

# Verificar conformidade de código
flutter analyze

# Executar no emulador Android
flutter run
```
