###############
## Aula 3 ----
###############

## Carregar pacotes
# o pacote readr está no tidyverse
library(tidyverse)

# é possível baixá-lo individualmente
library(readr)

## diretorio
# getwd - descobrir o diretório
getwd()

# setwd - definir diretório
setwd("C:/curso_r_enap/dados")

## Baixar dados
# Base do sistema
exemplo1_base <- read.csv("C:/curso_r_enap/dados/exemplo1.csv")
exemplo1_base

# Tidyverse - readr
exemplo1_tdv  <- read_csv("C:/curso_r_enap/dados/exemplo1.csv")
head(exemplo1_tdv, 16)

# ou ainda, utilizar o file.choose
exemplo1_tdv <- read_csv(file.choose())

# como o diretório foi fixado, basta chamar o nome do arquivo
exemplo1_tdv <- read_csv("exemplo1.csv")


## Separado por ponto e virgula

# Base do sistema
exemplo2_base <- read.csv2("exemplo2.csv")
head(exemplo2_base)

# Tidyverse - readr
exemplo2_tdv  <- read_csv2("exemplo2.csv")
head(exemplo2_tdv)

# Lendo os dados do excel
library(readxl)
exemplo4  <- read_excel("exemplo4.xlsx")

# Importar a segunda planilha
exemplo4_s2  <- read_excel("exemplo4.xlsx", sheet = 2)

# Tidyverse - o problema do encoding
erro <- read_csv2("dados_sociais.csv")
erro

correto  <- read_csv2("dados_sociais.csv", 
                          locale = locale(encoding = "Latin1"))
correto

################
# Exercício 1 #
###############
# baixe o arquivo exemplo2.csv

# qual a classe do banco de dados?

# quais as classes das variáveis do banco?

# quais os nomes das variáveis do banco? crie um vetor

# como visualizar esses dados?

# como extrair a média da esperança de vida?

# qual o máximo e o minimo desta variável?


########################
## Maniputação Básica ##
########################

x <- c("João", "Pedro", "Carlos", "Maria", "Josefa",
       "Mariana", "João", "José", "Mariana", 
       "Carlos", "José", "João")
unique(x)
length(unique(x))

# com o banco de dados
dados_sociais <- read_csv2("dados_sociais.csv")
unique(dados_sociais$uf)

# Quantas vezes cada nome aparece
table(x)

# Quantas vezes cada UF aparece
table(dados_sociais$uf)

# Quantas vezes cada UF aparece por ano
table(dados_sociais$uf, dados_sociais$ano)

##########################
## Subconjunto dos dados #
##########################


# Exemplo: selecionar o Rio de Janeiro 
b_rj <- subset(dados_sociais, uf == 33, 
               select = c("ano", "municipio", "pop"))


######################
# Renomear variáveis #
######################
nomes <- colnames(dados_sociais)

# Atribuindo um novo nome
nomes[2] <- "UF"
  
nomes

# De forma direta
colnames(dados_sociais)[2] <- "UF"

# maiusculas
toupper("nome")
nomes <- toupper(colnames(dados_sociais))

# minusculas
tolower(nomes)

# minusculas no vetor
tolower(dados_sociais$municipio)
