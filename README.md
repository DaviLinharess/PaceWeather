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

## 📱 Telas Desenvolvidas com Base nos Protótipos

1. **Tela 1: Carregamento (Splash Screen)**
   - Elementos geométricos orgânicos nos cantos (amarelo e azul);
   - Logotipo oficial vetorial com o corredor, nuvem, sol e tipografia "PaceWeather";
   - Transição suave para a tela principal.

2. **Tela 2: Home**
   - Logotipo em destaque na área superior;
   - Card azul com dados meteorológicos: *Nublado*, *20ºC*, *Ventos Fortes*;
   - Faixa de saudação (*"Bem-vindo, Davi !"*);
   - Botões de navegação rápida: **Treinar** e **Novo Treino**.

3. **Tela 3: Criar Treino (Novo Treino)**
   - Topo amarelo enérgico com botão de retorno e descrição explicativa;
   - Card arredondado com campos em pílula branca (*Título*, *Repetições*, *Distância*);
   - Seletor interativo de zonas de frequência cardíaca (**Z1**, **Z2**, **Z3**, **Z4**, **Z5**);
   - Botão de ação estilizado em pílula preta: **Salvar**.

4. **Tela 4: Meus Treinos (Tela Responsiva Obrigatória da Atividade)**
   - **Cabeçalho:** Botão de início, logotipo centralizado e botão de perfil;
   - **Barra de Filtros:** Seletores arredondados com realce ativo em amarelo (`ALL`, Corrida, Intervalado, Frequência Cardíaca);
   - **Grade de Treinos:** Cards amarelos vibrantes com badge do tipo de treino, título, distância e botão circular de play;
   - **Responsividade com `LayoutBuilder`:** Alterna automaticamente entre `MeusTreinosMobileLayout` (< 600px, 2 colunas) e `MeusTreinosDesktopLayout` ($\ge$ 600px, 3 a 4 colunas com cabeçalho expandido).

---

## 📐 Estrutura do Projeto

```
PaceWeather/
├── pubspec.yaml                 # Configuração do Flutter e metadados
├── README.md                    # Documentação do projeto
├── ENTREGA_MOODLE.md            # Texto oficial de 3-5 linhas para a entrega
├── preview/                     # Simulador web interativo para testes e screenshots
│   ├── index.html
│   ├── styles.css
│   └── app.js
└── lib/
    ├── main.dart                # MaterialApp com rotas e seletor rápido
    ├── theme/
    │   └── app_colors.dart      # Paleta de cores oficial
    ├── models/
    │   └── workout_model.dart   # Modelo de dados de treino e lista mockada
    ├── widgets/
    │   ├── pace_weather_logo.dart # Logo vetorial personalizada
    │   ├── filter_pill.dart     # Botão de filtro da lista
    │   └── workout_card.dart    # Card de treino com badge e botão play
    └── screens/
        ├── splash_screen.dart   # Tela de carregamento
        ├── home_screen.dart     # Tela Home (clima)
        ├── novo_treino_screen.dart # Tela de criação de treino
        └── meus_treinos/
            ├── meus_treinos_screen.dart  # Tela com LayoutBuilder
            ├── meus_treinos_mobile.dart  # Layout Mobile (< 600px)
            └── meus_treinos_desktop.dart # Layout Desktop/Tablet (>= 600px)
```

---

## 🚀 Como Executar o Projeto

### Com o Flutter SDK instalado:
```bash
# Obter as dependências
flutter pub get

# Executar no emulador ou dispositivo conectado
flutter run
```

### Visualização imediata via Simulador Web:
Abra o arquivo `preview/index.html` em qualquer navegador (Chrome, Edge, Firefox) para navegar por todas as telas, alternar tamanhos de tela e testar os pontos de quebra da responsividade!
