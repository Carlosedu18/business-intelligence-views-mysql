# Business Intelligence com Views para Relatórios Gerenciais

Projeto acadêmico desenvolvido em MySQL com foco no uso de Views para criação de relatórios gerenciais.

O objetivo é demonstrar como consultas SQL podem ser organizadas e reutilizadas para gerar informações úteis sobre vendas, lucro, produtos e desempenho de vendedores.

---

## Tecnologias utilizadas

- MySQL
- SQL
- Views
- Business Intelligence

---

## Estrutura do banco de dados

O banco utilizado no projeto é:

`vendas_gerenciais`

Ele possui 5 tabelas principais:

- `vendedores`
- `clientes`
- `produtos`
- `vendas`
- `itens_venda`

As tabelas estão relacionadas por meio de chaves primárias e estrangeiras.

### Relacionamentos principais

Vendedores → Vendas ← Clientes

Vendas → Itens da Venda → Produtos

---

## Objetivo do projeto

Criar relatórios gerenciais utilizando Views no MySQL para analisar:

- Vendas realizadas
- Lucro por período
- Produtos mais vendidos
- Desempenho dos vendedores

---

# Views desenvolvidas

## 1. Relatório de Vendas

View:

`vw_relatorio_vendas`

Essa View reúne informações detalhadas de cada item vendido.

Informações apresentadas:

- Data da venda
- Vendedor
- Cliente
- Produto
- Quantidade
- Preço unitário
- Subtotal

O subtotal é calculado utilizando:

```sql
quantidade * preco_unitario
