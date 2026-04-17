# Storia

Plataforma de leitura e publicação de webnovels desenvolvida em Flutter, com gerenciamento de conteúdo, integração com backend e foco em experiência do usuário.
<img width="3000" height="1215" alt="Novo Projeto (2)" src="https://github.com/user-attachments/assets/021eaf5e-bb83-49ec-af8d-8f677402a300" />
## 🔗 Demo

Acesse a aplicação:
https://master-83bc9.web.app/#/auth

Login via Google disponível.

---

## 📌 Sobre o projeto

O Storia é uma aplicação multiplataforma que permite a leitura e publicação de histórias digitais, com um sistema de gerenciamento de conteúdo e foco em personalização da experiência do usuário.

O projeto foi desenvolvido com o objetivo de explorar arquitetura de aplicações, integração com serviços backend e construção de interfaces modernas e intuitivas.

---

## 🚀 Funcionalidades principais

### App Mobile (leitura)
- Leitura de histórias com interface customizável
- Persistência de preferências do usuário
- Feed com carregamento dinâmico (infinite scroll) e sistema de filtros para descoberta de conteúdo
- Pesquisa com carregamento dinâmico
<img width="1640" height="664" alt="Mobile App" src="https://github.com/user-attachments/assets/6e811a23-b654-4c18-9c15-d9fa6866f9f4" />

### App Web (dashboard)
- Publicação e gerenciamento de conteúdo
- Agendamento de capítulos
<img width="3000" height="1215" alt="Novo Projeto (1)" src="https://github.com/user-attachments/assets/fa7b73be-e326-468e-a02d-394b1ef56b43" />

---

## 🧱 Arquitetura

O projeto segue uma organização modular com separação de responsabilidades:

- **Models** → Representação dos dados  
- **Repositories** → Abstração e controle de acesso a dados (Firebase)  
- **State Management** → Gerenciamento de estado utilizando Riverpod  
- **Backend** → Integração com Firebase e Cloud Functions  

Essa estrutura permite maior organização, manutenção facilitada e evolução do sistema ao longo do tempo.

---

## ⚙️ Tecnologias utilizadas

- Flutter / Dart  
- Firebase  
  - Firestore  
  - Authentication  
  - Storage
  - Functions

---

## 🎯 Decisões técnicas

Algumas decisões importantes durante o desenvolvimento:

- Implementação de auto-save com debounce para melhorar performance e confiabilidade  
- Estruturação modular do projeto visando escalabilidade  
- Uso de Firebase para simplificar backend e acelerar desenvolvimento
- Persistência local de preferências utilizando SharedPreferences  

---

## 📁 Estrutura do projeto

Este repositório contém a estrutura principal da aplicação (camadas de apresentação e lógica).

Configurações sensíveis (como chaves de API e integrações completas com backend) foram omitidas por segurança.

---

## ⚠️ Observações

Este projeto está em evolução e algumas funcionalidades ainda estão sendo refinadas, incluindo melhorias no dashboard e ajustes técnicos.

---

## 📜 Licença

Este projeto está disponível apenas para fins de demonstração e portfólio.

Todos os direitos reservados.
