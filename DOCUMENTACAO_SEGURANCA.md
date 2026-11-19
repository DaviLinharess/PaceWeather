# Documentação Técnica — Implementação de Comunicação Segura (PaceWeather)

**Disciplina:** Desenvolvimento para Dispositivos Móveis  
**Projeto:** PaceWeather (Flutter)

---

## 1. Armazenamento Local: `SharedPreferences` vs `flutter_secure_storage`

### Qual o propósito do `SharedPreferences` e o que armazenar nele?
O `SharedPreferences` é um mecanismo leve de persistência chave-valor projetado exclusivamente para **dados não sensíveis** e de configuração de interface, tais como:
- Preferências de interface (ex.: unidade de distância em quilômetros `km` ou milhas `mi`, implementado em `lib/services/preferences_service.dart`);
- Tema da aplicação (modo claro/escuro) e switches de alertas visuais;
- Última pesquisa realizada pelo usuário (ex.: filtro de treinos salvo em `last_search_query` na tela `MeusTreinosScreen`).

### Por que o `SharedPreferences` NÃO é adequado para credenciais ou tokens JWT?
No Android, o `SharedPreferences` grava os dados em arquivos XML em **texto puro (plain text)** dentro do diretório da aplicação (`/data/data/<pacote>/shared_prefs/`), e no iOS utiliza arquivos `.plist` sem criptografia (`NSUserDefaults`). Caso o dispositivo possua acesso *root/jailbreak*, sofra um backup desprotegido via ADB ou seja alvo de malware com privilégios elevados, o token JWT pode ser lido diretamente em texto claro, permitindo o sequestro de sessão (*Session Hijacking*).

### Por que utilizamos `flutter_secure_storage` para o Token JWT?
O pacote `flutter_secure_storage` (implementado em `lib/services/secure_storage_service.dart`) protege os dados **em repouso (at rest)** utilizando mecanismos criptográficos nativos apoiados por hardware do sistema operacional:
- **Android:** utiliza o **Android Keystore** + `EncryptedSharedPreferences` (chaves AES-256/RSA protegidas em ambiente isolado TEE/StrongBox).
- **iOS:** utiliza o **Keychain Services** da Apple.

---

## 2. Segurança em Trânsito: Diferenças entre HTTP (Desenvolvimento) e HTTPS (Produção)

No projeto, todas as chamadas à API (`https://dummyjson.com/auth/login` e `https://dummyjson.com/auth/users`) já utilizam **HTTPS**. Caso uma API fosse executada em `HTTP` durante o desenvolvimento local, as diferenças críticas ao migrar para `HTTPS` em produção seriam:

1. **Confidencialidade (Criptografia TLS):**
   - **HTTP:** Os dados trafegam em texto puro. Qualquer atacante na mesma rede Wi-Fi (usando *Wireshark*, *ARP Spoofing*, etc.) consegue ler a senha enviada no `POST /login` e o cabeçalho `Authorization: Bearer <token>`.
   - **HTTPS:** Estabelece um túnel criptografado via **TLS (Transport Layer Security)** antes do envio dos cabeçalhos e do corpo HTTP, impedindo a leitura por terceiros.
2. **Autenticidade do Servidor (Certificados Digitais):**
   - **HTTP:** Não valida a identidade do servidor, facilitando ataques de *DNS Spoofing*.
   - **HTTPS:** O cliente valida o certificado digital assinado por uma Autoridade Certificadora (CA) confiável, garantindo que o app está se comunicando com o servidor legítimo.
3. **Integridade dos Dados:**
   - **HTTP:** Pacotes podem ser interceptados e adulterados em trânsito (*Man-in-the-Middle - MitM*) sem que o app perceba.
   - **HTTPS:** O protocolo TLS utiliza códigos de autenticação de mensagem (MAC / AEAD) que detectam qualquer alteração de bytes no caminho e abortam a conexão imediatamente.

---

## 3. Análise sobre Criptografia Adicional com o Pacote `encrypt`

### 3.1. O HTTPS já protege os dados transmitidos entre cliente e servidor?
**Sim.** O HTTPS (HTTP sobre TLS 1.2/1.3) já garante confidencialidade, integridade e autenticidade para **toda a comunicação em trânsito** (incluindo URL/path, cabeçalhos como `Authorization: Bearer <token>` e o corpo JSON da requisição/resposta) entre o dispositivo móvel e o servidor onde termina a conexão TLS.

### 3.2. Em quais situações seria necessária uma camada adicional de criptografia utilizando o pacote `encrypt`?
Uma camada adicional de criptografia na camada de aplicação (ex.: AES/RSA via pacote `encrypt`, conhecida como *Application-Layer Encryption* ou *Payload Encryption*) seria necessária nos seguintes cenários:
1. **Criptografia Ponta a Ponta (E2EE) passando por intermediários (Proxies / API Gateways / Load Balancers):** Quando a conexão TLS termina em um *Reverse Proxy*, CDN ou *API Gateway* (TLS Termination) e o tráfego segue descriptografado pela rede interna até os microsserviços, ou quando nem mesmo o servidor intermediário deve ter acesso ao conteúdo em texto claro (ex.: mensagens privadas, dados médicos/biométricos ou senhas bancárias).
2. **Proteção contra logs acidentais no Backend/APM:** Se o servidor registra o corpo das requisições JSON em ferramentas de monitoramento/logs, criptografar campos ultrassensíveis (como CPF, cartão ou biometria) com `encrypt` impede que fiquem visíveis nos logs.
3. **Armazenamento local em banco de dados ou arquivos grandes:** Quando a aplicação precisa salvar grandes volumes de dados sensíveis localmente em arquivos ou cache SQLite (onde o `flutter_secure_storage` não é indicado por ser voltado apenas a pequenos pares chave-valor), usa-se o pacote `encrypt` (AES) e guarda-se apenas a chave simétrica no `flutter_secure_storage`.

### 3.3. Quais seriam as vantagens e desvantagens dessa abordagem?

| Aspecto | Vantagens | Desvantagens |
| :--- | :--- | :--- |
| **Segurança** | Defesa em profundidade (*Defense in Depth*): mesmo que o TLS seja interceptado por um proxy corporativo ou certificado instalado no aparelho, o payload continua cifrado. | **Risco na gestão de chaves no cliente:** Se a chave simétrica AES estiver *hardcoded* no código Dart do app, um atacante pode fazer engenharia reversa do APK/IPA e extrair a chave, gerando falsa sensação de segurança. |
| **Privacidade / Compliance** | Protege campos sensíveis contra exposição em logs de API Gateways e intermediários (LGPD / PCI-DSS). | Complexidade de rotação e distribuição segura de chaves (exigindo criptografia assimétrica RSA/ECDH combinada com AES). |
| **Desempenho e Manutenção** | Permite cifrar seletivamente apenas os campos críticos do JSON. | Maior consumo de CPU/bateria no dispositivo móvel, aumento do tamanho do payload (Base64) e maior dificuldade de depuração/manutenção entre cliente e backend. |

**Decisão técnica do grupo:** Como a aplicação já utiliza **HTTPS (TLS)** em trânsito e **`flutter_secure_storage` (Keystore/Keychain)** para o token JWT em repouso, não há necessidade de adicionar criptografia redundante com `encrypt` para os dados de consulta da API, evitando chaves estáticas embutidas no código cliente.

---

## 4. Tratamento dos 6 Cenários Obrigatórios no Código

Todos os 6 cenários exigidos foram implementados em `lib/services/api_service.dart`, `lib/services/secure_storage_service.dart`, `lib/screens/login_screen.dart` e `lib/screens/home_screen.dart` (e possuem botões rápidos de simulação na tela para facilitar a avaliação):

1. **Servidor indisponível:** Captura `SocketException` e códigos HTTP `>= 500`, exibindo alerta amigável sem fechar o app.
2. **Timeout de conexão:** Configurado `.timeout(const Duration(seconds: 10))` nas requisições HTTP, capturando `TimeoutException`.
3. **Credenciais inválidas:** Captura retorno HTTP `400/401` no endpoint `POST /auth/login` e informa ao usuário na tela de Login.
4. **Token expirado (`401 Unauthorized`):** Na tela de consulta (`HomeScreen`), ao receber `401 Unauthorized` do endpoint protegido `GET /auth/users`, o app chama `SecureStorageService().deleteToken()` para remover o token do `flutter_secure_storage` e redireciona automaticamente para `/login`.
5. **Resposta JSON inválida:** Captura `FormatException` ao executar `jsonDecode` quando o payload está malformado ou fora do contrato esperado.
6. **Falha na leitura ou gravação do armazenamento seguro:** Captura `PlatformException` no `FlutterSecureStorage` e lança `SecureStorageException` tratada na interface.
