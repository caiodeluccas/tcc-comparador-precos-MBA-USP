# Comparador de Preços - Coletor de Dados (TCC)

> ⚠️ **PROJETO EM CONSTRUÇÃO**: Este sistema faz parte de um Trabalho de Conclusão de Curso (MBA) e está em fase de desenvolvimento. Algumas funcionalidades podem não funionar ainda.

Este repositório contém o microserviço de coleta de dados para o projeto de Comparação de Preços. O sistema utiliza Python para extração de dados da OIT (ILO) e PostgreSQL para armazenamento, operando totalmente via Docker.

## 🚀 Estrutura do Projeto

* **microservico_coletor/**: Código fonte em Python (Extrator, Conector DB e Jobs).
* **db_init/**: Scripts SQL e Shell para inicialização automática do banco de dados e permissões.
* **docker-compose.yml**: Orquestração dos containers de Banco de Dados e Aplicação.

## 🛠️ Pré-requisitos

* Docker e Docker Compose instalados.
* Git.

## ⚙️ Configuração Inicial

1. **Clonar o repositório:**
   ```bash
   git clone https://github.com/seu-usuario/seu-repositorio.git
   cd seu-repositorio