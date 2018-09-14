## Aula 2 ----

## Carregar pacotes
# o pacote readr está no tidyverse
library(tidyverse)
# pacote data.table - fread()
library(data.table)
## diretório
# getwd - descobrir o diretório
getwd()

# setwd - definir diretório onde estão os dados
setwd("C:/curso_r/dados")

# listar arquivos - para conferir dados
list.files()


# Baixar dados ----
###############################################
## Separado por vírgula "," e decimal "." ----
###############################################

# Base do sistema
exemplo1_base <- read.csv("C:/curso_r/dados/exemplo1.csv")
exemplo1_base

# o mesmo que:
exemplo1_base <- read.csv("exemplo1.csv", 
                          sep = "," ,
                          dec = "." )

# Utilizando file.choose()
exemplo1_base <- read.csv(file.choose())

# com o readr (tidyverse) 
exemplo1_tdv  <- read_csv("C:/curso_r/dados/exemplo1.csv")
head(exemplo1_tdv, 16)

# ou ainda, utilizar o file.choose
exemplo1_tdv <- read_csv(file.choose())

# como o diretório foi fixado, basta chamar o nome do arquivo
exemplo1_tdv <- read_csv("exemplo1.csv")

# com data.table()
exemplo1_fread <- fread("exemplo1.csv")
# o mesmo que:
exemplo1_fread <- fread("exemplo1.csv", dec = ".")

# sempre lembre de consultar os comandos
?fread

###################################################
## Separado por ponto e virgula e decimal ","----
###################################################

# Base do sistema
exemplo2_base <- read.csv2("exemplo2.csv")
head(exemplo2_base)

# Tidyverse - readr
exemplo2_tdv  <- read_csv2("exemplo2.csv")
head(exemplo2_tdv)

# data.table - fread
exemplo2_fread <- fread("exemplo2.csv", 
                       dec = ",")

# lembre de observar a estrutura do arquivo baixado
glimpse(exemplo2_fread)
str(exemplo2_fread)


#------------------------------------
# escolher colunas, limitar nº de linhas e pular linhas

# com o readr - read_csv e read_csv2 ----
## selecionar as 5 primeiras linhas
ex1_readr <- read_csv("exemplo1.csv", 
                      n_max = 5)
ex1_readr

## pular linhas
ex2_readr <- read_csv("exemplo1.csv", 
                      skip = 5)
                      

# com fread() ----
## selecionar as 5 primeiras linhas
ex1_fread <- fread("C:/curso_r/dados/exemplo1.csv",
                   nrows = 5)
ex1_fread

## selecionar as 3 primeiras colunas
ex2_fread <- fread("C:/curso_r/dados/exemplo1.csv",
                   select = 1:3)
ex2_fread

## pular linhas
ex3_fread <- fread("C:/curso_r/dados/exemplo1.csv",
                   skip = 3)
ex3_fread



########################################################
## O problema do encoding - predominante no tidyverse ##
########################################################

erro <- read_csv2("dados_sociais.csv")
head(erro$municipio, 15)

correto  <- read_csv2("dados_sociais.csv", 
                      locale = locale(encoding = "Latin1"))
correto

correto


##########################
## Ler dados do DATASUS ##
##########################
library(read.dbc) # verifique se o pacote está instalado

siahsus <- read.dbc("RDSE1701.dbc")

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



###############################
# Lendo os dados do excel ----
###############################

library(readxl)
exemplo4  <- read_excel("exemplo4.xlsx")

# Importar a segunda planilha
exemplo4_s2  <- read_excel("exemplo4.xlsx", 
                           sheet = 2)

# Importar a segunda planilha - pelo nome
exemplo4_s2  <- read_excel("exemplo4.xlsx", 
                           sheet = "mtcars")


# Exercício:
# leia todas as planilhas presentes no arquivo exemplo4.xlsx


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


