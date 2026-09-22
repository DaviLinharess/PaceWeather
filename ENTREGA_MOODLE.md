# Registro de Entrega da Atividade - Moodle

**Disciplina:** Desenvolvimento para Dispositivos Móveis  
**Projeto:** PaceWeather  
**Aluno:** Davi Linhares  
**Repositório Git:** [https://github.com/DaviLinharess/PaceWeather.git](https://github.com/DaviLinharess/PaceWeather.git)

---

## 📋 Resumo para Envio no Moodle (3 a 5 Linhas Obrigatórias)

> A tela "Meus Treinos" foi estruturada em três seções visuais distintas (Cabeçalho com navegação e logo, Barra de Filtros horizontais e Grade de Treinos), utilizando widgets nativos como `Row`, `Column`, `Expanded` e `SizedBox` para garantir espaçamentos consistentes sem aninhamentos desnecessários de containers. A responsividade foi aplicada com `LayoutBuilder`, que analisa a largura máxima (`maxWidth < 600`): em dispositivos móveis exibe uma grade de 2 colunas (`MeusTreinosMobileLayout`), enquanto em telas maiores ou modo paisagem (`MeusTreinosDesktopLayout`) adapta automaticamente para 3 a 4 colunas com cabeçalho expandido e proporções visuais preservadas.

---

## 🛠️ Justificativa e Organização da Árvore de Widgets

1. **Uso de Widgets de Layout:**
   - **`Column` e `Row`:** Utilizados para estruturar o fluxo vertical das seções (Cabeçalho -> Filtros -> Grid) e a disposição horizontal dos botões de filtro e ações do cabeçalho.
   - **`Expanded`:** Aplicado para que a grade de treinos preencha de forma elástica o espaço restante da tela sem causar estouro visual (`overflow`).
   - **`Padding` e `SizedBox`:** Empregados para margens externas e espaçamentos precisos entre os cards e botões, evitando a criação de múltiplos `Container` sem finalidade decorativa.

2. **Aplicação da Responsividade com `LayoutBuilder`:**
   ```dart
   LayoutBuilder(
     builder: (context, constraints) {
       if (constraints.maxWidth < 600) {
         return MeusTreinosMobileLayout(...); // Layout para telas pequenas (< 600px)
       } else {
         return MeusTreinosDesktopLayout(...); // Layout para tablets / monitores (>= 600px)
       }
     },
   )
   ```
   - **Modo Retrato / Mobile (< 600px):**
     - Cabeçalho compacto com ícones de Início e Perfil centralizando o logotipo;
     - Barra de 4 filtros arredondados (`ALL`, Corrida, Intervalado e Regenerativo);
     - Grade em 2 colunas com proporção `childAspectRatio: 0.82`.
   - **Modo Paisagem / Tablet / Desktop ($\ge$ 600px):**
     - Cabeçalho expandido com barra superior, botão rápido para cadastrar treino e status meteorológico;
     - Grade expandida para 3 ou 4 colunas (`childAspectRatio: 0.95`), evitando estiramento horizontal dos cards.

---

## 📸 Instruções para o Screenshot da Entrega

1. Abra a tela **Meus Treinos** (no emulador Flutter ou pelo simulador web interativo incluído na pasta `preview/index.html`).
2. Capture a imagem mostrando a tela com as 3 seções (Cabeçalho, Barra de Filtros e Grade de Cards Amarelos).
3. Se desejar, capture também a tela em modo paisagem ou tablet demonstrando a transição responsiva via `LayoutBuilder`.
