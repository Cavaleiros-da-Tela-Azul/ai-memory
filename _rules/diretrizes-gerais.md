# Diretrizes Gerais de Desenvolvimento

Regras fundamentais obrigatórias para os projetos da organização:

1. **Clean Code & Tipagem:**
   - Evite tipagens soltas (`any`). Priorize tipagem estrita e validação de contratos (schemas).
   - Mantenha funções pequenas e com responsabilidade única.

2. **Segurança e Variáveis de Ambiente:**
   - Nunca comite chaves de API, senhas ou tokens no Git.
   - Todo acesso a configurações sensíveis deve utilizar variáveis de ambiente validadas.

3. **Commits e Versionamento:**
   - Siga a convenção de Conventional Commits (`feat:`, `fix:`, `refactor:`, `docs:`, `test:`).
   - Escreva mensagens de commit em português ou inglês, mantendo a consistência do repositório.

4. **Testes e Qualidade:**
   - Novas funcionalidades devem vir acompanhadas de testes unitários ou de integração correspondentes.
