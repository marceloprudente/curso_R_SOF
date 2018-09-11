###############
## Aula 2 ----
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
setwd("C:/curso_r/dados")

## Baixar dados
# Base do sistema
exemplo1_base <- read.csv("C:/curso_r/dados/exemplo1.csv")
exemplo1_base

# Utilizando file.choose()
exemplo1_base <- read.csv(file.choose())

# Tidyverse - readr
exemplo1_tdv  <- read_csv("C:/curso_r/dados/exemplo1.csv")
head(exemplo1_tdv, 16)

# ou ainda, utilizar o file.choose
exemplo1_tdv <- read_csv(file.choose())

# como o diretório foi fixado, basta chamar o nome do arquivo
exemplo1_tdv <- read_csv("exemplo1.csv")


## Separado por ponto e virgula ----

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
exemplo4_s2  <- read_excel("exemplo4.xlsx", 
                           3sheet = 2)

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


#------------------------------------
# Baixar dados com fread()
# Para isso, chamar o pacote data.table
library(data.table)
ex1_fread <- fread("C:/curso_r/dados/exemplo1.csv",
                   nrows = 5)
ex1_fread

#------------------------------------
# Baixar dados do xlsx e xls

# Lendo os dados do excel
ex4 <- read_excel("C:/curso_r/dados/exemplo4.xlsx")

# Importar a segunda planilha
ex4_s2 <- read_excel("C:/curso_r/dados/exemplo4.xlsx", sheet = 2)

#------------------------------------
# Baixar dados dbc (DATASUS)
install.packages("read.dbc")
library(read.dbc)
sihsus <- read.dbc("C:/curso_r/dados/RDSE1701.dbc")

#-------------------------
# EXPORTAR DADOS NO R ----

# apenas identificando o separador
write.table(exemplo1_base, "C:/curso_r/meu_exemplo1.csv",
            sep = ";")

# identificando o separador e o decimal
write.table(exemplo1_base, "meu_exemplo2.csv",
            sep = ";", dec = ",")

# identificando o separador, o decimal e retirando os nomes das linhas
write.table(exemplo1_base, "meu_exemplo3.csv",
            sep = ";", dec = ",", row.names = FALSE)
# mais:
?write.table

#-------------------------------------------------------
# é possível exportar com o data.table
# nessa caso, o row.names já está falso de forma padrão
library(data.table)
?fwrite
fwrite(mpg, "C:/curso_r/meu_exemplo_data_table.csv",
       sep = ";", dec = ",")


