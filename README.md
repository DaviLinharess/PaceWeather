# PaceWeather 🏃‍♂️⛅

> Aplicativo móvel em Flutter/Dart desenvolvido para a disciplina **Desenvolvimento para Dispositivos Móveis**.

---

## 🎯 Escopo do Projeto

O **PaceWeather** é um aplicativo cujo objetivo é auxiliar corredores amadores e atletas no planejamento de suas sessões de treinamento ao ar livre. 

A aplicação cruza dados climáticos em tempo real (OpenWeather API) com a gestão de treinos intervalados e de resistência, permitindo ao usuário:
1. **Consultar o clima:** verificar temperatura, sensação e condições de vento antes de iniciar os treinos;
2. **Personalizar treinos:** configurar sessões com títulos, repetições, distâncias e zonas de frequência cardíaca (Z1 a Z5);
3. **Acesso rápido:** gerenciar e filtrar seus treinos favoritos por categoria em uma interface ágil e dinâmica.

---

## 📱 Tela Implementada (Escopo da Atividade)

A aplicação concentra-se na tela **Meus Treinos**, atendendo simultaneamente aos requisitos de:
1. **Layout Responsivo (Atividade 1):** Adaptação dinâmica entre mobile e widescreen/desktop;
2. **Tratamento de Eventos (Atividade 2):** Ciclo completo de interação (*Ação → Processamento → Feedback*).

### Seções Visuais e Componentes
- **Seção 1 (Cabeçalho e Busca):** Logotipo oficial, ícones de navegação, campo `TextField` com reação em tempo real (`onChanged`) e 2 botões de comportamentos distintos (`onPressed` condicional e limpeza);
- **Seção 2 (Filtros e Clima):** Barra de categorias (`ALL`, Corrida, Intervalado, Frequência Cardíaca) e o indicador explícito **"API do Clima aparecerá aqui"**;
- **Seção 3 (Grade de Treinos Interativa):** Cards amarelos com suporte a múltiplos gestos (`onTap` para iniciar sessão e `onLongPress` para abrir diálogo de detalhes e favoritar).

---

## ⚡ Tratamento de Eventos e Encadeamento

- **`onChanged` (`TextField`):** Monitora a digitação com logs no console e validação para habilitar a busca;
- **`onPressed` (Botão 1 - Filtrar):** Ação principal condicional que dispara um `AlertDialog` de confirmação e, na sequência, atualiza a lista e emite um `SnackBar`;
- **`onPressed` (Botão 2 - Limpar):** Ação secundária de reset do campo e da listagem;
- **`onTap` vs `onLongPress` (`GestureDetector`):** Gestos distintos no mesmo componente gerando respostas visuais diferentes (`SnackBar` imediato vs `AlertDialog` de inspeção).

---

## 📐 Estrutura do Projeto

```
PaceWeather/
├── pubspec.yaml                 # Configuração do Flutter e assets
├── pubspec.lock                 # Versões congeladas das dependências
├── analysis_options.yaml        # Regras de código limpo (Linter)
├── README.md                    # Documentação do projeto
├── ENTREGA_MOODLE.md            # Registro e respostas para envio no Moodle
├── assets/
│   └── images/
│       └── logo.png             # Logotipo oficial PaceWeather
└── lib/
    ├── main.dart                # Ponto de entrada com MaterialApp
    ├── theme/
    │   └── app_colors.dart      # Paleta de cores oficial
    ├── models/
    │   └── workout_model.dart   # Modelo de dados de treino e lista mockada
    ├── widgets/
    │   ├── pace_weather_logo.dart # Componente oficial da logo
    │   ├── filter_pill.dart     # Botão de filtro da lista
    │   └── workout_card.dart    # Card de treino com onTap e onLongPress
    └── screens/
        └── meus_treinos/
            ├── meus_treinos_screen.dart  # Tela com LayoutBuilder e lógica de eventos
            ├── meus_treinos_mobile.dart  # Layout Mobile (< 600px)
            └── meus_treinos_desktop.dart # Layout Desktop/Tablet (>= 600px)
```

---

## 🚀 Como Executar o Projeto

```bash
# Obter as dependências
flutter pub get

# Executar no emulador ou dispositivo conectado
flutter run
```
